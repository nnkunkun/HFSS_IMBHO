function main_vivaldi_parameter_sweep(varargin)
    clc; close all;

    requested_samples = [];
    run_label = 'sweep';
    if nargin >= 1 && ~isempty(varargin{1})
        requested_samples = varargin{1};
    end
    if nargin >= 2 && ~isempty(varargin{2})
        run_label = char(string(varargin{2}));
    end

    config = get_vivaldi_sweep_config(requested_samples, run_label);
    parameter_defs = get_vivaldi_parameter_definitions();
    parameter_names = parameter_defs(:, 1);
    export_types = {
        'S11',  'S11';
        'Gain', 'Gain';
    };

    rng(config.random_seed, 'twister');
    ensure_directory(config.results_dir);
    ensure_directory(config.temp_project_dir);

    write_sweep_definition(parameter_defs, config.nominal_parameters, ...
        fullfile(config.results_dir, 'sweep_definition.csv'));

    sampled_values = generate_param_combinations(parameter_defs(:, 1:3), config.n_lhs_samples);
    sampled_table = array2table(sampled_values, 'VariableNames', parameter_names);
    writetable(sampled_table, fullfile(config.results_dir, 'planned_parameter_samples.csv'));

    fprintf('Project: %s\n', config.hfss_project);
    fprintf('Design : %s\n', config.design_name);
    fprintf('Runs   : %d\n', config.n_lhs_samples);
    fprintf('Output : %s\n', config.results_dir);
    fprintf('Sweeps : %s\n', strjoin(parameter_names', ', '));

    results_log = initialize_vivaldi_results_log(parameter_names, config.n_lhs_samples);
    all_s11_data = table();
    all_gain_data = table();
    start_time = datetime('now');

    for sim_idx = 1:config.n_lhs_samples
        simulation_id = sprintf('SIM%03d', sim_idx);
        swept_params = row_to_param_struct(parameter_names, sampled_values(sim_idx, :));
        run_params = config.nominal_parameters;
        run_params = merge_struct_values(run_params, swept_params);

        fprintf('\n=== Simulation %d/%d (%s) ===\n', sim_idx, config.n_lhs_samples, simulation_id);
        print_param_struct(swept_params);

        [success, raw_files, error_message] = run_single_vivaldi_simulation( ...
            run_params, export_types, simulation_id, config);

        clean_files = struct('S11', "", 'Gain', "");
        metrics = create_empty_metrics();

        if success
            try
                [s11_table, clean_files.S11] = normalize_export_file( ...
                    raw_files.S11, 'S11', simulation_id, swept_params, config.results_dir);
                [gain_table, clean_files.Gain] = normalize_export_file( ...
                    raw_files.Gain, 'Gain', simulation_id, swept_params, config.results_dir);

                metrics = summarize_curves(s11_table, gain_table);

                if ~isempty(s11_table)
                    if isempty(all_s11_data)
                        all_s11_data = s11_table;
                    else
                        all_s11_data = [all_s11_data; s11_table]; %#ok<AGROW>
                    end
                end

                if ~isempty(gain_table)
                    if isempty(all_gain_data)
                        all_gain_data = gain_table;
                    else
                        all_gain_data = [all_gain_data; gain_table]; %#ok<AGROW>
                    end
                end
            catch ME
                success = false;
                error_message = string(ME.message);
            end
        end

        results_log = update_vivaldi_results_log(results_log, sim_idx, simulation_id, ...
            swept_params, raw_files, clean_files, metrics, success, error_message);
        results_log.Timestamp(sim_idx) = datetime('now');

        save_progress_snapshot(results_log, config.results_dir);
        elapsed_minutes = minutes(datetime('now') - start_time);
        fprintf('Elapsed time: %.1f minutes\n', elapsed_minutes);
    end

    finalize_outputs(results_log, all_s11_data, all_gain_data, config.results_dir);

    total_time = datetime('now') - start_time;
    fprintf('\n=== Completed ===\n');
    fprintf('Successful runs: %d / %d\n', sum(results_log.Success), height(results_log));
    fprintf('Total runtime : %s\n', char(total_time));
    fprintf('Results folder: %s\n', config.results_dir);
end

function config = get_vivaldi_sweep_config(requested_samples, run_label)
    timestamp = char(datetime('now', 'Format', 'yyyyMMdd_HHmmss'));

    config = struct();
    config.hfss_project = 'W:\Formal\Vivaldi\Vivaldi_ATK.aedt';
    config.design_name = 'Vivaldi_ATK';
    config.base_results_dir = 'W:\Formal\Vivaldi\DATA\results';
    config.results_dir = fullfile(config.base_results_dir, ['vivaldi_', run_label, '_', timestamp]);
    config.temp_project_dir = fullfile(config.results_dir, 'hfss_temp_projects');
    % 在这里改！！！！
    config.n_lhs_samples = 200;
    if nargin >= 1 && ~isempty(requested_samples)
        validateattributes(requested_samples, {'numeric'}, {'scalar', 'integer', '>=', 1});
        config.n_lhs_samples = double(requested_samples);
    end
    config.random_seed = 20260413;
    config.keep_temp_projects = false;
    config.nominal_parameters = get_vivaldi_nominal_parameters();
    config.parameter_units = get_vivaldi_parameter_units();
end

function parameter_defs = get_vivaldi_parameter_definitions()
    % Selected 6 sweep variables from the AEDT variables shown in the image.
    % They cover both the flare section and the stripline transition.
    parameter_defs = {
        'Wslot',         0.0100, 0.0400, 0.0200;
        'Wtaper',        1.6800, 2.0600, 1.8700;
        'Ltapper',       3.3800, 4.1200, 3.7500;
        'Wbalun',        0.2800, 0.4200, 0.3500;
        'Wstrip',        0.1150, 0.1550, 0.1328;
        'Lstrip_offset', 0.2500, 0.4500, 0.3500;
    };
end

function params = get_vivaldi_nominal_parameters()
    params = struct( ...
        'Wslot', 0.0200, ...
        'Lfeed', 0.0000, ...
        'Wtaper', 1.8700, ...
        'Ltapper', 3.7500, ...
        'Wbalun', 0.3500, ...
        'Lbalun', 0.3500, ...
        'NumberOfPoints', 20, ...
        'Wstrip', 0.1328, ...
        'Lstrip', 0.5000, ...
        'Lstrip_offset', 0.3500, ...
        'feed_offset', 0.0000, ...
        'subH', 0.1575, ...
        'subX', 3.7500, ...
        'subY', 4.6000);
end

function units = get_vivaldi_parameter_units()
    units = struct( ...
        'Wslot', 'cm', ...
        'Lfeed', 'cm', ...
        'Wtaper', 'cm', ...
        'Ltapper', 'cm', ...
        'Wbalun', 'cm', ...
        'Lbalun', 'cm', ...
        'NumberOfPoints', '', ...
        'Wstrip', 'cm', ...
        'Lstrip', 'cm', ...
        'Lstrip_offset', 'cm', ...
        'feed_offset', 'cm', ...
        'subH', 'cm', ...
        'subX', 'cm', ...
        'subY', 'cm');
end

function results_log = initialize_vivaldi_results_log(parameter_names, total_runs)
    variable_names = [{'SimulationID'}, parameter_names', ...
        {'S11_Raw_File', 'S11_Clean_File', 'Gain_Raw_File', 'Gain_Clean_File', ...
         'MinS11_dB', 'MinS11_Freq_GHz', 'PeakGain_dB', 'PeakGain_Theta_deg', ...
         'Timestamp', 'Success', 'ErrorMessage'}];

    results_log = table('Size', [total_runs, numel(variable_names)], ...
        'VariableTypes', [ ...
            {'string'}, repmat({'double'}, 1, numel(parameter_names)), ...
            {'string', 'string', 'string', 'string', ...
             'double', 'double', 'double', 'double', ...
             'datetime', 'logical', 'string'}], ...
        'VariableNames', variable_names);

    results_log.Timestamp(:) = NaT;
    results_log.Success(:) = false;
    results_log.ErrorMessage(:) = "";
    results_log.S11_Raw_File(:) = "";
    results_log.S11_Clean_File(:) = "";
    results_log.Gain_Raw_File(:) = "";
    results_log.Gain_Clean_File(:) = "";
end

function param_struct = row_to_param_struct(parameter_names, row_values)
    param_struct = struct();
    for idx = 1:numel(parameter_names)
        param_struct.(parameter_names{idx}) = row_values(idx);
    end
end

function merged = merge_struct_values(base_struct, override_struct)
    merged = base_struct;
    names = fieldnames(override_struct);
    for idx = 1:numel(names)
        merged.(names{idx}) = override_struct.(names{idx});
    end
end

function print_param_struct(params)
    names = fieldnames(params);
    parts = strings(numel(names), 1);
    for idx = 1:numel(names)
        parts(idx) = sprintf('%s=%.4fcm', names{idx}, params.(names{idx}));
    end
    fprintf('%s\n', strjoin(parts, ', '));
end

function [success, raw_files, error_message] = run_single_vivaldi_simulation( ...
        parameter_values, export_types, simulation_id, config)

    success = false;
    error_message = "";
    raw_files = struct('S11', "", 'Gain', "");
    temp_project_path = "";
    hfss = [];
    project = [];

    for attempt = 1:3
        try
            temp_project_path = create_temp_project_copy(config, simulation_id);

            hfss = actxserver('AnsoftHfss.HfssScriptInterface');
            desktop = hfss.GetAppDesktop();
            desktop.RestoreWindow();

            project = desktop.OpenProject(temp_project_path);
            design = project.SetActiveDesign(config.design_name);

            apply_parameter_values(design, parameter_values, config.parameter_units);
            project.Save();

            fprintf('Running HFSS analysis...\n');
            design.AnalyzeAll();
            pause(5);

            report_module = design.GetModule('ReportSetup');
            report_names = cellstr(report_module.GetAllReportNames());

            for idx = 1:size(export_types, 1)
                export_name = export_types{idx, 1};
                report_name = export_types{idx, 2};
                output_file = fullfile(config.results_dir, [simulation_id, '_', export_name, '.csv']);

                assert_report_exists(report_name, report_names);
                export_report(report_module, report_name, output_file);
                raw_files.(export_name) = string(output_file);
            end

            success = true;
            break;
        catch ME
            error_message = string(ME.message);
            fprintf('Attempt %d failed: %s\n', attempt, ME.message);
            pause(5);
        end

        close_hfss_project(project);
        project = [];
        release_com_object(hfss);
        hfss = [];
        cleanup_temp_project_copy(temp_project_path, config.keep_temp_projects);
        temp_project_path = "";
    end

    close_hfss_project(project);
    release_com_object(hfss);
    cleanup_temp_project_copy(temp_project_path, config.keep_temp_projects);
end

function temp_project_path = create_temp_project_copy(config, simulation_id)
    source_project = config.hfss_project;
    [~, base_name, ext] = fileparts(source_project);
    temp_project_path = fullfile(config.temp_project_dir, ...
        sprintf('%s_%s%s', base_name, simulation_id, ext));

    copyfile(source_project, temp_project_path, 'f');
    try_delete_file([temp_project_path, '.lock']);
end

function cleanup_temp_project_copy(temp_project_path, keep_temp_projects)
    if strlength(string(temp_project_path)) == 0 || keep_temp_projects
        return;
    end

    try_delete_file(temp_project_path);
    try_delete_file([temp_project_path, '.lock']);
    try_delete_dir([temp_project_path, 'results']);
end

function close_hfss_project(project)
    if isempty(project)
        return;
    end

    try
        project.Close();
    catch
    end
end

function release_com_object(com_object)
    if isempty(com_object)
        return;
    end

    try
        delete(com_object);
    catch
    end
end

function apply_parameter_values(design, parameter_values, parameter_units)
    names = fieldnames(parameter_values);
    for idx = 1:numel(names)
        parameter_name = names{idx};
        parameter_value = parameter_values.(parameter_name);
        unit_suffix = '';

        if isfield(parameter_units, parameter_name)
            unit_suffix = parameter_units.(parameter_name);
        end

        if isnumeric(parameter_value)
            if isempty(unit_suffix)
                value_string = sprintf('%.0f', parameter_value);
            else
                value_string = sprintf('%.4f%s', parameter_value, unit_suffix);
            end
        else
            value_string = char(parameter_value);
        end

        design.SetVariableValue(parameter_name, value_string);
        fprintf('  %s = %s\n', parameter_name, value_string);
    end
end

function assert_report_exists(report_name, report_names)
    if any(strcmp(report_names, report_name))
        return;
    end

    available = strjoin(report_names, ', ');
    error('HFSS report "%s" was not found. Available reports: %s', report_name, available);
end

function export_report(report_module, report_name, output_file)
    if exist(output_file, 'file')
        delete(output_file);
    end

    report_module.ExportToFile(report_name, output_file);
    wait_for_file(output_file, 30);
end

function wait_for_file(file_path, timeout_seconds)
    started = tic;
    while toc(started) < timeout_seconds
        if exist(file_path, 'file')
            info = dir(file_path);
            if ~isempty(info) && info.bytes > 32
                return;
            end
        end
        pause(1);
    end

    error('Exported file was not created in time: %s', file_path);
end

function [clean_table, clean_file] = normalize_export_file( ...
        raw_file, export_kind, simulation_id, swept_params, results_dir)

    raw_path = char(raw_file);
    imported = readtable_with_preserved_names(raw_path);

    switch upper(export_kind)
        case 'S11'
            clean_table = normalize_s11_table(imported);
            clean_file = fullfile(results_dir, [simulation_id, '_S11_clean.csv']);
        case 'GAIN'
            clean_table = normalize_gain_table(imported);
            clean_file = fullfile(results_dir, [simulation_id, '_Gain_clean.csv']);
        otherwise
            error('Unsupported export kind: %s', export_kind);
    end

    clean_table.SimulationID = repmat(string(simulation_id), height(clean_table), 1);

    param_names = fieldnames(swept_params);
    for idx = 1:numel(param_names)
        clean_table.(param_names{idx}) = repmat(swept_params.(param_names{idx}), height(clean_table), 1);
    end

    move_columns = [string(get_primary_columns(export_kind)), "SimulationID", string(param_names')];
    keep_order = intersect(cellstr(move_columns), clean_table.Properties.VariableNames, 'stable');
    clean_table = clean_table(:, keep_order);

    writetable(clean_table, clean_file);
    clean_file = string(clean_file);
end

function primary_columns = get_primary_columns(export_kind)
    switch upper(export_kind)
        case 'S11'
            primary_columns = {'Freq_GHz', 'S11_dB'};
        case 'GAIN'
            primary_columns = {'Theta_deg', 'Gain_dB'};
        otherwise
            primary_columns = {};
    end
end

function imported = readtable_with_preserved_names(filename)
    opts = detectImportOptions(filename);
    opts.VariableNamingRule = 'preserve';
    imported = readtable(filename, opts);
end

function clean_table = normalize_s11_table(imported)
    freq_idx = find_matching_column(imported.Properties.VariableNames, {'Freq'});
    s11_idx = find_matching_column(imported.Properties.VariableNames, ...
        {'St(', 'S(', 'S11', 'dB'});

    if isempty(freq_idx) || isempty(s11_idx)
        error('Unable to identify Freq/S11 columns in S11 export.');
    end

    freq_header = imported.Properties.VariableNames{freq_idx};
    s11_header = imported.Properties.VariableNames{s11_idx};

    freq_values = to_numeric_vector(imported.(freq_header));
    freq_values = convert_frequency_to_ghz(freq_values, freq_header);
    s11_values = to_numeric_vector(imported.(s11_header));

    clean_table = table(freq_values, s11_values, ...
        'VariableNames', {'Freq_GHz', 'S11_dB'});
    clean_table = clean_table(~isnan(clean_table.Freq_GHz) & ~isnan(clean_table.S11_dB), :);
    clean_table = sortrows(clean_table, 'Freq_GHz');
end

function clean_table = normalize_gain_table(imported)
    theta_idx = find_matching_column(imported.Properties.VariableNames, {'Theta'});
    gain_idx = find_matching_column(imported.Properties.VariableNames, {'Gain', 'dB'});

    if isempty(theta_idx) || isempty(gain_idx)
        error('Unable to identify Theta/Gain columns in Gain export.');
    end

    theta_header = imported.Properties.VariableNames{theta_idx};
    gain_header = imported.Properties.VariableNames{gain_idx};

    theta_values = to_numeric_vector(imported.(theta_header));
    gain_values = to_numeric_vector(imported.(gain_header));

    clean_table = table(theta_values, gain_values, ...
        'VariableNames', {'Theta_deg', 'Gain_dB'});
    clean_table = clean_table(~isnan(clean_table.Theta_deg) & ~isnan(clean_table.Gain_dB), :);
    clean_table = sortrows(clean_table, 'Theta_deg');
end

function column_index = find_matching_column(variable_names, patterns)
    column_index = [];

    for pattern_idx = 1:numel(patterns)
        matches = find(contains(variable_names, patterns{pattern_idx}, 'IgnoreCase', true));
        if ~isempty(matches)
            column_index = matches(1);
            return;
        end
    end
end

function numeric_values = to_numeric_vector(values)
    if isnumeric(values)
        numeric_values = values;
        return;
    end

    if iscell(values)
        numeric_values = str2double(string(values));
        return;
    end

    numeric_values = str2double(string(values));
end

function freq_ghz = convert_frequency_to_ghz(freq_values, header_name)
    name_lower = lower(header_name);

    if contains(name_lower, 'ghz')
        scale = 1.0;
    elseif contains(name_lower, 'mhz')
        scale = 1e-3;
    elseif contains(name_lower, 'khz')
        scale = 1e-6;
    elseif contains(name_lower, 'hz')
        scale = 1e-9;
    else
        scale = 1.0;
    end

    freq_ghz = freq_values .* scale;
end

function metrics = create_empty_metrics()
    metrics = struct( ...
        'MinS11_dB', NaN, ...
        'MinS11_Freq_GHz', NaN, ...
        'PeakGain_dB', NaN, ...
        'PeakGain_Theta_deg', NaN);
end

function metrics = summarize_curves(s11_table, gain_table)
    metrics = create_empty_metrics();

    if ~isempty(s11_table)
        [metrics.MinS11_dB, idx] = min(s11_table.S11_dB);
        metrics.MinS11_Freq_GHz = s11_table.Freq_GHz(idx);
    end

    if ~isempty(gain_table)
        [metrics.PeakGain_dB, idx] = max(gain_table.Gain_dB);
        metrics.PeakGain_Theta_deg = gain_table.Theta_deg(idx);
    end
end

function results_log = update_vivaldi_results_log(results_log, row_index, simulation_id, ...
        swept_params, raw_files, clean_files, metrics, success, error_message)

    results_log.SimulationID(row_index) = string(simulation_id);

    param_names = fieldnames(swept_params);
    for idx = 1:numel(param_names)
        results_log.(param_names{idx})(row_index) = swept_params.(param_names{idx});
    end

    results_log.S11_Raw_File(row_index) = get_struct_string(raw_files, 'S11');
    results_log.S11_Clean_File(row_index) = get_struct_string(clean_files, 'S11');
    results_log.Gain_Raw_File(row_index) = get_struct_string(raw_files, 'Gain');
    results_log.Gain_Clean_File(row_index) = get_struct_string(clean_files, 'Gain');
    results_log.MinS11_dB(row_index) = metrics.MinS11_dB;
    results_log.MinS11_Freq_GHz(row_index) = metrics.MinS11_Freq_GHz;
    results_log.PeakGain_dB(row_index) = metrics.PeakGain_dB;
    results_log.PeakGain_Theta_deg(row_index) = metrics.PeakGain_Theta_deg;
    results_log.Success(row_index) = logical(success);
    results_log.ErrorMessage(row_index) = string(error_message);
end

function value = get_struct_string(source_struct, field_name)
    value = "";
    if isfield(source_struct, field_name)
        value = string(source_struct.(field_name));
    end
end

function save_progress_snapshot(results_log, results_dir)
    writetable(results_log, fullfile(results_dir, 'progress_summary.csv'));
end

function finalize_outputs(results_log, all_s11_data, all_gain_data, results_dir)
    writetable(results_log, fullfile(results_dir, 'summary_metrics.csv'));

    try
        writetable(results_log, fullfile(results_dir, 'summary_metrics.xlsx'));
    catch
    end

    save(fullfile(results_dir, 'summary_metrics.mat'), 'results_log');

    if ~isempty(all_s11_data)
        writetable(all_s11_data, fullfile(results_dir, 'all_s11_data.csv'));
    end

    if ~isempty(all_gain_data)
        writetable(all_gain_data, fullfile(results_dir, 'all_gain_data.csv'));
    end
end

function write_sweep_definition(parameter_defs, nominal_parameters, output_file)
    names = parameter_defs(:, 1);
    min_values = cell2mat(parameter_defs(:, 2));
    max_values = cell2mat(parameter_defs(:, 3));
    nominal_values = zeros(numel(names), 1);

    for idx = 1:numel(names)
        nominal_values(idx) = nominal_parameters.(names{idx});
    end

    definition_table = table(string(names), nominal_values, min_values, max_values, ...
        'VariableNames', {'Parameter', 'Nominal_cm', 'Min_cm', 'Max_cm'});
    writetable(definition_table, output_file);
end

function ensure_directory(folder_path)
    if ~exist(folder_path, 'dir')
        mkdir(folder_path);
    end
end

function try_delete_file(file_path)
    if exist(file_path, 'file')
        delete(file_path);
    end
end

function try_delete_dir(dir_path)
    if exist(dir_path, 'dir')
        rmdir(dir_path, 's');
    end
end
