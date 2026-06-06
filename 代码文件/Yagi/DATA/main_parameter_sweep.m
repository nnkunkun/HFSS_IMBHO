function results_log = main_parameter_sweep()
    clc;
    close all;

    config = build_config();
    parameters_to_sweep = {
        'Ldir', 14.5, 18.5;
        'Ldri', 40.0, 47.0;
        'L1',   14.5, 18.5;
        'Sdir', 12.0, 18.0;
        'Sref', 16.5, 22.5;
        'Wdri',  2.0,  4.5;
    };
    export_types = {
        'S11',       'S11';
        'S11F0',     'ATK_OBJ_S11_F0';
        'PeakGain',  'ATK_OBJ_PeakGain';
        'GainPhi90', 'ATK_OBJ_Cut_Phi90';
        'GainPhi0',  'ATK_OBJ_Cut_Phi0';
    };

    ensure_directory(config.results_dir);
    ensure_directory(config.temp_project_dir);

    fprintf('=== Quasi-Yagi four-objective sweep ===\n');
    fprintf('Project : %s\n', config.hfss_project);
    fprintf('Design  : %s\n', config.design_name);
    fprintf('Results : %s\n', config.results_dir);
    fprintf('f0      : %.3f GHz\n', config.operating_freq_ghz);

    warn_if_source_project_open(config.hfss_project);

    param_combinations = generate_param_combinations(parameters_to_sweep, config.n_lhs_samples);
    total_simulations = size(param_combinations, 1);
    if total_simulations == 0
        fprintf('No parameter combinations were generated.\n');
        results_log = table();
        return;
    end

    print_parameter_summary(parameters_to_sweep, param_combinations);

    if config.enable_sampling_plots
        try
            visualize_lhs_sampling(param_combinations, parameters_to_sweep);
        catch ME
            fprintf('Sampling plots were skipped: %s\n', ME.message);
        end
    end

    results_log = initialize_yagi_results_log(parameters_to_sweep, total_simulations);
    start_time = datetime('now');

    for sim_idx = 1:total_simulations
        simulation_id = sprintf('sim_%03d', sim_idx);
        current_params = row_to_param_struct(parameters_to_sweep, param_combinations(sim_idx, :));

        fprintf('\n=== Simulation %d/%d (%s) ===\n', sim_idx, total_simulations, simulation_id);
        print_parameter_row(current_params);

        [success, export_files, processed_files, objective_values] = run_single_simulation( ...
            current_params, export_types, simulation_id, sim_idx, config);

        results_log = update_results_log( ...
            results_log, sim_idx, simulation_id, current_params, export_files, processed_files, objective_values, success);
        results_log.Timestamp(sim_idx) = datetime('now');

        save_progress(results_log, config.results_dir);

        elapsed_minutes = minutes(datetime('now') - start_time);
        fprintf('Progress saved. Elapsed time: %.1f minutes\n', elapsed_minutes);
    end

    combine_processed_results(results_log, config.results_dir);
    save_final_results(results_log, config.results_dir);

    total_time = datetime('now') - start_time;
    success_count = sum(results_log.Success);

    fprintf('\n=== Sweep complete ===\n');
    fprintf('Total simulations : %d\n', total_simulations);
    fprintf('Successful runs   : %d\n', success_count);
    fprintf('Failed runs       : %d\n', total_simulations - success_count);
    fprintf('Total runtime     : %s\n', char(total_time));
    fprintf('Average / run     : %.1f minutes\n', minutes(total_time) / total_simulations);
end

function config = build_config()
    data_dir = fileparts(mfilename('fullpath'));
    project_root = fileparts(data_dir);

    config.hfss_exe_path = 'P:\HFSS\v242\Win64\ansysedt.exe';
    config.hfss_project = fullfile(project_root, 'Quasi_Yagi_ATK.aedt');
    config.design_name = 'Quasi_Yagi_ATK';
    config.results_dir = fullfile(data_dir, 'results');
    config.temp_project_dir = fullfile(config.results_dir, 'hfss_temp_projects');
    config.keep_temp_projects = false;
    config.parameter_unit = 'mm';
    config.operating_freq_ghz = 2.25;
    %在这里改组数！！
    config.n_lhs_samples = 200;
    config.enable_sampling_plots = true;
    config.max_export_wait_seconds = 30;
end

function ensure_directory(dir_path)
    if ~exist(dir_path, 'dir')
        mkdir(dir_path);
    end
end

function warn_if_source_project_open(project_path)
    lock_path = [project_path, '.lock'];
    if ~exist(lock_path, 'file')
        return;
    end

    desktop_pid = read_lock_process_id(lock_path);
    if ~isempty(desktop_pid) && is_process_running(desktop_pid)
        fprintf(['Warning: the source HFSS project is currently open (PID %d). ', ...
            'The sweep will use the last saved state on disk, not unsaved GUI edits.\n'], desktop_pid);
    end
end

