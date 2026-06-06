function main_parameter_sweep()
    % 清除工作区
    clear; clc;
    close all;

    % ========== 用户配置区域 ==========
    % 1. 定义要扫描的参数及范围 [参数名 起始值 结束值 步长]
    parameters_to_sweep = {
        'dipole_length', 13.5, 16.5;
        'wire_rad', 0.15, 0.35;
        'port_gap', 0.15, 0.35;

    };

% 2. 采样数量配置
    n_lhs_samples = 200;  % 拉丁超立方采样数量
    
    % 3. 定义要导出的结果类型 [显示名 HFSS报告名]
    export_types = {
        'S11',    'S11';      % S参数
        'AR',     'AR';       % 轴比
        'Gain',     'Gain';  %增益
    };

    % 4. 文件路径配置
     % 4. 文件路径配置
    config.hfss_exe_path = 'P:\HFSS\v242\Win64\reg_ansysedt.exe';
    config.hfss_project = 'W:\Formal\Dipole\WireDipole_ATK.aedt';
    config.results_dir = 'W:\Formal\Dipole\DATA\results';

    parameters_to_sweep = {
        'dipole_length', 13.5, 16.5;
        'wire_rad', 0.15, 0.35;
        'port_gap', 0.15, 0.35;
    };
    n_lhs_samples = 200;
    export_types = {
        'S11', 'S11';
    };
    
    % 创建结果目录
    if ~exist(config.results_dir, 'dir')
        mkdir(config.results_dir);
        fprintf('创建结果目录: %s\n', config.results_dir);
    end

    % ========== 生成参数组合 ==========
    fprintf('使用拉丁超立方采样生成参数组合...\n');
    param_combinations = generate_param_combinations(parameters_to_sweep, n_lhs_samples);
    total_simulations = size(param_combinations, 1);
    fprintf('总共需要运行 %d 次仿真\n', total_simulations);

    % 显示参数组合统计信息
    disp('参数组合统计信息:');
    for i = 1:size(parameters_to_sweep, 1)
        param_name = parameters_to_sweep{i,1};
        min_val = min(param_combinations(:, i));
        max_val = max(param_combinations(:, i));
        mean_val = mean(param_combinations(:, i));
        fprintf('%s: min=%.4f cm, max=%.4f cm, mean=%.4f cm\n', ...
                param_name, min_val, max_val, mean_val);
    end

    % 显示参数组合预览
    disp('前几个参数组合:');
    for i = 1:min(5, total_simulations)
        fprintf('组合 %d: ', i);
        for j = 1:size(parameters_to_sweep, 1)
            fprintf('%s=%.4fcm ', parameters_to_sweep{j,1}, param_combinations(i,j));
        end
        fprintf('\n');
    end

    % 在main函数中调用可视化（可选）
    visualize_lhs_sampling(param_combinations, parameters_to_sweep);
    
    % ========== 初始化结果记录==========
    fprintf('初始化结果记录表...\n');
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

    % ========== 开始参数扫描==========
    fprintf('\n开始参数扫描..\n');
    start_time = datetime('now');

    for sim_idx = 1:total_simulations
        fprintf('\n=== 运行第 %d/%d 次仿真 ===\n', sim_idx, total_simulations);

        % 获取当前参数
        current_params = struct();
        for j = 1:size(parameters_to_sweep, 1)
            param_name = parameters_to_sweep{j,1};
            current_params.(param_name) = param_combinations(sim_idx, j);
        end

        % 显示当前参数
        fprintf('参数: ');
        param_names = fieldnames(current_params);
        for j = 1:length(param_names)
            fprintf('%s=%.4fcm ', param_names{j}, current_params.(param_names{j}));
        end
        fprintf('\n');

        % 确保之前的HFSS进程关闭
        kill_hfss_process();

        % 运行单次仿真并导出所有指定结果
        [success, result_files] = run_single_simulation(current_params, export_types, config);

        % 处理导出的数据文件（新增功能）
        if success
            % 读取并处理导出的CSV文件，添加参数信息
            combined_data = process_exported_data(result_files, current_params, sim_idx);
            
            % 保存处理后的数据
            if ~isempty(combined_data)
                sim_id = generate_simulation_id(current_params);
                combined_filename = fullfile(config.results_dir, [sim_id, '_combined_results.csv']);
                writetable(combined_data, combined_filename);
                fprintf('✓ 合并数据已保存: %s\n', combined_filename);
                
                % 更新结果文件路径
                result_files.combined = combined_filename;
            end
        end

        % 记录结果
        if success
            results_log = record_simulation_results(results_log, sim_idx, current_params, result_files, config.results_dir);
            fprintf('✓ 仿真成功完成\n');
        else
            fprintf('✗ 仿真失败\n');
            results_log.Success(sim_idx) = false;
        end

        % 记录时间戳
        results_log.Timestamp(sim_idx) = datetime('now');

        % 确保进程关闭
        kill_hfss_process();

        % 每次仿真后都保存进度（防止意外中断）
        save_progress(results_log, config.results_dir);
        elapsed_time = minutes(datetime('now') - start_time);
        fprintf('进度已保存已运行: %.1f 分钟\n', elapsed_time);
    end

    % ========== 合并扢有仿真的数据 ==========
    fprintf('\n合并所有仿真数据...\n');
    combine_all_results(results_log, config.results_dir);

    % ========== 保存最终结果...==========
    fprintf('\n保存最终结果.....\n');
    save_final_results(results_log, config.results_dir);
    
    % ========== 显示统计信息 ==========
    end_time = datetime('now');
    total_time = end_time - start_time;
    success_count = sum(results_log.Success);
    
    fprintf('\n=== 扫描完成! ===\n');
    fprintf('总仿真次数: %d\n', total_simulations);
    fprintf('成功次数: %d\n', success_count);
    fprintf('失败次数: %d\n', total_simulations - success_count);
    fprintf('总时: %s\n', char(total_time));
    fprintf('平均每次仿真: %.1f 分钟\n', minutes(total_time)/total_simulations);
    fprintf('结果保存到: %s\n', config.results_dir);
