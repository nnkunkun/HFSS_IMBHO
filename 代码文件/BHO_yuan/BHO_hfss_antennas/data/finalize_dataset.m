function dataset = finalize_dataset(records, X, obj, varNames, objNames, problemId, antennaName, f0GHz, visualization)
% 中文说明：
% 为四类天线数据集统一补齐边界、参考 PF、代理模型和基础元数据。

% 只保留变量和目标都有效的样本，避免 NaN/Inf 影响代理模型和评价指标。
validMask = all(isfinite(X), 2) & all(isfinite(obj), 2);
records = records(validMask, :);
X = X(validMask, :);
obj = obj(validMask, :);
if isempty(X)
    error('No valid HFSS samples remain for problem %s after filtering invalid rows.', char(problemId));
end

dataset = struct();
dataset.problemId = char(problemId);
dataset.antennaName = char(antennaName);
dataset.records = records;
dataset.X = X;
dataset.obj = obj;
dataset.varNames = varNames;
dataset.objNames = objNames;
dataset.dim = size(X, 2);
dataset.nObj = size(obj, 2);
dataset.lb = min(X, [], 1);
dataset.ub = max(X, [], 1);
dataset.f0GHz = f0GHz;
dataset.visualization = visualization;
dataset.originalSampleCount = numel(validMask);
dataset.validSampleCount = size(X, 1);

if dataset.nObj > 1
    ndMask = non_dominated_mask(obj);
    dataset.refPF = unique(obj(ndMask, :), 'rows', 'stable');
    pfMin = min(dataset.refPF, [], 1);
    pfSpan = max(dataset.refPF, [], 1) - pfMin;
    dataset.refPoint = max(dataset.refPF, [], 1) + 0.10 * max(pfSpan, 1e-6);
else
    dataset.refPF = min(obj, [], 1);
    dataset.refPoint = [];
end

dataset.model = struct();
dataset.model.X = X;
dataset.model.Y = obj;
dataset.model.lb = dataset.lb;
dataset.model.ub = dataset.ub;
dataset.model.k = min(12, size(X, 1));
dataset.model.power = 2;
end