function print_parameter_summary(parameters_to_sweep, param_combinations)
    fprintf('\nSelected sweep variables:\n');
    for idx = 1:size(parameters_to_sweep, 1)
        fprintf('  %-5s : %.3f mm -> %.3f mm\n', ...
            parameters_to_sweep{idx, 1}, parameters_to_sweep{idx, 2}, parameters_to_sweep{idx, 3});
    end

    fprintf('\nSampling statistics:\n');
    for idx = 1:size(parameters_to_sweep, 1)
        values = param_combinations(:, idx);
        fprintf('  %-5s : min=%.3f  max=%.3f  mean=%.3f\n', ...
            parameters_to_sweep{idx, 1}, min(values), max(values), mean(values));
    end
end

function params = row_to_param_struct(parameters_to_sweep, param_row)
    params = struct();
    for idx = 1:size(parameters_to_sweep, 1)
        params.(parameters_to_sweep{idx, 1}) = param_row(idx);
    end
end

function print_parameter_row(params)
    param_names = fieldnames(params);
    parts = strings(numel(param_names), 1);
    for idx = 1:numel(param_names)
        parts(idx) = sprintf('%s=%.3fmm', param_names{idx}, params.(param_names{idx}));
    end
    fprintf('%s\n', strjoin(parts, '  '));
end

function results_log = initialize_yagi_results_log(parameters_to_sweep, total_sims)
    param_names = parameters_to_sweep(:, 1)';
    param_columns = repmat({NaN(total_sims, 1)}, 1, numel(param_names));

    results_log = table(param_columns{:}, 'VariableNames', param_names);
    results_log.SimulationID = strings(total_sims, 1);
    results_log.S11_File = strings(total_sims, 1);
    results_log.S11F0_File = strings(total_sims, 1);
    results_log.PeakGain_File = strings(total_sims, 1);
    results_log.GainPhi90_File = strings(total_sims, 1);
    results_log.GainPhi0_File = strings(total_sims, 1);
    results_log.ProcessedS11_File = strings(total_sims, 1);
    results_log.ScalarMetrics_File = strings(total_sims, 1);
    results_log.Patterns_File = strings(total_sims, 1);
    results_log.Objectives_File = strings(total_sims, 1);
    results_log.MainPlane = strings(total_sims, 1);
    results_log.Gmain_Source = strings(total_sims, 1);
    results_log.S11_Source = strings(total_sims, 1);
    results_log.Gmain_dBi = NaN(total_sims, 1);
    results_log.Gmain_Cut_dBi = NaN(total_sims, 1);
    results_log.PeakRealizedGain_dBi = NaN(total_sims, 1);
    results_log.FrontToBackRatio_dB = NaN(total_sims, 1);
    results_log.SLL_dB = NaN(total_sims, 1);
    results_log.HPBW_deg = NaN(total_sims, 1);
    results_log.S11_f0_dB = NaN(total_sims, 1);
    results_log.AbsS11_f0_dB = NaN(total_sims, 1);
    results_log.AbsS11_f0_Linear = NaN(total_sims, 1);
    results_log.Objective1_Neg_Gmain = NaN(total_sims, 1);
    results_log.Objective2_SLL = NaN(total_sims, 1);
    results_log.Objective3_HPBW = NaN(total_sims, 1);
    results_log.Objective4_AbsS11 = NaN(total_sims, 1);
    results_log.Timestamp = NaT(total_sims, 1);
    results_log.Success = false(total_sims, 1);
end

function [success, export_files, processed_files, objective_values] = run_single_simulation( ...
        params, export_types, simulation_id, sim_idx, config)

    success = false;
    export_files = struct('S11', "", 'S11F0', "", 'PeakGain', "", 'GainPhi90', "", 'GainPhi0', "");
    processed_files = struct('ProcessedS11', "", 'ScalarMetrics', "", 'Patterns', "", 'Objectives', "");
    objective_values = empty_objective_values();

    try
        run_hfss_com(params, export_types, simulation_id, config);
        export_files = verify_exported_files(export_types, simulation_id, config.results_dir);

        if ~all_exports_exist(export_files, export_types)
            fprintf('One or more export files are missing.\n');
            return;
        end

        processed_bundle = process_exported_results(export_files, params, sim_idx, simulation_id, config);
        processed_files = save_processed_bundle(processed_bundle, simulation_id, config.results_dir);
        objective_values = table_to_objective_values(processed_bundle.objectives);

        success = true;
        fprintf('Simulation completed successfully.\n');
    catch ME
        fprintf('Simulation failed: %s\n', ME.message);
        fprintf('%s\n', getReport(ME, 'extended'));
    end
end

function tf = all_exports_exist(export_files, export_types)
    tf = true;
    for idx = 1:size(export_types, 1)
        export_name = export_types{idx, 1};
        if ~isfield(export_files, export_name)
            tf = false;
            return;
        end

        file_path = export_files.(export_name);
        if strlength(string(file_path)) == 0 || ~exist(char(file_path), 'file')
            tf = false;
            return;
        end
    end
end