end

% 新增函数：处理导出的数据文件
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
        fprintf('  弢始处理导出的数据文件...\n');
        
        % 首先读取S11数据作为基础
        if isfield(result_files, 'S11') && exist(result_files.S11, 'file')
            fprintf('  读取S11文件: %s\n', result_files.S11);
            s11_data = read_hfss_csv(result_files.S11);
            if ~isempty(s11_data) && ismember('Freq_GHz', s11_data.Properties.VariableNames) && ...
               ismember('S11_dB', s11_data.Properties.VariableNames)
                combined_data = s11_data(:, {'Freq_GHz', 'S11_dB'});
                fprintf('  ✓ 以S11数据为基础\n');
            else
                fprintf('  ✗ S11数据格式不正确\n');
                return;
            end
        end
        
        if isempty(combined_data)
            fprintf('  ✗ 无法获取基础频率数据\n');
            return;
        end
        
        % 合并AR数据
        if isfield(result_files, 'AR') && exist(result_files.AR, 'file')
            fprintf('  读取AR文件: %s\n', result_files.AR);
            ar_data = read_hfss_csv(result_files.AR);
            if ~isempty(ar_data) && ismember('Freq_GHz', ar_data.Properties.VariableNames) && ...
               ismember('AR_dB', ar_data.Properties.VariableNames)
                
                % 确保AR数据有相同的频率点
                if isequal(combined_data.Freq_GHz, ar_data.Freq_GHz)
                    combined_data.AR_dB = ar_data.AR_dB;
                    fprintf('  ✓ AR数据合并成功\n');
                else
                    fprintf('  ⚠ AR数据频率点不同，尝试匹配\n');
                    % 使用最近邻插值
                    combined_data.AR_dB = interp1(ar_data.Freq_GHz, ar_data.AR_dB, combined_data.Freq_GHz, 'nearest', 'extrap');
                end
            else
                fprintf('  ⚠ AR数据格式不正确\n');
                % 添加空的AR列
                combined_data.AR_dB = NaN(height(combined_data), 1);
            end
        else
            % 添加空的AR列
            combined_data.AR_dB = NaN(height(combined_data), 1);
        end
        
        % 添加参数信息到每一行
        param_names = fieldnames(params);
        for i = 1:length(param_names)
            param_name = param_names{i};
            param_value = params.(param_name);
            combined_data.(param_name) = repmat(param_value, height(combined_data), 1);
        end
        
        % 添加仿真索引
        combined_data.SimulationIndex = repmat(sim_idx, height(combined_data), 1);
        
        % 重新排列列顺序：频率、性能指标、参数、索引
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
        
        % 添加参数列
        for i = 1:length(param_names)
            new_order{end+1} = param_names{i};
        end
        new_order{end+1} = 'SimulationIndex';
        
        % 重新排列列顺序
        combined_data = combined_data(:, new_order);
        
        fprintf('  ✓ 处理完成: %d 行数据\n', height(combined_data));
        
    catch ME
        fprintf('  数据处理错误: %s\n', ME.message);
        fprintf('  错误详情: %s\n', getReport(ME, 'extended'));
        combined_data = table();
    end
