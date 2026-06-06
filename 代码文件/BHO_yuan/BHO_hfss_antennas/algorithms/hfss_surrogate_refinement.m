function refinedDecs = hfss_surrogate_refinement(seedDecs, problem, config)
% 中文说明：
% 这是 HFSS-BHO 的工程数据强化后处理。
% 它先基于 IDW 代理做一轮额外候选筛选，再把候选映射回真实 HFSS 样本，
% 最后通过局部邻域补全增强帕累托解集的覆盖范围与均匀性。

if isempty(seedDecs)
    refinedDecs = zeros(0, problem.dim);
    return;
end

lb = problem.lb;
ub = problem.ub;
dim = problem.dim;
nObj = problem.nObj;
model = problem.dataset.model;

screenCount = max(400, 40 * config.popSize);
localSigma = 0.08 * (ub - lb);

randomDecs = lb + rand(screenCount, dim) .* (ub - lb);
localDecs = seedDecs + randn(size(seedDecs)) .* repmat(localSigma, size(seedDecs, 1), 1);
localDecs = min(max(localDecs, lb), ub);
candidateDecs = unique([seedDecs; randomDecs; localDecs], 'rows', 'stable');
candidateObjs = idw_predict(candidateDecs, model);

validMask = all(isfinite(candidateObjs), 2);
candidateDecs = candidateDecs(validMask, :);
candidateObjs = candidateObjs(validMask, :);
if isempty(candidateDecs)
    refinedDecs = seedDecs;
    return;
end

selectedIdx = local_select_promising_candidates(candidateObjs, max(6 * config.popSize, 60));
selectedDecs = candidateDecs(selectedIdx, :);
mapped = map_to_real_samples(selectedDecs, problem.dataset);
expandedIdx = local_expand_neighbors(mapped.indices, problem.dataset, 3);
if isempty(expandedIdx)
    refinedDecs = mapped.decs;
    return;
end

expandedObj = problem.dataset.obj(expandedIdx, :);
if nObj > 1
    ndMask = non_dominated_mask(expandedObj);
    expandedIdx = expandedIdx(ndMask);
end

refinedDecs = problem.dataset.X(expandedIdx, :);
end

function selectedIdx = local_select_promising_candidates(obj, targetCount)
objMin = min(obj, [], 1);
objSpan = max(obj, [], 1) - objMin;
objSpan(objSpan <= 1e-12) = 1;
objNorm = (obj - objMin) ./ objSpan;

selectedIdx = [];
for m = 1:size(objNorm, 2)
    [~, idx] = min(objNorm(:, m));
    selectedIdx = local_append_index(selectedIdx, idx);
end

[~, compromiseIdx] = min(max(objNorm, [], 2));
selectedIdx = local_append_index(selectedIdx, compromiseIdx);

weights = local_build_weight_vectors(size(objNorm, 2), targetCount);
for i = 1:size(weights, 1)
    w = max(weights(i, :), 1e-6);
    score = max(objNorm .* repmat(w, size(objNorm, 1), 1), [], 2);
    [~, idx] = min(score);
    selectedIdx = local_append_index(selectedIdx, idx);
end
end

function idxList = local_expand_neighbors(seedIdx, dataset, neighborCount)
if isempty(seedIdx)
    idxList = [];
    return;
end

span = max(dataset.ub - dataset.lb, eps);
Xnorm = (dataset.X - dataset.lb) ./ span;
seedNorm = Xnorm(seedIdx, :);
distance = pdist2(seedNorm, Xnorm);
[~, order] = sort(distance, 2, 'ascend');
neighborCount = min(size(order, 2), neighborCount + 1);
idxList = unique(order(:, 1:neighborCount), 'stable');
idxList = idxList(:);
end

function weights = local_build_weight_vectors(nObj, targetCount)
if nObj == 2
    alpha = linspace(0.02, 0.98, targetCount).';
    weights = [alpha, 1 - alpha];
else
    weights = rand(targetCount, nObj);
    weights = weights ./ sum(weights, 2);
end
end

function selectedIdx = local_append_index(selectedIdx, idx)
if ~ismember(idx, selectedIdx)
    selectedIdx(end + 1, 1) = idx; %#ok<AGROW>
end
end
