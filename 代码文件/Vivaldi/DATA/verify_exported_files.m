function result_files = verify_exported_files(export_types, sim_id, results_dir)
    % 验证导出的文件是否存在
    
    result_files = struct();
    
    for i = 1:size(export_types, 1)
        export_name = export_types{i, 1};
        filename = fullfile(results_dir, [sim_id, '_', export_name, '.csv']);
        
        % 检查文件是否存在且不为空
        if exist(filename, 'file')
            file_info = dir(filename);
            if file_info.bytes > 100  % 文件大小至少100字节
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