end

% 新增函数：读取HFSS CSV文件
function data = read_hfss_csv(filename)
    data = table();
    try
        % 使用preserve选项保持原始列名
        opts = detectImportOptions(filename);
        opts.VariableNamingRule = 'preserve'; % 保持原始列名
        
        % 读取CSV文件
        data = readtable(filename, opts);
        
        % 显示列名用于调试
        fprintf('    文件列名: %s\n', strjoin(data.Properties.VariableNames, ', '));
        
        % 重命名频率列
        freq_col = find(contains(data.Properties.VariableNames, 'Freq', 'IgnoreCase', true));
        if ~isempty(freq_col)
            data.Properties.VariableNames{freq_col(1)} = 'Freq_GHz';
        end
        
        % 根据文件名识别数据类型
        [~, filename_only, ~] = fileparts(filename);
        
        if contains(filename_only, 'S11', 'IgnoreCase', true)
            % S11文件 - 寻找S参数列
            s11_col = find(contains(data.Properties.VariableNames, 'S', 'IgnoreCase', true) & ...
                          (contains(data.Properties.VariableNames, '1,1', 'IgnoreCase', true) | ...
                           contains(data.Properties.VariableNames, 'St', 'IgnoreCase', true)));
            if ~isempty(s11_col)
                data.Properties.VariableNames{s11_col(1)} = 'S11_dB';
            else
                % 尝试找到任何 dB 列
                dB_col = find(contains(data.Properties.VariableNames, 'dB', 'IgnoreCase', true));
                if ~isempty(dB_col)
                    data.Properties.VariableNames{dB_col(1)} = 'S11_dB';
                end
            end
            
        elseif contains(filename_only, 'AR', 'IgnoreCase', true)
            % AR文件 - 寻找轴比列
            ar_col = find(contains(data.Properties.VariableNames, 'Axial', 'IgnoreCase', true) | ...
                         contains(data.Properties.VariableNames, 'AR', 'IgnoreCase', true));
            if ~isempty(ar_col)
                data.Properties.VariableNames{ar_col(1)} = 'AR_dB';
            else
                % 尝试找到任何 dB 列
                dB_col = find(contains(data.Properties.VariableNames, 'dB', 'IgnoreCase', true));
                if ~isempty(dB_col)
                    data.Properties.VariableNames{dB_col(1)} = 'AR_dB';
                end
            end
            
        elseif contains(filename_only, 'Gain', 'IgnoreCase', true)
            % Gain文件 - 寻找增益列
            gain_col = find(contains(data.Properties.VariableNames, 'Gain', 'IgnoreCase', true));
            if ~isempty(gain_col)
                data.Properties.VariableNames{gain_col(1)} = 'Gain_dB';
            else
                % 尝试找到任何 dB 列
                dB_col = find(contains(data.Properties.VariableNames, 'dB', 'IgnoreCase', true));
                if ~isempty(dB_col)
                    data.Properties.VariableNames{dB_col(1)} = 'Gain_dB';
                end
            end
        end
        
        fprintf('    处理后列名: %s\n', strjoin(data.Properties.VariableNames, ', '));
        fprintf('    读取成功: %d 行 x %d 列数据\n', height(data), width(data));
        
    catch ME
        fprintf('    读取文件失败: %s - %s\n', filename, ME.message);
        data = table();
    end