function bundle = process_exported_results(export_files, params, sim_idx, simulation_id, config)
    bundle = struct();

    s11_data = read_hfss_csv(export_files.S11);
    if isempty(s11_data) || ~all(ismember({'Freq_GHz', 'S11_dB'}, s11_data.Properties.VariableNames))
        error('S11 export does not contain Freq_GHz and S11_dB.');
    end

    s11_f0_data = read_hfss_csv(export_files.S11F0);
    peak_gain_data = read_hfss_csv(export_files.PeakGain);
    gain_phi90 = read_hfss_csv(export_files.GainPhi90);
    gain_phi0 = read_hfss_csv(export_files.GainPhi0);

    bundle.s11 = prepare_s11_table(s11_data, params, sim_idx, simulation_id);
    bundle.scalar_metrics = prepare_scalar_metrics_table( ...
        s11_f0_data, peak_gain_data, bundle.s11, params, sim_idx, simulation_id, config);
    bundle.patterns = [
        prepare_pattern_table(gain_phi90, 'Phi90', 90, params, sim_idx, simulation_id, config);
        prepare_pattern_table(gain_phi0, 'Phi0', 0, params, sim_idx, simulation_id, config)
    ];
    bundle.objectives = calculate_four_objectives( ...
        bundle.scalar_metrics, bundle.patterns, params, sim_idx, simulation_id, config);
end

function processed_s11 = prepare_s11_table(s11_data, params, sim_idx, simulation_id)
    processed_s11 = s11_data(:, {'Freq_GHz', 'S11_dB'});
    processed_s11 = sortrows(processed_s11, 'Freq_GHz');
    processed_s11 = add_metadata_columns(processed_s11, params, sim_idx, simulation_id);
end

function scalar_metrics = prepare_scalar_metrics_table( ...
        s11_f0_data, peak_gain_data, s11_sweep_data, params, sim_idx, simulation_id, config)

    [s11_sweep_dB, s11_sweep_freq] = sample_s11_at_f0(s11_sweep_data, config.operating_freq_ghz);
    [s11_report_dB, s11_report_freq] = extract_s11_report_value(s11_f0_data, config.operating_freq_ghz);
    [peak_gain_dbi, peak_realized_gain_dbi, front_to_back_ratio_db] = extract_peak_gain_report_values(peak_gain_data);

    s11_source = "S11";
    s11_f0_dB = s11_sweep_dB;
    if isfinite(s11_report_dB)
        s11_source = "ATK_OBJ_S11_F0";
        s11_f0_dB = s11_report_dB;
    end

    gmain_source = "";
    if isfinite(peak_gain_dbi)
        gmain_source = "ATK_OBJ_PeakGain";
    end

    scalar_struct = struct( ...
        'f0_GHz', config.operating_freq_ghz, ...
        'S11ReportFreq_GHz', s11_report_freq, ...
        'S11SweepSampleFreq_GHz', s11_sweep_freq, ...
        'S11SweepSample_dB', s11_sweep_dB, ...
        'S11_f0_dB', s11_f0_dB, ...
        'AbsS11_f0_dB', abs(s11_f0_dB), ...
        'AbsS11_f0_Linear', db20_to_linear(s11_f0_dB), ...
        'S11_Source', string(s11_source), ...
        'PeakGain_dBi', peak_gain_dbi, ...
        'PeakRealizedGain_dBi', peak_realized_gain_dbi, ...
        'FrontToBackRatio_dB', front_to_back_ratio_db, ...
        'Gmain_Source', string(gmain_source));

    scalar_metrics = struct2table(scalar_struct);
    scalar_metrics = add_metadata_columns(scalar_metrics, params, sim_idx, simulation_id);
end

function [s11_f0_dB, report_freq_ghz] = extract_s11_report_value(s11_f0_data, default_freq_ghz)
    s11_f0_dB = NaN;
    report_freq_ghz = NaN;

    if isempty(s11_f0_data) || ~ismember('S11_dB', s11_f0_data.Properties.VariableNames) || height(s11_f0_data) == 0
        return;
    end

    s11_f0_dB = s11_f0_data.S11_dB(1);
    if ismember('Freq_GHz', s11_f0_data.Properties.VariableNames)
        report_freq_ghz = s11_f0_data.Freq_GHz(1);
    else
        report_freq_ghz = default_freq_ghz;
    end
end

function [peak_gain_dbi, peak_realized_gain_dbi, front_to_back_ratio_db] = extract_peak_gain_report_values(peak_gain_data)
    peak_gain_dbi = NaN;
    peak_realized_gain_dbi = NaN;
    front_to_back_ratio_db = NaN;

    if isempty(peak_gain_data) || height(peak_gain_data) == 0
        return;
    end

    peak_gain_dbi = get_first_numeric_value(peak_gain_data, {'PeakGain_dBi', 'Gain_dBi'});
    peak_realized_gain_dbi = get_first_numeric_value(peak_gain_data, {'PeakRealizedGain_dBi'});
    front_to_back_ratio_db = get_first_numeric_value(peak_gain_data, {'FrontToBackRatio_dB', 'FrontToBackRatio'});
end

