function dataset = load_hfss_antenna_dataset(problemId)
% 中文说明：
% 根据问题编号统一加载四个天线工程数据集。

switch upper(strtrim(problemId))
    case {'P1', 'DIPOLE'}
        dataset = load_dipole_dataset();
    case {'P2', 'PATCH'}
        dataset = load_patch_dataset();
    case {'P3', 'VIVALDI'}
        dataset = load_vivaldi_dataset();
    case {'P4', 'YAGI', 'YAGI-UDA', 'YAGIUDA'}
        dataset = load_yagi_dataset();
    otherwise
        error('Unsupported HFSS antenna problem id: %s', problemId);
end
end

