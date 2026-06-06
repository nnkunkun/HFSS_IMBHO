function mapped = map_to_real_samples(popDec, dataset)
% 中文说明：
% 将算法输出的连续设计映射到最近的真实 HFSS 样本点，
% 便于用真实仿真结果计算 HV/IGD、生成代表解表和画工程图。

if isempty(popDec)
    mapped = struct('indices', [], 'decs', zeros(0, dataset.dim), ...
        'objs', zeros(0, dataset.nObj), 'records', dataset.records([],:));
    return;
end

if isvector(popDec)
    popDec = reshape(popDec, 1, []);
end

span = max(dataset.ub - dataset.lb, eps);
query = (popDec - dataset.lb) ./ span;
samples = (dataset.X - dataset.lb) ./ span;

distance = pdist2(query, samples);
[~, idx] = min(distance, [], 2);
idx = unique(idx, 'stable');

mapped = struct();
mapped.indices = idx(:);
mapped.decs = dataset.X(idx, :);
mapped.objs = dataset.obj(idx, :);
mapped.records = dataset.records(idx, :);
end