function value = get_first_numeric_value(data_table, candidate_names)
    value = NaN;
    for idx = 1:numel(candidate_names)
        variable_name = candidate_names{idx};
        if ~ismember(variable_name, data_table.Properties.VariableNames)
            continue;
        end

        column_data = data_table.(variable_name);
        if isnumeric(column_data) && ~isempty(column_data)
            value = column_data(1);
            return;
        end
    end
end

function processed_pattern = prepare_pattern_table( ...
        pattern_data, cut_name, phi_deg, params, sim_idx, simulation_id, config)

    if isempty(pattern_data) || ~all(ismember({'Theta_deg', 'Gain_dBi'}, pattern_data.Properties.VariableNames))
        error('Pattern export for %s does not contain Theta_deg and Gain_dBi.', cut_name);
    end

    keep_columns = {'Theta_deg', 'Gain_dBi'};
    if ismember('Phi_deg', pattern_data.Properties.VariableNames)
        keep_columns{end + 1} = 'Phi_deg';
    end
    if ismember('Freq_GHz', pattern_data.Properties.VariableNames)
        keep_columns{end + 1} = 'Freq_GHz';
    end

    processed_pattern = pattern_data(:, keep_columns);
    processed_pattern = sortrows(processed_pattern, 'Theta_deg');

    if ~ismember('Phi_deg', processed_pattern.Properties.VariableNames)
        processed_pattern.Phi_deg = repmat(phi_deg, height(processed_pattern), 1);
    end
    if ~ismember('Freq_GHz', processed_pattern.Properties.VariableNames)
        processed_pattern.Freq_GHz = repmat(config.operating_freq_ghz, height(processed_pattern), 1);
    end

    processed_pattern.CutName = repmat(string(cut_name), height(processed_pattern), 1);
    processed_pattern = movevars(processed_pattern, {'CutName', 'Theta_deg', 'Phi_deg', 'Freq_GHz', 'Gain_dBi'}, 'Before', 1);
    processed_pattern = add_metadata_columns(processed_pattern, params, sim_idx, simulation_id);
end

function data = add_metadata_columns(data, params, sim_idx, simulation_id)
    param_names = fieldnames(params);
    for idx = 1:numel(param_names)
        param_name = param_names{idx};
        data.(param_name) = repmat(params.(param_name), height(data), 1);
    end

    data.SimulationIndex = repmat(sim_idx, height(data), 1);
    data.SimulationID = repmat(string(simulation_id), height(data), 1);
end

function objective_table = calculate_four_objectives(scalar_metrics, patterns, params, sim_idx, simulation_id, config)
    cut_names = unique(patterns.CutName, 'stable');
    summaries = repmat(empty_pattern_summary(""), numel(cut_names), 1);

    for idx = 1:numel(cut_names)
        cut_name = cut_names(idx);
        cut_data = patterns(patterns.CutName == cut_name, :);
        summaries(idx) = evaluate_pattern_cut(cut_name, cut_data.Theta_deg, cut_data.Gain_dBi);
    end

    best_summary = pick_best_pattern_summary(summaries);
    phi0_summary = find_pattern_summary(summaries, "Phi0");
    phi90_summary = find_pattern_summary(summaries, "Phi90");
    scalar_row = table2struct(scalar_metrics(1, :));

    gmain_dbi = best_summary.Gmain_dBi;
    gmain_source = "PatternCuts";
    if isfinite(scalar_row.PeakGain_dBi)
        gmain_dbi = scalar_row.PeakGain_dBi;
        gmain_source = string(scalar_row.Gmain_Source);
    end

    objective_struct = struct( ...
        'SimulationIndex', sim_idx, ...
        'SimulationID', string(simulation_id), ...
        'f0_GHz', config.operating_freq_ghz, ...
        'S11ReportFreq_GHz', scalar_row.S11ReportFreq_GHz, ...
        'S11SweepSampleFreq_GHz', scalar_row.S11SweepSampleFreq_GHz, ...
        'S11SweepSample_dB', scalar_row.S11SweepSample_dB, ...
        'S11_Source', string(scalar_row.S11_Source), ...
        'Gmain_Source', string(gmain_source), ...
        'MainPlane', string(best_summary.CutName), ...
        'Gmain_dBi', gmain_dbi, ...
        'Gmain_Cut_dBi', best_summary.Gmain_dBi, ...
        'PeakGain_dBi', scalar_row.PeakGain_dBi, ...
        'PeakRealizedGain_dBi', scalar_row.PeakRealizedGain_dBi, ...
        'FrontToBackRatio_dB', scalar_row.FrontToBackRatio_dB, ...
        'SLL_dB', best_summary.SLL_dB, ...
        'HPBW_deg', best_summary.HPBW_deg, ...
        'SideLobeSuppression_dB', best_summary.SideLobeSuppression_dB, ...
        'MainLobeTheta_deg', best_summary.MainLobeTheta_deg, ...
        'SideLobeTheta_deg', best_summary.SideLobeTheta_deg, ...
        'SideLobeGain_dBi', best_summary.SideLobeGain_dBi, ...
        'S11_f0_dB', scalar_row.S11_f0_dB, ...
        'AbsS11_f0_dB', scalar_row.AbsS11_f0_dB, ...
        'AbsS11_f0_Linear', scalar_row.AbsS11_f0_Linear, ...
        'Objective1_Neg_Gmain', -gmain_dbi, ...
        'Objective2_SLL', best_summary.SLL_dB, ...
        'Objective3_HPBW', best_summary.HPBW_deg, ...
        'Objective4_AbsS11', scalar_row.AbsS11_f0_Linear, ...
        'Gmain_Phi0_dBi', phi0_summary.Gmain_dBi, ...
        'SLL_Phi0_dB', phi0_summary.SLL_dB, ...
        'HPBW_Phi0_deg', phi0_summary.HPBW_deg, ...
        'Gmain_Phi90_dBi', phi90_summary.Gmain_dBi, ...
        'SLL_Phi90_dB', phi90_summary.SLL_dB, ...
        'HPBW_Phi90_deg', phi90_summary.HPBW_deg);

    objective_table = struct2table(objective_struct);
    objective_table = add_metadata_columns(objective_table, params, sim_idx, simulation_id);