end


% 新增函数：合并所有仿真的数据
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
                    fprintf('  已添加仿真 %d 的数据\n', i);
                catch
                    fprintf('  无法读取文件: %s\n', combined_file);
                end
            end
        end
    end
    
    if ~isempty(all_data)
        % 保存扢有合并的数据
        final_file = fullfile(results_dir, 'all_simulations_combined.csv');
        writetable(all_data, final_file);
        fprintf('✓ 所有数据已合并保存: %s (%d 行数据)\n', final_file, height(all_data));
    else
        fprintf('✗ 没有找到可合并的数据\n');
    end
end

% 辅助函数：从日志生成仿真ID
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

% 修改记录函数以包含合并文件
function results_log = record_simulation_results(results_log, idx, params, result_files, results_dir)
    % 记录参数值
    param_names = fieldnames(params);
    for i = 1:length(param_names)
        p_name = param_names{i};
        results_log.(p_name)(idx) = params.(p_name);
    end
    
    % 记录结果文件路径
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
    
    % 标记成功
    results_log.Success(idx) = true;
    
    fprintf('结果已记录到表格第 %d 行\n', idx);
end


function [success, result_files] = run_single_simulation(params, export_types, config)
    success = false;
    result_files = struct();
    
    try
        % 生成唯一标识符（基于参数值）
        sim_id = generate_simulation_id(params);
        
        % 使用COM接口直接控制HFSS
        run_hfss_com(params, export_types, sim_id, config);
        
        % 检查结果文件是否生成
        result_files = verify_exported_files(export_types, sim_id, config.results_dir);
        
        success = true;
        
    catch ME
        fprintf('错误详情: %s\n', getReport(ME, 'extended'));
        result_files = struct();
    end
end

function sim_id = generate_simulation_id(params)
    param_names = fieldnames(params);
    id_parts = {};
    
    for i = 1:length(param_names)
        p_name = param_names{i};
        p_value = params.(p_name);
        % 使用参数首字母和值创建ID
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
        % 确保目录存在且有写入权限
        if ~exist(results_dir, 'dir')
            mkdir(results_dir);
        end
        
        % 检查写入权限
        test_file = fullfile(results_dir, 'test_write.tmp');
        fid = fopen(test_file, 'w');
        if fid == -1
            error('没有写入权限: %s', results_dir);
        end
        fclose(fid);
        delete(test_file);
        
        % 保存MAT文件
        save(fullfile(results_dir, 'progress.mat'), 'results_log');
        
        % 尝试保存CSV，如果失败只保存MAT文件
        try
            writetable(results_log, fullfile(results_dir, 'simulation_progress.csv'));
        catch
            fprintf('警告: 无法保存CSV文件，只保存MAT文件\n');
        end
        
    catch ME
        fprintf('保存进度失败: %s\n', ME.message);
        % 尝试保存到临时目录
        temp_dir = tempdir;
        save(fullfile(temp_dir, 'simulation_progress_backup.mat'), 'results_log');
        fprintf('进度已备份到临时目录: %s\n', temp_dir);
    end
end

function save_final_results(results_log, results_dir)
    % 保存详细日志
    writetable(results_log, fullfile(results_dir, 'final_simulation_log.csv'));
    
    % 尝试保存为Excel文件（需要 Excel 支持）
    try
        writetable(results_log, fullfile(results_dir, 'final_simulation_log.xlsx'));
    catch
        fprintf('警告: 无法保存Excel文件，可能缺少Excel支持\n');
    end
    
    save(fullfile(results_dir, 'final_results.mat'), 'results_log');
    
    % 创建成功仿真的子表格
    success_idx = results_log.Success;
    if any(success_idx)
        success_results = results_log(success_idx, :);
        writetable(success_results, fullfile(results_dir, 'successful_simulations.csv'));
    end
