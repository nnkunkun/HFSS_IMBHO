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
                % 尝试找到任何dB列
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
                % 尝试找到任何dB列
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
                % 尝试找到任何dB列
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