end

function summary = evaluate_pattern_cut(cut_name, theta_deg, gain_dbi)
    summary = empty_pattern_summary(cut_name);

    if isempty(theta_deg) || isempty(gain_dbi)
        return;
    end

    [theta_deg, sort_idx] = sort(theta_deg(:));
    gain_dbi = gain_dbi(sort_idx);

    [peak_gain, peak_idx] = max(gain_dbi);
    summary.CutName = string(cut_name);
    summary.Gmain_dBi = peak_gain;
    summary.MainLobeTheta_deg = theta_deg(peak_idx);

    half_power_level = peak_gain - 3.0;
    left_theta = find_half_power_crossing(theta_deg, gain_dbi, peak_idx, -1, half_power_level);
    right_theta = find_half_power_crossing(theta_deg, gain_dbi, peak_idx, 1, half_power_level);
    if isfinite(left_theta) && isfinite(right_theta)
        summary.HPBW_deg = right_theta - left_theta;
        inside_main_lobe = theta_deg >= left_theta & theta_deg <= right_theta;
    else
        inside_main_lobe = false(size(theta_deg));
        inside_main_lobe(peak_idx) = true;
    end
    summary = fill_sidelobe_metrics(summary, theta_deg, gain_dbi, inside_main_lobe, peak_gain);
end

function summary = fill_sidelobe_metrics(summary, theta_deg, gain_dbi, inside_main_lobe, peak_gain)
    outside_idx = find(~inside_main_lobe);
    if isempty(outside_idx)
        return;
    end

    local_maxima = find_local_maxima(gain_dbi);
    local_maxima = local_maxima(~inside_main_lobe(local_maxima));
    if isempty(local_maxima)
        candidate_idx = outside_idx;
    else
        candidate_idx = local_maxima;
    end

    [side_lobe_gain, best_idx] = max(gain_dbi(candidate_idx));
    side_lobe_idx = candidate_idx(best_idx);

    summary.SideLobeGain_dBi = side_lobe_gain;
    summary.SideLobeTheta_deg = theta_deg(side_lobe_idx);
    summary.SLL_dB = side_lobe_gain - peak_gain;
    summary.SideLobeSuppression_dB = peak_gain - side_lobe_gain;
end

function idx = find_local_maxima(values)
    idx = [];
    if isempty(values)
        return;
    end

    if isscalar(values)
        idx = 1;
        return;
    end

    is_local_maximum = false(size(values));

    if values(1) >= values(2)
        is_local_maximum(1) = true;
    end

    for pos = 2:(numel(values) - 1)
        if values(pos) >= values(pos - 1) && values(pos) >= values(pos + 1)
            is_local_maximum(pos) = true;
        end
    end

    if values(end) >= values(end - 1)
        is_local_maximum(end) = true;
    end

    idx = find(is_local_maximum);
end

function crossing_theta = find_half_power_crossing(theta_deg, gain_dbi, main_idx, direction, threshold)
    crossing_theta = NaN;

    if direction < 0
        search_idx = find(gain_dbi(1:main_idx) < threshold, 1, 'last');
        if isempty(search_idx)
            return;
        end
        upper_idx = search_idx + 1;
        if upper_idx > numel(theta_deg)
            return;
        end
        crossing_theta = interpolate_crossing( ...
            theta_deg(search_idx), gain_dbi(search_idx), theta_deg(upper_idx), gain_dbi(upper_idx), threshold);
    else
        relative_idx = find(gain_dbi(main_idx:end) < threshold, 1, 'first');
        if isempty(relative_idx)
            return;
        end
        lower_idx = main_idx + relative_idx - 2;
        upper_idx = main_idx + relative_idx - 1;
        if lower_idx < 1 || upper_idx > numel(theta_deg)
            return;
        end
        crossing_theta = interpolate_crossing( ...
            theta_deg(lower_idx), gain_dbi(lower_idx), theta_deg(upper_idx), gain_dbi(upper_idx), threshold);
    end
