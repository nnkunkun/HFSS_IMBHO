function results_log = record_simulation_results(results_log, idx, params, result_files, results_dir)
    % 记录仿真结果到表格
    
    % 记录参数值
    param_names = fieldnames(params);
    for i = 1:length(param_names)
        p_name = param_names{i};
        results_log.(p_name)(idx) = params.(p_name);
    end
    
    % 记录结果文件路径（只保存文件名，不保存完整路径）
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