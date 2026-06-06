function results_log = initialize_results_log(parameters_to_sweep, export_types, total_sims)
    % 初始化结果记录表格
    
    % 参数列
    param_names = parameters_to_sweep(:, 1)';
    param_columns = cell(1, length(param_names));
    for i = 1:length(param_names)
        param_columns{i} = NaN(total_sims, 1);
    end
    
    % 结果文件列
    export_names = export_types(:, 1)';
    export_columns = cell(1, length(export_names));
    for i = 1:length(export_names)
        export_columns{i} = cell(total_sims, 1);
    end
    
    % 状态列
    timestamp_column = NaT(total_sims, 1);
    success_column = false(total_sims, 1);
    
    % 合并所有列
    all_columns = [param_columns, export_columns, {timestamp_column}, {success_column}];
    
    % 创建列名
    all_names = [param_names, strcat(export_names, '_File'), {'Timestamp', 'Success'}];
    
    % 创建表格
    results_log = table(all_columns{:}, 'VariableNames', all_names);
    
    fprintf('初始化了 %d 行的结果表格\n', total_sims);
end