end

function crossing_theta = interpolate_crossing(theta_a, gain_a, theta_b, gain_b, threshold)
    if gain_a == gain_b
        crossing_theta = mean([theta_a, theta_b]);
        return;
    end

    fraction = (threshold - gain_a) / (gain_b - gain_a);
    crossing_theta = theta_a + fraction * (theta_b - theta_a);
end

function [s11_f0_dB, sampled_freq_ghz] = sample_s11_at_f0(s11_data, target_freq_ghz)
    [~, sample_idx] = min(abs(s11_data.Freq_GHz - target_freq_ghz));
    s11_f0_dB = s11_data.S11_dB(sample_idx);
    sampled_freq_ghz = s11_data.Freq_GHz(sample_idx);
end

function linear_value = db20_to_linear(db_value)
    linear_value = NaN;
    if ~isfinite(db_value)
        return;
    end

    linear_value = 10.^(db_value ./ 20.0);
end

function summary = pick_best_pattern_summary(summaries)
    if isempty(summaries)
        summary = empty_pattern_summary("");
        return;
    end

    [~, best_idx] = max([summaries.Gmain_dBi]);
    summary = summaries(best_idx);
end

function summary = find_pattern_summary(summaries, cut_name)
    summary = empty_pattern_summary(cut_name);
    if isempty(summaries)
        return;
    end

    matches = arrayfun(@(item) item.CutName == cut_name, summaries);
    if any(matches)
        summary = summaries(find(matches, 1, 'first'));
    end
end

function summary = empty_pattern_summary(cut_name)
    summary = struct( ...
        'CutName', string(cut_name), ...
        'Gmain_dBi', NaN, ...
        'SLL_dB', NaN, ...
        'HPBW_deg', NaN, ...
        'SideLobeSuppression_dB', NaN, ...
        'MainLobeTheta_deg', NaN, ...
        'SideLobeTheta_deg', NaN, ...
        'SideLobeGain_dBi', NaN);
end

function objective_values = empty_objective_values()
    objective_values = struct( ...
        'MainPlane', "", ...
        'Gmain_Source', "", ...
        'S11_Source', "", ...
        'Gmain_dBi', NaN, ...
        'Gmain_Cut_dBi', NaN, ...
        'PeakRealizedGain_dBi', NaN, ...
        'FrontToBackRatio_dB', NaN, ...
        'SLL_dB', NaN, ...
        'HPBW_deg', NaN, ...
        'S11_f0_dB', NaN, ...
        'AbsS11_f0_dB', NaN, ...
        'AbsS11_f0_Linear', NaN, ...
        'Objective1_Neg_Gmain', NaN, ...
        'Objective2_SLL', NaN, ...
        'Objective3_HPBW', NaN, ...
        'Objective4_AbsS11', NaN);
end

function objective_values = table_to_objective_values(objective_table)
    objective_values = empty_objective_values();
    if isempty(objective_table)
        return;
    end

    row = table2struct(objective_table(1, :));
    objective_values.MainPlane = string(row.MainPlane);
    objective_values.Gmain_Source = string(row.Gmain_Source);
    objective_values.S11_Source = string(row.S11_Source);
    objective_values.Gmain_dBi = row.Gmain_dBi;
    objective_values.Gmain_Cut_dBi = row.Gmain_Cut_dBi;
    objective_values.PeakRealizedGain_dBi = row.PeakRealizedGain_dBi;
    objective_values.FrontToBackRatio_dB = row.FrontToBackRatio_dB;
    objective_values.SLL_dB = row.SLL_dB;
    objective_values.HPBW_deg = row.HPBW_deg;
    objective_values.S11_f0_dB = row.S11_f0_dB;
    objective_values.AbsS11_f0_dB = row.AbsS11_f0_dB;
    objective_values.AbsS11_f0_Linear = row.AbsS11_f0_Linear;
    objective_values.Objective1_Neg_Gmain = row.Objective1_Neg_Gmain;
    objective_values.Objective2_SLL = row.Objective2_SLL;
    objective_values.Objective3_HPBW = row.Objective3_HPBW;
    objective_values.Objective4_AbsS11 = row.Objective4_AbsS11;
end

function processed_files = save_processed_bundle(bundle, simulation_id, results_dir)
    processed_files = struct('ProcessedS11', "", 'ScalarMetrics', "", 'Patterns', "", 'Objectives', "");

    processed_s11_file = fullfile(results_dir, [simulation_id, '_s11_processed.csv']);
    scalar_metrics_file = fullfile(results_dir, [simulation_id, '_scalar_metrics.csv']);
    patterns_file = fullfile(results_dir, [simulation_id, '_patterns.csv']);
    objectives_file = fullfile(results_dir, [simulation_id, '_four_objectives.csv']);

    writetable(bundle.s11, processed_s11_file);
    writetable(bundle.scalar_metrics, scalar_metrics_file);
    writetable(bundle.patterns, patterns_file);
    writetable(bundle.objectives, objectives_file);

    processed_files.ProcessedS11 = string(processed_s11_file);
    processed_files.ScalarMetrics = string(scalar_metrics_file);
    processed_files.Patterns = string(patterns_file);
    processed_files.Objectives = string(objectives_file);