end

function run_hfss_com(params, export_types, sim_id, config)
    % 使用COM接口直接控制HFSS
    max_retries = 3;
    retry_count = 0;
    
    % 确保没有残留的HFSS进程
    kill_hfss_process();
    
    while retry_count < max_retries
        try
            fprintf('通过COM接口连接HFSS (尝试 %d/%d)...\n', retry_count + 1, max_retries);
            
            % 创建HFSS应用程序对象
            hfss = actxserver('AnsoftHfss.HfssScriptInterface');
            desktop = hfss.GetAppDesktop();
            desktop.RestoreWindow();
            fprintf('HFSS COM连接成功\n');
            
            % % 直接使用配置的项目路径
            % project_path = config.hfss_project;
            % fprintf('打开项目: %s\n', project_path);
            % 移除路径中的引号
            project_path = strrep(config.hfss_project, '"', '');
             % 棢查是否是绝对路径，如果不是则转换为绝对路径
            if ~contains(project_path, ':') && project_path(1) ~= '\'
                project_path = fullfile(pwd, project_path);
            end
            fprintf('打开项目: %s\n', project_path);

            % 棢查项目文件是否存在
            if ~exist(project_path, 'file')
                error('项目文件不存在: %s', project_path);
            end
            
            % 使用不同的方法打弢项目
            % try
                % 方法1: 直接打开
                project = desktop.OpenProject(project_path);
            % catch
            %     % 方法2: 使用ExecuteCommand
            %     desktop.ExecuteCommand(['OpenProject:="', project_path, '"']);
            %     pause(5); % 等待项目加载
            %     project = desktop.GetActiveProject();
            % end
            % 
            % fprintf('项目加载成功\n');
            
            % 获取设计
            try
                design = project.SetActiveDesign('WireDipole_ATK1');
            catch
                design = project.GetActiveDesign();
            end
            fprintf('设计获取成功: %s\n', design.GetName());
            
            % 设置参数
            fprintf('设置设计参数...\n');
            param_names = fieldnames(params);
            for i = 1:length(param_names)
                p_name = param_names{i};
                p_value = params.(p_name);
                
                try
                    design.SetVariableValue(p_name, sprintf('%.4fcm', p_value));
                    fprintf('  Parameter %s = %.4fcm\n', p_name, p_value);
                    fprintf('  设置 %s = %.4fcm\n', p_name, p_value);
                catch
                    fprintf('  警告: 无法设置参数 %s\n', p_name);
                end
            end
            
            % 保存项目
            project.Save();
            fprintf('项目已保存\n');
            
            % 运行仿真
            fprintf('开始仿真...\n');
            design.AnalyzeAll();
            
            % 等待仿真完成
            fprintf('等待仿真完成...\n');
            pause(30);
            fprintf('仿真完成\n');
            
            % 导出结果
            fprintf('导出结果文件...\n');
            report_module = design.GetModule('ReportSetup');
            
            % 先列出所有可用的报告
            try
                all_reports = report_module.GetAllReportNames();
                fprintf('可用的报告: %s\n', strjoin(all_reports, ', '));
                
                % 棢查我们需要的报告是否存在
                for i = 1:size(export_types, 1)
                    report_name = export_types{i, 2};
                    if any(strcmp(all_reports, report_name))
                        fprintf('  ✓ 报告存在: %s\n', report_name);
                    else
                        fprintf('  ✗ 报告不存在: %s\n', report_name);
                        % 建议可用的报告名
                        fprintf('    可用的类似报告: ');
                        similar_reports = all_reports(contains(all_reports, export_types{i, 1}));
                        if ~isempty(similar_reports)
                            fprintf('%s\n', strjoin(similar_reports, ', '));
                        else
                            fprintf('无\n');
                        end
                    end
                end
            catch
                fprintf('无法获取报告列表\n');
            end
            
            for i = 1:size(export_types, 1)
                export_name = export_types{i, 1};
                report_name = export_types{i, 2};
                output_file = fullfile(config.results_dir, [sim_id, '_', export_name, '.csv']);
                
                fprintf('  尝试导出: %s (报告: %s)\n', export_name, report_name);
                fprintf('    输出文件: %s\n', output_file);
                
                try
                    % 确保目录存在
                    if ~exist(config.results_dir, 'dir')
                        mkdir(config.results_dir);
                        fprintf('    创建结果目录\n');
                    end
                    
                    % 检查目录权限
                    [status, attr] = fileattrib(config.results_dir);
                    if status
                        fprintf('    目录权限: 可写=%d\n', attr.UserWrite);
                    end
                    
                    % 方法1: 直接导出
                    report_module.ExportToFile(report_name, output_file);
                    fprintf('    已发送导出命令\n');
                    
                    % 等待文件生成
                    max_wait = 30;
                    file_created = false;
                    for wait_time = 1:max_wait
                        if exist(output_file, 'file')
                            file_info = dir(output_file);
                            if file_info.bytes > 10
                                file_created = true;
                                fprintf('    ✓ 文件生成成功: %s (大小: %d bytes)\n', export_name, file_info.bytes);
                                break;
                            end
                        end
                        if mod(wait_time, 5) == 0
                            fprintf('    等待文件... (%d/%d 秒)\n', wait_time, max_wait);
                        end
                        pause(1);
                    end
                    
                    if ~file_created
                        fprintf('    ✗ 文件未生成\n');
                    end
                    
                catch ME
                    fprintf('    ✗ 导出失败: %s\n', ME.message);
                    
                    % 尝试使用不同的方法
                    try
                        fprintf('    尝试备用导出方法...\n');
                        report_module.ExportToFile(report_name, output_file, true);
                        fprintf('    备方法已执行\n');
                    catch ME2
                        fprintf('    备方法也失败: %s\n', ME2.message);
                    end
                end
            end
            
            % 关闭项目
            try
                project.Close();
            catch
            end
            
            % 清理COM对象
            try
                hfss.delete();
            catch
            end
            
            % 确保进程关闭
            kill_hfss_process();
            
            fprintf('仿真流程完成\n');
            return;
            
        catch ME
            retry_count = retry_count + 1;
            
            % 清理COM对象
            try
                hfss.delete();
            catch
            end
            
            % 确保进程关闭
            kill_hfss_process();
            
            if retry_count >= max_retries
                fprintf('所有重试尝试都失败: %s\n', ME.message);
                rethrow(ME);
            else
                fprintf('尝试失败，等待后重试...\n');
                pause(10);
            end
        end
    end
end

function kill_hfss_process()
    % 确保HFSS进程完全关闭
    try
        if ispc
            [~, ~] = system('taskkill /f /im ansysedt.exe /t >nul 2>&1');
            [~, ~] = system('taskkill /f /im hfss.exe /t >nul 2>&1');
            pause(1);
        end
    catch
        % 忽略错误
    end
end

function names = get_alternative_report_names(export_type)

    % 返回可能的备选报告名
    
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
    % 验证导出的文件是否存在
    
    result_files = struct();
    
    for i = 1:size(export_types, 1)
        export_name = export_types{i, 1};
        filename = fullfile(results_dir, [sim_id, '_', export_name, '.csv']);
        
        % 检查文件是否存在且不为空
        if exist(filename, 'file')
            file_info = dir(filename);
            if file_info.bytes > 50  % 降低文件大小要求
                result_files.(export_name) = filename;
                fprintf('✓ %s 文件验证成功: %s\n', export_name, filename);
            else
                fprintf('✗ %s 文件为空: %s\n', export_name, filename);
                result_files.(export_name) = '';
            end
        else
            fprintf('✗ %s 文件不存在: %s\n', export_name, filename);
            result_files.(export_name) = '';
        end
    end
end

