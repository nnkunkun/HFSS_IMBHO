function add_gain_to_existing_results()
    % 配置结果目录
    results_dir = 'C:\project\11.2\re';
    
    % 读取现有的总合并文件
    all_data_file = fullfile(results_dir, 'all_simulations_combined.csv');
    if ~exist(all_data_file, 'file')
        error('总合并文件不存在: %s', all_data_file);
    end
    
    all_data = readtable(all_data_file);
    fprintf('读取总合并文件: %d 行数据\n', height(all_data));
    
    % 检查是否已有Gain列
    if ismember('Gain_dB', all_data.Properties.VariableNames)
        fprintf('检测到已有Gain_dB列，将重新生成\n');
        all_data.Gain_dB = [];
    end
    
    % 初始化Gain列为NaN
    all_data.Gain_dB = NaN(height(all_data), 1);
    
    % 获取所有唯一的仿真索引
    sim_indices = unique(all_data.SimulationIndex);
    fprintf('找到 %d 个唯一的仿真索引\n', length(sim_indices));
    
    % 为每个仿真添加Gain数据
    for i = 1:length(sim_indices)
        sim_idx = sim_indices(i);
        fprintf('处理仿真 %d/%d...\n', i, length(sim_indices));
        
        % 从当前数据中获取参数值（用于重构文件名）
        sim_rows = all_data.SimulationIndex == sim_idx;
        if ~any(sim_rows)
            continue;
        end
        
        % 获取第一行的参数值
        first_row = all_data(find(sim_rows, 1), :);
        
        % 重构仿真ID
        sim_id = reconstruct_sim_id(first_row);
        
        % 查找Gain文件
        gain_file = fullfile(results_dir, [sim_id, '_Gain.csv']);
        
        if exist(gain_file, 'file')
            fprintf('  找到Gain文件: %s\n', gain_file);
            
            % 读取Gain数据
            gain_data = read_hfss_csv(gain_file);
            
            if ~isempty(gain_data) && ismember('Gain_dB', gain_data.Properties.VariableNames)
                % 匹配频率并合并Gain数据
                all_data = merge_gain_data(all_data, sim_rows, gain_data);
                fprintf('  ✓ 成功添加Gain数据\n');
            else
                fprintf('  ✗ Gain文件格式不正确\n');
            end
        else
            fprintf('  ✗ Gain文件不存在: %s\n', gain_file);
        end
    end
    
    % 保存更新后的文件
    updated_file = fullfile(results_dir, 'all_simulations_combined_with_gain.csv');
    writetable(all_data, updated_file);
    fprintf('\n✓ 更新完成! 文件已保存: %s\n', updated_file);
    fprintf('  总数据量: %d 行\n', height(all_data));
    fprintf('  有效Gain数据: %d 行\n', sum(~isnan(all_data.Gain_dB)));
end

function sim_id = reconstruct_sim_id(row_data)
    % 从数据行重构仿真ID（与原始生成方式一致）
    param_names = {'ha', 'w1', 'w2', 'w3', 'W4', 'l1', 'w5', 'w6', 'w7', 'w8', 'ra', 'hsub'};
    
    id_parts = {};
    for i = 1:length(param_names)
        p_name = param_names{i};
        if ismember(p_name, row_data.Properties.VariableNames)
            p_value = row_data.(p_name);
            if iscell(p_value)
                p_value = p_value{1};
            end
            short_name = lower(regexprep(p_name, '[^a-zA-Z]', ''));
            if length(short_name) > 3
                short_name = short_name(1:3);
            end
            id_parts{end+1} = sprintf('%s%.1f', short_name, p_value);
        end
    end
    
    sim_id = strjoin(id_parts, '_');
end

function all_data = merge_gain_data(all_data, sim_rows, gain_data)
    % 合并Gain数据到总表中
    sim_freqs = all_data.Freq_GHz(sim_rows);
    
    for j = 1:length(sim_freqs)
        freq = sim_freqs(j);
        
        % 在Gain数据中查找相同频率的数据点
        freq_match = find(abs(gain_data.Freq_GHz - freq) < 1e-6, 1);
        
        if ~isempty(freq_match)
            % 找到对应的行索引
            sim_row_idx = find(sim_rows);
            actual_row_idx = sim_row_idx(j);
            
            % 赋值Gain数据
            all_data.Gain_dB(actual_row_idx) = gain_data.Gain_dB(freq_match);
        end
    end
end