end

function results_log = update_results_log( ...
        results_log, sim_idx, simulation_id, params, export_files, processed_files, objective_values, success)

    param_names = fieldnames(params);
    for idx = 1:numel(param_names)
        param_name = param_names{idx};
        results_log.(param_name)(sim_idx) = params.(param_name);
    end

    results_log.SimulationID(sim_idx) = string(simulation_id);
    results_log.S11_File(sim_idx) = string_or_empty(export_files, 'S11');
    results_log.S11F0_File(sim_idx) = string_or_empty(export_files, 'S11F0');
    results_log.PeakGain_File(sim_idx) = string_or_empty(export_files, 'PeakGain');
    results_log.GainPhi90_File(sim_idx) = string_or_empty(export_files, 'GainPhi90');
    results_log.GainPhi0_File(sim_idx) = string_or_empty(export_files, 'GainPhi0');
    results_log.ProcessedS11_File(sim_idx) = string_or_empty(processed_files, 'ProcessedS11');
    results_log.ScalarMetrics_File(sim_idx) = string_or_empty(processed_files, 'ScalarMetrics');
    results_log.Patterns_File(sim_idx) = string_or_empty(processed_files, 'Patterns');
    results_log.Objectives_File(sim_idx) = string_or_empty(processed_files, 'Objectives');
    results_log.MainPlane(sim_idx) = string(objective_values.MainPlane);
    results_log.Gmain_Source(sim_idx) = string(objective_values.Gmain_Source);
    results_log.S11_Source(sim_idx) = string(objective_values.S11_Source);
    results_log.Gmain_dBi(sim_idx) = objective_values.Gmain_dBi;
    results_log.Gmain_Cut_dBi(sim_idx) = objective_values.Gmain_Cut_dBi;
    results_log.PeakRealizedGain_dBi(sim_idx) = objective_values.PeakRealizedGain_dBi;
    results_log.FrontToBackRatio_dB(sim_idx) = objective_values.FrontToBackRatio_dB;
    results_log.SLL_dB(sim_idx) = objective_values.SLL_dB;
    results_log.HPBW_deg(sim_idx) = objective_values.HPBW_deg;
    results_log.S11_f0_dB(sim_idx) = objective_values.S11_f0_dB;
    results_log.AbsS11_f0_dB(sim_idx) = objective_values.AbsS11_f0_dB;
    results_log.AbsS11_f0_Linear(sim_idx) = objective_values.AbsS11_f0_Linear;
    results_log.Objective1_Neg_Gmain(sim_idx) = objective_values.Objective1_Neg_Gmain;
    results_log.Objective2_SLL(sim_idx) = objective_values.Objective2_SLL;
    results_log.Objective3_HPBW(sim_idx) = objective_values.Objective3_HPBW;
    results_log.Objective4_AbsS11(sim_idx) = objective_values.Objective4_AbsS11;
    results_log.Success(sim_idx) = logical(success);
end

function value = string_or_empty(data_struct, field_name)
    value = "";
    if isfield(data_struct, field_name)
        current_value = data_struct.(field_name);
        if strlength(string(current_value)) > 0
            value = string(current_value);
        end
    end
end

function save_progress(results_log, results_dir)
    save(fullfile(results_dir, 'progress.mat'), 'results_log');
    writetable(results_log, fullfile(results_dir, 'simulation_progress.csv'));
end

function combine_processed_results(results_log, results_dir)
    combine_csv_files(results_log.Objectives_File, fullfile(results_dir, 'all_simulations_four_objectives.csv'));
    combine_csv_files(results_log.Objectives_File, fullfile(results_dir, 'all_simulations_combined.csv'));
    combine_csv_files(results_log.ScalarMetrics_File, fullfile(results_dir, 'all_simulations_scalar_metrics.csv'));
    combine_csv_files(results_log.ProcessedS11_File, fullfile(results_dir, 'all_simulations_s11.csv'));
    combine_csv_files(results_log.Patterns_File, fullfile(results_dir, 'all_simulations_patterns.csv'));
end

function combine_csv_files(file_column, output_file)
    valid_files = string(file_column);
    valid_files = valid_files(strlength(valid_files) > 0);

    if isempty(valid_files)
        fprintf('No files were available to combine for %s\n', output_file);
        return;
    end

    combined_data = table();
    for idx = 1:numel(valid_files)
        file_path = char(valid_files(idx));
        if ~exist(file_path, 'file')
            continue;
        end

        current_table = readtable(file_path);
        combined_data = [combined_data; current_table]; %#ok<AGROW>
    end

    if isempty(combined_data)
        fprintf('No combined data was written for %s\n', output_file);
        return;
    end

    writetable(combined_data, output_file);
    fprintf('Merged %d rows into %s\n', height(combined_data), output_file);
