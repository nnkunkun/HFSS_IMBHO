function main_parameter_sweep()
    % 娓呴櫎宸ヤ綔鍖?
    clear; clc;
    close all;

    % ========== 鐢ㄦ埛閰嶇疆鍖哄煙 ==========
    % 1. 瀹氫箟瑕佹壂鎻忕殑鍙傛暟鍙婅寖鍥?[鍙傛暟鍚? 璧峰鍊? 缁撴潫鍊? 姝ラ暱]
    parameters_to_sweep = {
        'dipole_length', 13.5, 16.5;
        'wire_rad', 0.15, 0.35;
        'port_gap', 0.15, 0.35;

    };

% 2. 閲囨牱鏁伴噺閰嶇疆
    n_lhs_samples = 10;  % 鎷変竵瓒呯珛鏂归噰鏍锋暟閲?
    
    % 3. 瀹氫箟瑕佸鍑虹殑缁撴灉绫诲瀷 [鏄剧ず鍚? HFSS鎶ュ憡鍚峕
    export_types = {
        'S11',    'S11';      % S鍙傛暟
        'AR',     'AR';       % 杞存瘮
        'Gain',     'Gain';  %澧炵泭
    };

    % 4. 鏂囦欢璺緞閰嶇疆
     % 4. 鏂囦欢璺緞閰嶇疆
    config.hfss_exe_path = 'P:\HFSS\v242\Win64\reg_ansysedt.exe';
    config.hfss_project = 'W:\Formal\Dipole\WireDipole_ATK.aedt';
    config.results_dir = 'W:\Formal\Dipole\DATA\results';

    parameters_to_sweep = {
        'dipole_length', 13.5, 16.5;
        'wire_rad', 0.15, 0.35;
        'port_gap', 0.15, 0.35;
    };
    n_lhs_samples = 50;
    export_types = {
        'S11', 'S11';
    };
    
    % 鍒涘缓缁撴灉鐩綍
    if ~exist(config.results_dir, 'dir')
        mkdir(config.results_dir);
        fprintf('鍒涘缓缁撴灉鐩綍: %s\n', config.results_dir);
    end

    % ========== 鐢熸垚鍙傛暟缁勫悎 ==========
    fprintf('浣跨敤鎷変竵瓒呯珛鏂归噰鏍风敓鎴愬弬鏁扮粍鍚?..\n');
    param_combinations = generate_param_combinations(parameters_to_sweep, n_lhs_samples);
    total_simulations = size(param_combinations, 1);
    fprintf('鎬诲叡闇€瑕佽繍琛?%d 娆′豢鐪焅n', total_simulations);

    % 鏄剧ず鍙傛暟缁勫悎缁熻淇℃伅
    disp('鍙傛暟缁勫悎缁熻淇℃伅:');
    for i = 1:size(parameters_to_sweep, 1)
        param_name = parameters_to_sweep{i,1};
        min_val = min(param_combinations(:, i));
        max_val = max(param_combinations(:, i));
        mean_val = mean(param_combinations(:, i));
        fprintf('%s: min=%.4f cm, max=%.4f cm, mean=%.4f cm\n', ...
                param_name, min_val, max_val, mean_val);
    end

    % 鏄剧ず鍙傛暟缁勫悎棰勮
    disp('鍓?涓弬鏁扮粍鍚?');
    for i = 1:min(5, total_simulations)
        fprintf('缁勫悎 %d: ', i);
        for j = 1:size(parameters_to_sweep, 1)
            fprintf('%s=%.4fcm ', parameters_to_sweep{j,1}, param_combinations(i,j));
        end
        fprintf('\n');
    end

    % 鍦╩ain鍑芥暟涓皟鐢ㄥ彲瑙嗗寲锛堝彲閫夛級
    visualize_lhs_sampling(param_combinations, parameters_to_sweep);
    
    % ========== 鍒濆鍖栫粨鏋滆褰?==========
    fprintf('鍒濆鍖栫粨鏋滆褰曡〃鏍?..\n');
    results_log = initialize_results_log(parameters_to_sweep, export_types, total_simulations);
    results_log.SimulationID = strings(total_simulations, 1);
    results_log.Combined_File = strings(total_simulations, 1);

    fprintf('\nStarting dipole S11 sweep...\n');
    start_time = datetime('now');

    for sim_idx = 1:total_simulations
        simulation_id = create_simulation_id(sim_idx);
        fprintf('\n=== Running simulation %d/%d (%s) ===\n', ...
            sim_idx, total_simulations, simulation_id);

        current_params = struct();
        for j = 1:size(parameters_to_sweep, 1)
            param_name = parameters_to_sweep{j, 1};
            current_params.(param_name) = param_combinations(sim_idx, j);
        end

        fprintf('Parameters: ');
        param_names = fieldnames(current_params);
        for j = 1:numel(param_names)
            fprintf('%s=%.4fcm ', param_names{j}, current_params.(param_names{j}));
        end
        fprintf('\n');

        kill_hfss_process();
        [success, result_files] = run_single_s11_simulation(current_params, export_types, simulation_id, config);

        if success
            combined_data = process_s11_exported_data(result_files, current_params, sim_idx, simulation_id);
            if ~isempty(combined_data)
                combined_filename = fullfile(config.results_dir, [simulation_id, '_combined_results.csv']);
                writetable(combined_data, combined_filename);
                result_files.combined = combined_filename;
                fprintf('Combined data saved: %s\n', combined_filename);
            else
                success = false;
                result_files.combined = '';
                fprintf('Failed to create combined S11 data for %s\n', simulation_id);
            end
        else
            result_files.combined = '';
        end

        results_log = record_s11_simulation_results( ...
            results_log, sim_idx, simulation_id, current_params, result_files, success);
        results_log.Timestamp(sim_idx) = datetime('now');

        if success
            fprintf('Simulation completed successfully.\n');
        else
            fprintf('Simulation failed.\n');
        end

        kill_hfss_process();
        save_progress(results_log, config.results_dir);
        elapsed_time = minutes(datetime('now') - start_time);
        fprintf('Progress saved. Elapsed time: %.1f minutes\n', elapsed_time);
    end

    fprintf('\nCombining all simulation data...\n');
    combine_all_s11_results(results_log, config.results_dir);

    fprintf('\nSaving final results...\n');
    save_final_results(results_log, config.results_dir);

    end_time = datetime('now');
    total_time = end_time - start_time;
    success_count = sum(results_log.Success);

    fprintf('\n=== Sweep complete ===\n');
    fprintf('Total simulations: %d\n', total_simulations);
    fprintf('Successful runs: %d\n', success_count);
    fprintf('Failed runs: %d\n', total_simulations - success_count);
    fprintf('Total runtime: %s\n', char(total_time));
    fprintf('Average time per simulation: %.1f minutes\n', minutes(total_time) / total_simulations);
    fprintf('Results saved to: %s\n', config.results_dir);
    return;

    % ========== 寮€濮嬪弬鏁版壂鎻?==========
    fprintf('\n寮€濮嬪弬鏁版壂鎻?..\n');
    start_time = datetime('now');

    for sim_idx = 1:total_simulations
        fprintf('\n=== 杩愯绗?%d/%d 娆′豢鐪?===\n', sim_idx, total_simulations);

        % 鑾峰彇褰撳墠鍙傛暟
        current_params = struct();
        for j = 1:size(parameters_to_sweep, 1)
            param_name = parameters_to_sweep{j,1};
            current_params.(param_name) = param_combinations(sim_idx, j);
        end

        % 鏄剧ず褰撳墠鍙傛暟
        fprintf('鍙傛暟: ');
        param_names = fieldnames(current_params);
        for j = 1:length(param_names)
            fprintf('%s=%.4fcm ', param_names{j}, current_params.(param_names{j}));
        end
        fprintf('\n');

        % 纭繚涔嬪墠鐨凥FSS杩涚▼鍏抽棴
        kill_hfss_process();

        % 杩愯鍗曟浠跨湡骞跺鍑烘墍鏈夋寚瀹氱粨鏋?
        [success, result_files] = run_single_simulation(current_params, export_types, config);

        % 澶勭悊瀵煎嚭鐨勬暟鎹枃浠讹紙鏂板鍔熻兘锛?
        if success
            % 璇诲彇骞跺鐞嗗鍑虹殑CSV鏂囦欢锛屾坊鍔犲弬鏁颁俊鎭?
            combined_data = process_exported_data(result_files, current_params, sim_idx);
            
            % 淇濆瓨澶勭悊鍚庣殑鏁版嵁
            if ~isempty(combined_data)
                sim_id = generate_simulation_id(current_params);
                combined_filename = fullfile(config.results_dir, [sim_id, '_combined_results.csv']);
                writetable(combined_data, combined_filename);
                fprintf('鉁?鍚堝苟鏁版嵁宸蹭繚瀛? %s\n', combined_filename);
                
                % 鏇存柊缁撴灉鏂囦欢璺緞
                result_files.combined = combined_filename;
            end
        end

        % 璁板綍缁撴灉
        if success
            results_log = record_simulation_results(results_log, sim_idx, current_params, result_files, config.results_dir);
            fprintf('鉁?浠跨湡鎴愬姛瀹屾垚\n');
        else
            fprintf('鉁?浠跨湡澶辫触\n');
            results_log.Success(sim_idx) = false;
        end

        % 璁板綍鏃堕棿鎴?
        results_log.Timestamp(sim_idx) = datetime('now');

        % 纭繚杩涚▼鍏抽棴
        kill_hfss_process();

        % 姣忔浠跨湡鍚庨兘淇濆瓨杩涘害锛堥槻姝㈡剰澶栦腑鏂級
        save_progress(results_log, config.results_dir);
        elapsed_time = minutes(datetime('now') - start_time);
        fprintf('杩涘害宸蹭繚瀛樸€傚凡杩愯: %.1f 鍒嗛挓\n', elapsed_time);
    end

    % ========== 鍚堝苟鎵€鏈変豢鐪熺殑鏁版嵁 ==========
    fprintf('\n鍚堝苟鎵€鏈変豢鐪熸暟鎹?..\n');
    combine_all_results(results_log, config.results_dir);

    % ========== 淇濆瓨鏈€缁堢粨鏋?==========
    fprintf('\n淇濆瓨鏈€缁堢粨鏋?..\n');
    save_final_results(results_log, config.results_dir);
    
    % ========== 鏄剧ず缁熻淇℃伅 ==========
    end_time = datetime('now');
    total_time = end_time - start_time;
    success_count = sum(results_log.Success);
    
    fprintf('\n=== 鎵弿瀹屾垚! ===\n');
    fprintf('鎬讳豢鐪熸鏁? %d\n', total_simulations);
    fprintf('鎴愬姛娆℃暟: %d\n', success_count);
    fprintf('澶辫触娆℃暟: %d\n', total_simulations - success_count);
    fprintf('鎬昏€楁椂: %s\n', char(total_time));
    fprintf('骞冲潎姣忔浠跨湡: %.1f 鍒嗛挓\n', minutes(total_time)/total_simulations);
    fprintf('缁撴灉淇濆瓨鍦? %s\n', config.results_dir);
end

% 鏂板鍑芥暟锛氬鐞嗗鍑虹殑鏁版嵁鏂囦欢
function combined_data = process_s11_exported_data(result_files, params, sim_idx, simulation_id)
    combined_data = table();

    try
        if ~isfield(result_files, 'S11') || isempty(result_files.S11) || ~exist(result_files.S11, 'file')
            fprintf('  Missing S11 export file.\n');
            return;
        end

        fprintf('  Reading S11 file: %s\n', result_files.S11);
        s11_data = read_hfss_csv(result_files.S11);

        if isempty(s11_data) || ...
                ~ismember('Freq_GHz', s11_data.Properties.VariableNames) || ...
                ~ismember('S11_dB', s11_data.Properties.VariableNames)
            fprintf('  S11 CSV format is invalid.\n');
            return;
        end

        combined_data = s11_data(:, {'Freq_GHz', 'S11_dB'});

        param_names = fieldnames(params);
        for i = 1:numel(param_names)
            param_name = param_names{i};
            combined_data.(param_name) = repmat(params.(param_name), height(combined_data), 1);
        end

        combined_data.SimulationIndex = repmat(sim_idx, height(combined_data), 1);
        combined_data.SimulationID = repmat(string(simulation_id), height(combined_data), 1);
        combined_data = combined_data(:, { ...
            'Freq_GHz', ...
            'S11_dB', ...
            'dipole_length', ...
            'wire_rad', ...
            'port_gap', ...
            'SimulationIndex', ...
            'SimulationID'});

        fprintf('  Processed %d S11 rows.\n', height(combined_data));
    catch ME
        fprintf('  Data processing error: %s\n', ME.message);
        fprintf('  Details: %s\n', getReport(ME, 'extended'));
        combined_data = table();
    end
end

function combine_all_s11_results(results_log, results_dir)
    all_data = table();

    for i = 1:height(results_log)
        if ~results_log.Success(i)
            continue;
        end

        combined_file = char(results_log.Combined_File(i));
        if strlength(string(combined_file)) == 0
            fprintf('  Missing combined file path for row %d.\n', i);
            continue;
        end

        if exist(combined_file, 'file')
            try
                sim_data = readtable(combined_file);
                all_data = [all_data; sim_data]; %#ok<AGROW>
                fprintf('  Added data from %s\n', char(results_log.SimulationID(i)));
            catch ME
                fprintf('  Unable to read combined file %s: %s\n', combined_file, ME.message);
            end
        else
            fprintf('  Combined file not found: %s\n', combined_file);
        end
    end

    if isempty(all_data)
        fprintf('No combined simulation data was found.\n');
        return;
    end

    final_file = fullfile(results_dir, 'all_simulations_combined.csv');
    writetable(all_data, final_file);
    fprintf('All combined data saved to %s (%d rows).\n', final_file, height(all_data));
end

function results_log = record_s11_simulation_results(results_log, idx, simulation_id, params, result_files, success)
    param_names = fieldnames(params);
    for i = 1:numel(param_names)
        p_name = param_names{i};
        results_log.(p_name)(idx) = params.(p_name);
    end

    results_log.SimulationID(idx) = string(simulation_id);

    if ismember('S11_File', results_log.Properties.VariableNames)
        if isfield(result_files, 'S11') && ~isempty(result_files.S11) && exist(result_files.S11, 'file')
            [~, filename, ext] = fileparts(result_files.S11);
            results_log.S11_File{idx} = [filename, ext];
        else
            results_log.S11_File{idx} = 'FAILED';
        end
    end

    if isfield(result_files, 'combined') && ~isempty(result_files.combined) && exist(result_files.combined, 'file')
        results_log.Combined_File(idx) = string(result_files.combined);
    else
        results_log.Combined_File(idx) = "";
    end

    results_log.Success(idx) = success;
    fprintf('Logged results for table row %d.\n', idx);
end

function [success, result_files] = run_single_s11_simulation(params, export_types, simulation_id, config)
    success = false;
    result_files = struct();

    try
        run_hfss_com(params, export_types, simulation_id, config);
        result_files = verify_exported_files(export_types, simulation_id, config.results_dir);
        success = true;

        for i = 1:size(export_types, 1)
            export_name = export_types{i, 1};
            if ~isfield(result_files, export_name) || isempty(result_files.(export_name))
                fprintf('Missing exported file for %s.\n', export_name);
                success = false;
            end
        end
    catch ME
        fprintf('Simulation error details: %s\n', getReport(ME, 'extended'));
        result_files = struct();
    end
end

function simulation_id = create_simulation_id(sim_idx)
    simulation_id = sprintf('sim_%03d', sim_idx);
end

function combined_data = process_exported_data(result_files, params, sim_idx)
    combined_data = table();
    
    try
        fprintf('  寮€濮嬪鐞嗗鍑虹殑鏁版嵁鏂囦欢...\n');
        
        % 棣栧厛璇诲彇S11鏁版嵁浣滀负鍩虹
        if isfield(result_files, 'S11') && exist(result_files.S11, 'file')
            fprintf('  璇诲彇S11鏂囦欢: %s\n', result_files.S11);
            s11_data = read_hfss_csv(result_files.S11);
            if ~isempty(s11_data) && ismember('Freq_GHz', s11_data.Properties.VariableNames) && ...
               ismember('S11_dB', s11_data.Properties.VariableNames)
                combined_data = s11_data(:, {'Freq_GHz', 'S11_dB'});
                fprintf('  鉁?浠11鏁版嵁涓哄熀纭€\n');
            else
                fprintf('  鉁?S11鏁版嵁鏍煎紡涓嶆纭甛n');
                return;
            end
        end
        
        if isempty(combined_data)
            fprintf('  鉁?鏃犳硶鑾峰彇鍩虹棰戠巼鏁版嵁\n');
            return;
        end
        
        % 鍚堝苟AR鏁版嵁
        if isfield(result_files, 'AR') && exist(result_files.AR, 'file')
            fprintf('  璇诲彇AR鏂囦欢: %s\n', result_files.AR);
            ar_data = read_hfss_csv(result_files.AR);
            if ~isempty(ar_data) && ismember('Freq_GHz', ar_data.Properties.VariableNames) && ...
               ismember('AR_dB', ar_data.Properties.VariableNames)
                
                % 纭繚AR鏁版嵁鏈夌浉鍚岀殑棰戠巼鐐?
                if isequal(combined_data.Freq_GHz, ar_data.Freq_GHz)
                    combined_data.AR_dB = ar_data.AR_dB;
                    fprintf('  鉁?AR鏁版嵁鍚堝苟鎴愬姛\n');
                else
                    fprintf('  鈿?AR鏁版嵁棰戠巼鐐逛笉鍚岋紝灏濊瘯鍖归厤\n');
                    % 浣跨敤鏈€杩戦偦鎻掑€?
                    combined_data.AR_dB = interp1(ar_data.Freq_GHz, ar_data.AR_dB, combined_data.Freq_GHz, 'nearest', 'extrap');
                end
            else
                fprintf('  鈿?AR鏁版嵁鏍煎紡涓嶆纭甛n');
                % 娣诲姞绌虹殑AR鍒?
                combined_data.AR_dB = NaN(height(combined_data), 1);
            end
        else
            % 娣诲姞绌虹殑AR鍒?
            combined_data.AR_dB = NaN(height(combined_data), 1);
        end
        
        % 娣诲姞鍙傛暟淇℃伅鍒版瘡涓€琛?
        param_names = fieldnames(params);
        for i = 1:length(param_names)
            param_name = param_names{i};
            param_value = params.(param_name);
            combined_data.(param_name) = repmat(param_value, height(combined_data), 1);
        end
        
        % 娣诲姞浠跨湡绱㈠紩
        combined_data.SimulationIndex = repmat(sim_idx, height(combined_data), 1);
        
        % 閲嶆柊鎺掑垪鍒楅『搴忥細棰戠巼銆佹€ц兘鎸囨爣銆佸弬鏁般€佺储寮?
        new_order = {'Freq_GHz'};
        if ismember('S11_dB', combined_data.Properties.VariableNames)
            new_order{end+1} = 'S11_dB';
        end
        if ismember('AR_dB', combined_data.Properties.VariableNames)
            new_order{end+1} = 'AR_dB';
        end
        if ismember('Gain_dB', combined_data.Properties.VariableNames)
            new_order{end+1} = 'Gain_dB';
        end
        
        % 娣诲姞鍙傛暟鍒?
        for i = 1:length(param_names)
            new_order{end+1} = param_names{i};
        end
        new_order{end+1} = 'SimulationIndex';
        
        % 閲嶆柊鎺掑垪鍒楅『搴?
        combined_data = combined_data(:, new_order);
        
        fprintf('  鉁?澶勭悊瀹屾垚: %d 琛屾暟鎹甛n', height(combined_data));
        
    catch ME
        fprintf('  鏁版嵁澶勭悊閿欒: %s\n', ME.message);
        fprintf('  閿欒璇︽儏: %s\n', getReport(ME, 'extended'));
        combined_data = table();
    end
end

% 鏂板鍑芥暟锛氳鍙朒FSS CSV鏂囦欢
function data = read_hfss_csv(filename)
    data = table();
    try
        % 浣跨敤preserve閫夐」淇濇寔鍘熷鍒楀悕
        opts = detectImportOptions(filename);
        opts.VariableNamingRule = 'preserve'; % 淇濇寔鍘熷鍒楀悕
        
        % 璇诲彇CSV鏂囦欢
        data = readtable(filename, opts);
        
        % 鏄剧ず鍒楀悕鐢ㄤ簬璋冭瘯
        fprintf('    鏂囦欢鍒楀悕: %s\n', strjoin(data.Properties.VariableNames, ', '));
        
        % 閲嶅懡鍚嶉鐜囧垪
        freq_col = find(contains(data.Properties.VariableNames, 'Freq', 'IgnoreCase', true));
        if ~isempty(freq_col)
            data.Properties.VariableNames{freq_col(1)} = 'Freq_GHz';
        end
        
        % 鏍规嵁鏂囦欢鍚嶈瘑鍒暟鎹被鍨?
        [~, filename_only, ~] = fileparts(filename);
        
        if contains(filename_only, 'S11', 'IgnoreCase', true)
            % S11鏂囦欢 - 瀵绘壘S鍙傛暟鍒?
            s11_col = find(contains(data.Properties.VariableNames, 'S', 'IgnoreCase', true) & ...
                          (contains(data.Properties.VariableNames, '1,1', 'IgnoreCase', true) | ...
                           contains(data.Properties.VariableNames, 'St', 'IgnoreCase', true)));
            if ~isempty(s11_col)
                data.Properties.VariableNames{s11_col(1)} = 'S11_dB';
            else
                % 灏濊瘯鎵惧埌浠讳綍dB鍒?
                dB_col = find(contains(data.Properties.VariableNames, 'dB', 'IgnoreCase', true));
                if ~isempty(dB_col)
                    data.Properties.VariableNames{dB_col(1)} = 'S11_dB';
                end
            end
            
        elseif contains(filename_only, 'AR', 'IgnoreCase', true)
            % AR鏂囦欢 - 瀵绘壘杞存瘮鍒?
            ar_col = find(contains(data.Properties.VariableNames, 'Axial', 'IgnoreCase', true) | ...
                         contains(data.Properties.VariableNames, 'AR', 'IgnoreCase', true));
            if ~isempty(ar_col)
                data.Properties.VariableNames{ar_col(1)} = 'AR_dB';
            else
                % 灏濊瘯鎵惧埌浠讳綍dB鍒?
                dB_col = find(contains(data.Properties.VariableNames, 'dB', 'IgnoreCase', true));
                if ~isempty(dB_col)
                    data.Properties.VariableNames{dB_col(1)} = 'AR_dB';
                end
            end
            
        elseif contains(filename_only, 'Gain', 'IgnoreCase', true)
            % Gain鏂囦欢 - 瀵绘壘澧炵泭鍒?
            gain_col = find(contains(data.Properties.VariableNames, 'Gain', 'IgnoreCase', true));
            if ~isempty(gain_col)
                data.Properties.VariableNames{gain_col(1)} = 'Gain_dB';
            else
                % 灏濊瘯鎵惧埌浠讳綍dB鍒?
                dB_col = find(contains(data.Properties.VariableNames, 'dB', 'IgnoreCase', true));
                if ~isempty(dB_col)
                    data.Properties.VariableNames{dB_col(1)} = 'Gain_dB';
                end
            end
        end
        
        fprintf('    澶勭悊鍚庡垪鍚? %s\n', strjoin(data.Properties.VariableNames, ', '));
        fprintf('    璇诲彇鎴愬姛: %d 琛?x %d 鍒楁暟鎹甛n', height(data), width(data));
        
    catch ME
        fprintf('    璇诲彇鏂囦欢澶辫触: %s - %s\n', filename, ME.message);
        data = table();
    end
end


% 鏂板鍑芥暟锛氬悎骞舵墍鏈変豢鐪熺殑鏁版嵁
function combine_all_results(results_log, results_dir)
    all_data = table();
    
    for i = 1:height(results_log)
        if results_log.Success(i)
            sim_id = generate_simulation_id_from_log(results_log, i);
            combined_file = fullfile(results_dir, [sim_id, '_combined_results.csv']);
            
            if exist(combined_file, 'file')
                try
                    sim_data = readtable(combined_file);
                    all_data = [all_data; sim_data];
                    fprintf('  宸叉坊鍔犱豢鐪?%d 鐨勬暟鎹甛n', i);
                catch
                    fprintf('  鏃犳硶璇诲彇鏂囦欢: %s\n', combined_file);
                end
            end
        end
    end
    
    if ~isempty(all_data)
        % 淇濆瓨鎵€鏈夊悎骞剁殑鏁版嵁
        final_file = fullfile(results_dir, 'all_simulations_combined.csv');
        writetable(all_data, final_file);
        fprintf('鉁?鎵€鏈夋暟鎹凡鍚堝苟淇濆瓨: %s (%d 琛屾暟鎹?\n', final_file, height(all_data));
    else
        fprintf('鉁?娌℃湁鎵惧埌鍙悎骞剁殑鏁版嵁\n');
    end
end

% 杈呭姪鍑芥暟锛氫粠鏃ュ織鐢熸垚浠跨湡ID
function sim_id = generate_simulation_id_from_log(results_log, idx)
    param_names = results_log.Properties.VariableNames;
    param_names = param_names(~ismember(param_names, {'Timestamp', 'Success'}));
    param_names = param_names(~contains(param_names, '_File'));
    
    id_parts = {};
    for i = 1:length(param_names)
        p_name = param_names{i};
        p_value = results_log.(p_name)(idx);
        short_name = lower(regexprep(p_name, '[^a-zA-Z]', ''));
        if length(short_name) > 3
            short_name = short_name(1:3);
        end
        id_parts{end+1} = sprintf('%s%.1f', short_name, p_value);
    end
    
    sim_id = strjoin(id_parts, '_');
end

% 淇敼璁板綍鍑芥暟浠ュ寘鍚悎骞舵枃浠?
function results_log = record_simulation_results(results_log, idx, params, result_files, results_dir)
    % 璁板綍鍙傛暟鍊?
    param_names = fieldnames(params);
    for i = 1:length(param_names)
        p_name = param_names{i};
        results_log.(p_name)(idx) = params.(p_name);
    end
    
    % 璁板綍缁撴灉鏂囦欢璺緞
    result_fields = fieldnames(result_files);
    for i = 1:length(result_fields)
        field_name = result_fields{i};
        csv_file = result_files.(field_name);
        if ~isempty(csv_file) && exist(csv_file, 'file')
            [~, filename, ext] = fileparts(csv_file);
            results_log.([field_name, '_File']){idx} = [filename, ext];
        else
            results_log.([field_name, '_File']){idx} = 'FAILED';
        end
    end
    
    % 鏍囪鎴愬姛
    results_log.Success(idx) = true;
    
    fprintf('缁撴灉宸茶褰曞埌琛ㄦ牸绗?%d 琛孿n', idx);
end


function [success, result_files] = run_single_simulation(params, export_types, config)
    success = false;
    result_files = struct();
    
    try
        % 鐢熸垚鍞竴鏍囪瘑绗︼紙鍩轰簬鍙傛暟鍊硷級
        sim_id = generate_simulation_id(params);
        
        % 浣跨敤COM鎺ュ彛鐩存帴鎺у埗HFSS
        run_hfss_com(params, export_types, sim_id, config);
        
        % 妫€鏌ョ粨鏋滄枃浠舵槸鍚︾敓鎴?
        result_files = verify_exported_files(export_types, sim_id, config.results_dir);
        
        success = true;
        
    catch ME
        fprintf('閿欒璇︽儏: %s\n', getReport(ME, 'extended'));
        result_files = struct();
    end
end

function sim_id = generate_simulation_id(params)
    param_names = fieldnames(params);
    id_parts = {};
    
    for i = 1:length(param_names)
        p_name = param_names{i};
        p_value = params.(p_name);
        % 浣跨敤鍙傛暟棣栧瓧姣嶅拰鍊煎垱寤篒D
        short_name = lower(regexprep(p_name, '[^a-zA-Z]', ''));
        if length(short_name) > 3
            short_name = short_name(1:3);
        end
        id_parts{end+1} = sprintf('%s%.1f', short_name, p_value);
    end
    
    sim_id = strjoin(id_parts, '_');
end

% function save_progress(results_log, results_dir)
%     save(fullfile(results_dir, 'progress.mat'), 'results_log');
%     writetable(results_log, fullfile(results_dir, 'simulation_progress.csv'));
% end
function save_progress(results_log, results_dir)
    try
        % 纭繚鐩綍瀛樺湪涓旀湁鍐欏叆鏉冮檺
        if ~exist(results_dir, 'dir')
            mkdir(results_dir);
        end
        
        % 妫€鏌ュ啓鍏ユ潈闄?
        test_file = fullfile(results_dir, 'test_write.tmp');
        fid = fopen(test_file, 'w');
        if fid == -1
            error('娌℃湁鍐欏叆鏉冮檺: %s', results_dir);
        end
        fclose(fid);
        delete(test_file);
        
        % 淇濆瓨MAT鏂囦欢
        save(fullfile(results_dir, 'progress.mat'), 'results_log');
        
        % 灏濊瘯淇濆瓨CSV锛屽鏋滃け璐ュ彧淇濆瓨MAT鏂囦欢
        try
            writetable(results_log, fullfile(results_dir, 'simulation_progress.csv'));
        catch
            fprintf('璀﹀憡: 鏃犳硶淇濆瓨CSV鏂囦欢锛屽彧淇濆瓨MAT鏂囦欢\n');
        end
        
    catch ME
        fprintf('淇濆瓨杩涘害澶辫触: %s\n', ME.message);
        % 灏濊瘯淇濆瓨鍒颁复鏃剁洰褰?
        temp_dir = tempdir;
        save(fullfile(temp_dir, 'simulation_progress_backup.mat'), 'results_log');
        fprintf('杩涘害宸插浠藉埌涓存椂鐩綍: %s\n', temp_dir);
    end
end

function save_final_results(results_log, results_dir)
    % 淇濆瓨璇︾粏鏃ュ織
    writetable(results_log, fullfile(results_dir, 'final_simulation_log.csv'));
    
    % 灏濊瘯淇濆瓨涓篍xcel鏂囦欢锛堥渶瑕丒xcel鏀寔锛?
    try
        writetable(results_log, fullfile(results_dir, 'final_simulation_log.xlsx'));
    catch
        fprintf('璀﹀憡: 鏃犳硶淇濆瓨Excel鏂囦欢锛屽彲鑳界己灏慐xcel鏀寔\n');
    end
    
    save(fullfile(results_dir, 'final_results.mat'), 'results_log');
    
    % 鍒涘缓鎴愬姛浠跨湡鐨勫瓙琛ㄦ牸
    success_idx = results_log.Success;
    if any(success_idx)
        success_results = results_log(success_idx, :);
        writetable(success_results, fullfile(results_dir, 'successful_simulations.csv'));
    end
end

function run_hfss_com(params, export_types, sim_id, config)
    % 浣跨敤COM鎺ュ彛鐩存帴鎺у埗HFSS
    max_retries = 3;
    retry_count = 0;
    
    % 纭繚娌℃湁娈嬬暀鐨凥FSS杩涚▼
    kill_hfss_process();
    
    while retry_count < max_retries
        try
            fprintf('閫氳繃COM鎺ュ彛杩炴帴HFSS (灏濊瘯 %d/%d)...\n', retry_count + 1, max_retries);
            
            % 鍒涘缓HFSS搴旂敤绋嬪簭瀵硅薄
            hfss = actxserver('AnsoftHfss.HfssScriptInterface');
            desktop = hfss.GetAppDesktop();
            desktop.RestoreWindow();
            fprintf('HFSS COM杩炴帴鎴愬姛\n');
            
            % % 鐩存帴浣跨敤閰嶇疆鐨勯」鐩矾寰?
            % project_path = config.hfss_project;
            % fprintf('鎵撳紑椤圭洰: %s\n', project_path);
            % 绉婚櫎璺緞涓殑寮曞彿
            project_path = strrep(config.hfss_project, '"', '');
             % 妫€鏌ユ槸鍚︽槸缁濆璺緞锛屽鏋滀笉鏄垯杞崲涓虹粷瀵硅矾寰?
            if ~contains(project_path, ':') && project_path(1) ~= '\'
                project_path = fullfile(pwd, project_path);
            end
            fprintf('鎵撳紑椤圭洰: %s\n', project_path);

            % 妫€鏌ラ」鐩枃浠舵槸鍚﹀瓨鍦?
            if ~exist(project_path, 'file')
                error('椤圭洰鏂囦欢涓嶅瓨鍦? %s', project_path);
            end
            
            % 浣跨敤涓嶅悓鐨勬柟娉曟墦寮€椤圭洰
            % try
                % 鏂规硶1: 鐩存帴鎵撳紑
                project = desktop.OpenProject(project_path);
            % catch
            %     % 鏂规硶2: 浣跨敤ExecuteCommand
            %     desktop.ExecuteCommand(['OpenProject:="', project_path, '"']);
            %     pause(5); % 绛夊緟椤圭洰鍔犺浇
            %     project = desktop.GetActiveProject();
            % end
            % 
            % fprintf('椤圭洰鍔犺浇鎴愬姛\n');
            
            % 鑾峰彇璁捐
            try
                design = project.SetActiveDesign('WireDipole_ATK1');
            catch
                design = project.GetActiveDesign();
            end
            fprintf('璁捐鑾峰彇鎴愬姛: %s\n', design.GetName());
            
            % 璁剧疆鍙傛暟
            fprintf('璁剧疆璁捐鍙傛暟...\n');
            param_names = fieldnames(params);
            for i = 1:length(param_names)
                p_name = param_names{i};
                p_value = params.(p_name);
                
                try
                    design.SetVariableValue(p_name, sprintf('%.4fcm', p_value));
                    fprintf('  Parameter %s = %.4fcm\n', p_name, p_value);
                    fprintf('  璁剧疆 %s = %.4fcm\n', p_name, p_value);
                catch
                    fprintf('  璀﹀憡: 鏃犳硶璁剧疆鍙傛暟 %s\n', p_name);
                end
            end
            
            % 淇濆瓨椤圭洰
            project.Save();
            fprintf('椤圭洰宸蹭繚瀛榎n');
            
            % 杩愯浠跨湡
            fprintf('寮€濮嬩豢鐪?..\n');
            design.AnalyzeAll();
            
            % 绛夊緟浠跨湡瀹屾垚
            fprintf('绛夊緟浠跨湡瀹屾垚...\n');
            pause(30);
            fprintf('浠跨湡瀹屾垚\n');
            
            % 瀵煎嚭缁撴灉
            fprintf('瀵煎嚭缁撴灉鏂囦欢...\n');
            report_module = design.GetModule('ReportSetup');
            
            % 鍏堝垪鍑烘墍鏈夊彲鐢ㄧ殑鎶ュ憡
            try
                all_reports = report_module.GetAllReportNames();
                fprintf('鍙敤鐨勬姤鍛? %s\n', strjoin(all_reports, ', '));
                
                % 妫€鏌ユ垜浠渶瑕佺殑鎶ュ憡鏄惁瀛樺湪
                for i = 1:size(export_types, 1)
                    report_name = export_types{i, 2};
                    if any(strcmp(all_reports, report_name))
                        fprintf('  鉁?鎶ュ憡瀛樺湪: %s\n', report_name);
                    else
                        fprintf('  鉁?鎶ュ憡涓嶅瓨鍦? %s\n', report_name);
                        % 寤鸿鍙敤鐨勬姤鍛婂悕绉?
                        fprintf('    鍙敤鐨勭被浼兼姤鍛? ');
                        similar_reports = all_reports(contains(all_reports, export_types{i, 1}));
                        if ~isempty(similar_reports)
                            fprintf('%s\n', strjoin(similar_reports, ', '));
                        else
                            fprintf('鏃燶n');
                        end
                    end
                end
            catch
                fprintf('鏃犳硶鑾峰彇鎶ュ憡鍒楄〃\n');
            end
            
            for i = 1:size(export_types, 1)
                export_name = export_types{i, 1};
                report_name = export_types{i, 2};
                output_file = fullfile(config.results_dir, [sim_id, '_', export_name, '.csv']);
                
                fprintf('  灏濊瘯瀵煎嚭: %s (鎶ュ憡鍚? %s)\n', export_name, report_name);
                fprintf('    杈撳嚭鏂囦欢: %s\n', output_file);
                
                try
                    % 纭繚鐩綍瀛樺湪
                    if ~exist(config.results_dir, 'dir')
                        mkdir(config.results_dir);
                        fprintf('    鍒涘缓缁撴灉鐩綍\n');
                    end
                    
                    % 妫€鏌ョ洰褰曟潈闄?
                    [status, attr] = fileattrib(config.results_dir);
                    if status
                        fprintf('    鐩綍鏉冮檺: 鍙啓=%d\n', attr.UserWrite);
                    end
                    
                    % 鏂规硶1: 鐩存帴瀵煎嚭
                    report_module.ExportToFile(report_name, output_file);
                    fprintf('    宸插彂閫佸鍑哄懡浠n');
                    
                    % 绛夊緟鏂囦欢鐢熸垚
                    max_wait = 30;
                    file_created = false;
                    for wait_time = 1:max_wait
                        if exist(output_file, 'file')
                            file_info = dir(output_file);
                            if file_info.bytes > 10
                                file_created = true;
                                fprintf('    鉁?鏂囦欢鐢熸垚鎴愬姛: %s (澶у皬: %d bytes)\n', export_name, file_info.bytes);
                                break;
                            end
                        end
                        if mod(wait_time, 5) == 0
                            fprintf('    绛夊緟鏂囦欢涓?.. (%d/%d 绉?\n', wait_time, max_wait);
                        end
                        pause(1);
                    end
                    
                    if ~file_created
                        fprintf('    鉁?鏂囦欢鏈敓鎴怽n');
                    end
                    
                catch ME
                    fprintf('    鉁?瀵煎嚭澶辫触: %s\n', ME.message);
                    
                    % 灏濊瘯浣跨敤涓嶅悓鐨勬柟娉?
                    try
                        fprintf('    灏濊瘯澶囬€夊鍑烘柟娉?..\n');
                        report_module.ExportToFile(report_name, output_file, true);
                        fprintf('    澶囬€夋柟娉曞凡鎵ц\n');
                    catch ME2
                        fprintf('    澶囬€夋柟娉曚篃澶辫触: %s\n', ME2.message);
                    end
                end
            end
            
            % 鍏抽棴椤圭洰
            try
                project.Close();
            catch
            end
            
            % 娓呯悊COM瀵硅薄
            try
                hfss.delete();
            catch
            end
            
            % 纭繚杩涚▼鍏抽棴
            kill_hfss_process();
            
            fprintf('浠跨湡娴佺▼瀹屾垚\n');
            return;
            
        catch ME
            retry_count = retry_count + 1;
            
            % 娓呯悊COM瀵硅薄
            try
                hfss.delete();
            catch
            end
            
            % 纭繚杩涚▼鍏抽棴
            kill_hfss_process();
            
            if retry_count >= max_retries
                fprintf('鎵€鏈夐噸璇曞皾璇曢兘澶辫触浜? %s\n', ME.message);
                rethrow(ME);
            else
                fprintf('灏濊瘯澶辫触锛岀瓑寰呭悗閲嶈瘯...\n');
                pause(10);
            end
        end
    end
end

function kill_hfss_process()
    % 纭繚HFSS杩涚▼瀹屽叏鍏抽棴
    try
        if ispc
            [~, ~] = system('taskkill /f /im ansysedt.exe /t >nul 2>&1');
            [~, ~] = system('taskkill /f /im hfss.exe /t >nul 2>&1');
            pause(1);
        end
    catch
        % 蹇界暐閿欒
    end
end

function names = get_alternative_report_names(export_type)

    % 杩斿洖鍙兘鐨勫閫夋姤鍛婂悕绉?
    
    switch upper(export_type)
        case 'S11'
            names = {
                'S Parameter Plot 1';
                'S Parameter';
                'S11_Plot';
                'S11';
                'Plot1';
                'XY Plot 1'
            };
        case 'AR'
            names = {
                'Axial Ratio Plot 1';
                'Axial Ratio';
                'AR_Plot';
                'AR';
                'Far Field Plot';
                'Radiation Pattern'
            };
        case 'GAIN'
            names = {
                'Gain Plot 1';
                'Gain';
                'Gain_Plot';
                'Radiation Pattern';
                'Far Field'
            };
        otherwise
            names = {export_type};
    end
end

function result_files = verify_exported_files(export_types, sim_id, results_dir)
    % 楠岃瘉瀵煎嚭鐨勬枃浠舵槸鍚﹀瓨鍦?
    
    result_files = struct();
    
    for i = 1:size(export_types, 1)
        export_name = export_types{i, 1};
        filename = fullfile(results_dir, [sim_id, '_', export_name, '.csv']);
        
        % 妫€鏌ユ枃浠舵槸鍚﹀瓨鍦ㄤ笖涓嶄负绌?
        if exist(filename, 'file')
            file_info = dir(filename);
            if file_info.bytes > 50  % 闄嶄綆鏂囦欢澶у皬瑕佹眰
                result_files.(export_name) = filename;
                fprintf('鉁?%s 鏂囦欢楠岃瘉鎴愬姛: %s\n', export_name, filename);
            else
                fprintf('鉁?%s 鏂囦欢涓虹┖: %s\n', export_name, filename);
                result_files.(export_name) = '';
            end
        else
            fprintf('鉁?%s 鏂囦欢涓嶅瓨鍦? %s\n', export_name, filename);
            result_files.(export_name) = '';
        end
    end
end

