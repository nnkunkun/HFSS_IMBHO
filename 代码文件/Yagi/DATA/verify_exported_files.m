function result_files = verify_exported_files(export_types, sim_id, results_dir)
    result_files = struct();

    for idx = 1:size(export_types, 1)
        export_name = export_types{idx, 1};
        filename = fullfile(results_dir, [sim_id, '_', export_name, '.csv']);

        if ~exist(filename, 'file')
            fprintf('[missing] %s -> %s\n', export_name, filename);
            result_files.(export_name) = '';
            continue;
        end

        file_info = dir(filename);
        if isempty(file_info) || file_info.bytes <= 0
            fprintf('[empty]   %s -> %s\n', export_name, filename);
            result_files.(export_name) = '';
            continue;
        end

        fprintf('[ok]      %s -> %s\n', export_name, filename);
        result_files.(export_name) = filename;
    end
end
