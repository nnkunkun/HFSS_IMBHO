function regenerate_combined_with_gain()
    results_dir = 'C:\project\r3';
    
    % 查找所有仿真的合并文件
    file_pattern = fullfile(results_dir, '*_combined_results.csv');
    combined_files = dir(file_pattern);
    
    fprintf('找到 %d 个合并文件\n', length(combined_files));
    
    all_data = table();
    
    for i = 1:length(combined_files)
        fprintf('处理文件 %d/%d: %s\n', i, length(combined_files), combined_files(i).name);
        
        % 读取合并文件
        file_path = fullfile(results_dir, combined_files(i).name);
        sim_data = readtable(file_path);
        
        % 查找对应的Gain文件
        base_name = strrep(combined_files(i).name, '_combined_results.csv', '');
        gain_file = fullfile(results_dir, [base_name, '_Gain.csv']);
        
        if exist(gain_file, 'file')
            fprintf('  找到Gain文件，正在合并...\n');
            
            % 读取Gain数据
            gain_data = read_hfss_csv(gain_file);
            
            if ~isempty(gain_data) && ismember('Gain_dB', gain_data.Properties.VariableNames)
                % 合并Gain数据
                sim_data = merge_gain_to_sim_data(sim_data, gain_data);
                fprintf('  ✓ Gain数据合并成功\n');
            else
                fprintf('  ✗ Gain数据格式不正确\n');
                % 添加空的Gain列
                if ~ismember('Gain_dB', sim_data.Properties.VariableNames)
                    sim_data.Gain_dB = NaN(height(sim_data), 1);
                end
            end
        else
            fprintf('  ✗ Gain文件不存在\n');
            % 添加空的Gain列
            if ~ismember('Gain_dB', sim_data.Properties.VariableNames)
                sim_data.Gain_dB = NaN(height(sim_data), 1);
            end
        end
        
        % 添加到总表
        all_data = [all_data; sim_data];
    end
    
    % 保存新的总合并文件
    output_file = fullfile(results_dir, 'all_simulations_combined_with_gain.csv');
    writetable(all_data, output_file);
    
    fprintf('\n✓ 重新生成完成!\n');
    fprintf('  总数据量: %d 行\n', height(all_data));
    fprintf('  文件保存至: %s\n', output_file);
end

function sim_data = merge_gain_to_sim_data(sim_data, gain_data)
    % 确保有Gain列
    if ~ismember('Gain_dB', sim_data.Properties.VariableNames)
        sim_data.Gain_dB = NaN(height(sim_data), 1);
    end
    
    % 按频率匹配合并Gain数据
    for i = 1:height(sim_data)
        freq = sim_data.Freq_GHz(i);
        
        % 查找匹配的频率点
        freq_idx = find(abs(gain_data.Freq_GHz - freq) < 1e-6, 1);
        
        if ~isempty(freq_idx)
            sim_data.Gain_dB(i) = gain_data.Gain_dB(freq_idx);
        end
    end
end