end

function save_final_results(results_log, results_dir)
    writetable(results_log, fullfile(results_dir, 'final_simulation_log.csv'));
    save(fullfile(results_dir, 'final_results.mat'), 'results_log');

    try
        writetable(results_log, fullfile(results_dir, 'final_simulation_log.xlsx'));
    catch ME
        fprintf('Excel export skipped: %s\n', ME.message);
    end

    success_rows = results_log.Success;
    if any(success_rows)
        writetable(results_log(success_rows, :), fullfile(results_dir, 'successful_simulations.csv'));
    end
end

function run_hfss_com(params, export_types, sim_id, config)
    max_retries = 2;
    retry_count = 0;
    temp_project_path = '';

    while retry_count < max_retries
        try
            fprintf('Connecting to HFSS via COM (%d/%d)...\n', retry_count + 1, max_retries);

            hfss = actxserver('AnsoftHfss.HfssScriptInterface');
            desktop = hfss.GetAppDesktop();
            desktop.RestoreWindow();

            temp_project_path = create_temp_project_copy(config, sim_id);
            project = desktop.OpenProject(temp_project_path);

            try
                design = project.SetActiveDesign(config.design_name);
            catch
                design = project.GetActiveDesign();
            end

            fprintf('Applying parameter values...\n');
            apply_parameter_values(design, params, config.parameter_unit);

            project.Save();
            design.AnalyzeAll();
            pause(5);

            report_module = design.GetModule('ReportSetup');
            for idx = 1:size(export_types, 1)
                export_name = export_types{idx, 1};
                report_name = export_types{idx, 2};
                output_file = fullfile(config.results_dir, [sim_id, '_', export_name, '.csv']);

                fprintf('Exporting %-10s from report "%s"...\n', export_name, report_name);
                report_module.ExportToFile(report_name, output_file);
                wait_for_output_file(output_file, config.max_export_wait_seconds);
            end

            try
                project.Close();
            catch
            end
            try
                hfss.delete();
            catch
            end

            cleanup_temp_project_copy(temp_project_path, config);
            fprintf('HFSS run complete.\n');
            return;
        catch ME
            retry_count = retry_count + 1;

            try
                hfss.delete();
            catch
            end
            cleanup_temp_project_copy(temp_project_path, config);
            temp_project_path = '';

            if retry_count >= max_retries
                rethrow(ME);
            end

            fprintf('HFSS retry requested after failure: %s\n', ME.message);
            pause(10);
        end
    end
end

function apply_parameter_values(design, parameter_values, unit_suffix)
    param_names = fieldnames(parameter_values);
    for idx = 1:numel(param_names)
        param_name = param_names{idx};
        param_value = parameter_values.(param_name);
        formatted_value = sprintf('%.4f%s', param_value, unit_suffix);
        design.SetVariableValue(param_name, formatted_value);
        fprintf('  %s = %s\n', param_name, formatted_value);
    end
end

function wait_for_output_file(output_file, timeout_seconds)
    start_time = tic;
    while toc(start_time) < timeout_seconds
        if exist(output_file, 'file')
            file_info = dir(output_file);
            if file_info.bytes > 0
                return;
            end
        end
        pause(1);
    end

    error('Timed out while waiting for exported file: %s', output_file);
end

function temp_project_path = create_temp_project_copy(config, sim_id)
    source_project = config.hfss_project;
    if ~exist(source_project, 'file')
        error('Source HFSS project does not exist: %s', source_project);
    end

    ensure_directory(config.temp_project_dir);

    [~, base_name, ext] = fileparts(source_project);
    temp_project_path = fullfile(config.temp_project_dir, sprintf('%s_%s%s', base_name, sim_id, ext));
    copyfile(source_project, temp_project_path, 'f');
    try_delete_file([temp_project_path, '.lock']);
end

function cleanup_temp_project_copy(temp_project_path, config)
    if isempty(temp_project_path)
        return;
    end

    if isfield(config, 'keep_temp_projects') && config.keep_temp_projects
        return;
    end

    try_delete_file(temp_project_path);
    try_delete_file([temp_project_path, '.lock']);
    try_delete_dir([temp_project_path, 'results']);
end

function pid = read_lock_process_id(lock_path)
    pid = [];
    try
        lock_text = fileread(lock_path);
        token = regexp(lock_text, 'DesktopProcessID=(\d+)', 'tokens', 'once');
        if ~isempty(token)
            pid = str2double(token{1});
        end
    catch
        pid = [];
    end
end

function tf = is_process_running(pid)
    try
        [~, task_output] = system(sprintf('tasklist /FI "PID eq %d"', pid));
        tf = contains(task_output, sprintf('%d', pid));
    catch
        tf = false;
    end
end

function try_delete_file(file_path)
    if exist(file_path, 'file')
        try
            delete(file_path);
        catch
        end
    end
end

function try_delete_dir(dir_path)
    if exist(dir_path, 'dir')
        try
            rmdir(dir_path, 's');
        catch
        end
    end
end
