function [archive, hvCurve, result] = BHO_multiobjective_core(popSize, maxEval, lb, ub, dim, problem, options)
% 中文说明：
% 这是改进版多目标 BHO 的核心实现。
% 本轮继续强化了双目标不规则/断裂 PF 的回退搜索与保形选择。
% 中文说明：
% 这是改进版多目标 BHO 的核心实现。
% 整体框架包括：
% 1. 初始种群和 archive 构造
% 2. 精英/探索个体两类更新
% 3. 基于外部 archive 的非支配保留
% 4. 面向双目标复杂前沿的二次增强算子
% 5. 回退搜索与环境选择
% 6. HV 轨迹记录
validate_problem(problem);

lb = normalize_bound(lb, dim);
ub = normalize_bound(ub, dim);

if numel(lb) ~= dim || numel(ub) ~= dim
    error('The lengths of lb and ub must match dim.');
end
if maxEval < popSize
    error('maxEval must be at least popSize.');
end

nObj = problem.nObj;
if nargin < 7
    options = struct();
end
options = normalize_bho_options(options);
nGroups = min(4, popSize);
eliteRatio = 0.30;
archiveMaxSize = max(4 * popSize, 120);
seedPoolSize = min(maxEval, max(popSize, 3 * popSize));
weakCount = max(1, ceil(0.10 * popSize));
tau = 0.30 * sqrt(dim);
cCoeff = [0.5, 0.5, 0.5];
mutationEta = 20;
mutationProb = min(0.50, 1 / max(dim, 1) + 0.10);

template = blank_individual();
archive = repmat(template, 0, 1);
hvCurve = zeros(maxEval, 1);
bestHV = 0;
evalCount = 0;

[population, archive, refPoint, hvState, hvCurve, bestHV, evalCount] = ...
    initialize_population(popSize, seedPoolSize, lb, ub, dim, problem, ...
    template, archive, archiveMaxSize, hvCurve, bestHV, evalCount, options);

population = assign_groups(rank_and_crowd(population, nObj), nGroups, dim);
deltaX = zeros(popSize, dim);

while evalCount < maxEval
    % 每一轮先重新做非支配排序和分组，更新精英/弱个体身份
    population = assign_groups(rank_and_crowd(population, nObj), nGroups, dim);
    strongOrder = sort_by_rank_crowding(population);
    weakOrder = sort_by_weakness(population);

    eliteCount = max(1, ceil(eliteRatio * popSize));
    eliteMask = false(popSize, 1);
    eliteMask(strongOrder(1:eliteCount)) = true;
    weakMask = false(popSize, 1);
    weakMask(weakOrder(1:min(weakCount, popSize))) = true;

    offspring = repmat(template, 0, 1);

    for i = 1:popSize
        if evalCount >= maxEval
            break;
        end

        current = population(i);
        globalLeader = select_global_leader(archive, population);
        groupLeader = select_group_leader(population, current.Group, globalLeader);
        pBestLeader = personal_best_as_individual(current, template);

        if eliteMask(i)
            % 精英个体：更偏向全局 leader、组 leader 和个体历史最优的联合引导
            r = rand(1, dim);
            trialPosition = current.Position + deltaX(i, :) + ...
                cCoeff(1) * r .* (globalLeader.Position - current.Position) + ...
                cCoeff(2) * r .* (groupLeader.Position - current.Position) + ...
                cCoeff(3) * r .* (pBestLeader.Position - current.Position);
            if options.archiveDifferential
                trialPosition = add_archive_differential(trialPosition, archive, evalCount, maxEval);
            end
        else
            % 探索个体：更偏向个体差分搜索与方向性外扩
            j = randi(popSize);
            while j == i
                j = randi(popSize);
            end
            peer = population(j);
            stepScale = max(0.10, 2 * (1 - evalCount / maxEval));

            if locally_better(peer, current, archive, refPoint)
                direction = peer.Position - current.Position;
            else
                direction = current.Position - peer.Position;
            end

            trialPosition = current.Position + stepScale .* rand(1, dim) .* direction;
            if ~isempty(archive)
                trialPosition = trialPosition + 0.20 * rand(1, dim) .* ...
                    (globalLeader.Position - current.Position);
            end
            if options.archiveDifferential
                trialPosition = add_archive_differential(trialPosition, archive, evalCount, maxEval);
            end
        end

        if nObj == 2 && options.gapAwareRefinement
            % 双目标时额外加入交叉式细化，更适合不规则/断裂前沿
            trialPosition = biobjective_crossover_refinement(trialPosition, current, ...
                globalLeader, groupLeader, archive, lb, ub, evalCount, maxEval, refPoint);
        end
        if options.adaptiveMutation
            trialPosition = adaptive_polynomial_mutation(trialPosition, current.Position, ...
                lb, ub, mutationProb, mutationEta, evalCount, maxEval);
        end
        trialPosition = min(max(trialPosition, lb), ub);
        trial = evaluate_individual(trialPosition, problem, template);
        trial.ParentPosition = current.Position;
        trial = inherit_personal_best(trial, current);
        trial = update_personal_best(trial, archive, refPoint);
        acceptTrial = explorpolis_accept(trial, archive, lb, ub, tau, refPoint);

        evalCount = evalCount + 1;
        [archive, bestHV, hvCurve] = register_evaluation(archive, trial, ...
            bestHV, hvCurve, evalCount, archiveMaxSize, nObj, refPoint, hvState, ...
            options.gapAwareRefinement);

        if options.fallbackSearch && (~acceptTrial || weakMask(i)) && evalCount < maxEval
            % 若新解不理想，或当前个体属于弱个体，则再进行一次回退式搜索
            backoffPosition = backoff_try(current, archive, population, lb, ub, ...
                refPoint, options.gapAwareRefinement);
            if nObj == 2 && options.gapAwareRefinement
                backoffPosition = biobjective_crossover_refinement(backoffPosition, current, ...
                    globalLeader, groupLeader, archive, lb, ub, evalCount, maxEval, refPoint);
            end
            if options.adaptiveMutation
                backoffPosition = adaptive_polynomial_mutation(backoffPosition, current.Position, ...
                    lb, ub, min(0.75, mutationProb + 0.10), mutationEta, evalCount, maxEval);
            end
            backoff = evaluate_individual(backoffPosition, problem, template);
            backoff.ParentPosition = current.Position;
            backoff = inherit_personal_best(backoff, current);
            backoff = update_personal_best(backoff, archive, refPoint);

            evalCount = evalCount + 1;
            [archive, bestHV, hvCurve] = register_evaluation(archive, backoff, ...
                bestHV, hvCurve, evalCount, archiveMaxSize, nObj, refPoint, hvState, ...
                options.gapAwareRefinement);

            trial = pick_local_candidate(trial, backoff, archive, refPoint);
        end

        offspring(end + 1, 1) = trial; %#ok<AGROW>
    end

    if isempty(offspring)
        break;
    end

    combined = [population; offspring];
    population = environmental_select(combined, popSize, nObj, options.gapAwareRefinement);
    deltaX = compute_delta(population, dim);
end

archive = rank_and_crowd(archive, nObj);
hvCurve = hvCurve(1:evalCount);

result.finalPopulation = rank_and_crowd(population, nObj);
result.evalCount = evalCount;
result.feasibleCount = sum([result.finalPopulation.Feasible]);
result.archiveSize = numel(archive);
result.refPoint = refPoint;
end

function validate_problem(problem)
required = {'name', 'nObj', 'evalFcn'};
for i = 1:numel(required)
    if ~isfield(problem, required{i})
        error('problem.%s is required.', required{i});
    end
end
if ~isa(problem.evalFcn, 'function_handle')
    error('problem.evalFcn must be a function handle.');
end
if ~isscalar(problem.nObj) || problem.nObj < 2
    error('problem.nObj must be >= 2.');
end
end

function bound = normalize_bound(bound, dim)
bound = reshape(bound, 1, []);
if numel(bound) == 1
    bound = repmat(bound, 1, dim);
end
end

function ind = blank_individual()
ind.Position = [];
ind.Objectives = [];
ind.Constraints = [];
ind.CV = inf;
ind.Feasible = false;
ind.Rank = inf;
ind.CrowdingDistance = 0;
ind.Group = 1;
ind.PBestPosition = [];
ind.PBestObjectives = [];
ind.PBestConstraints = [];
ind.PBestCV = inf;
ind.ParentPosition = [];
end

function options = normalize_bho_options(options)
defaults = struct( ...
    'guidedInitialization', true, ...
    'archiveDifferential', true, ...
    'adaptiveMutation', true, ...
    'gapAwareRefinement', true, ...
    'fallbackSearch', true);

if nargin < 1 || isempty(options)
    options = defaults;
    return;
end

fields = fieldnames(defaults);
for i = 1:numel(fields)
    name = fields{i};
    if ~isfield(options, name) || isempty(options.(name))
        options.(name) = defaults.(name);
    else
        options.(name) = logical(options.(name));
    end
end
end

function [population, archive, refPoint, hvState, hvCurve, bestHV, evalCount] = ...
    initialize_population(popSize, seedPoolSize, lb, ub, dim, problem, ...
    template, archive, archiveMaxSize, hvCurve, bestHV, evalCount, options)
% 中文说明：
% 先构造一个更大的随机候选池，再从中选出更有代表性的初始中心，
% 以减轻纯随机初始化导致的前沿覆盖不足问题。

nObj = problem.nObj;
seedPool = repmat(template, seedPoolSize, 1);
hasRefPoint = isfield(problem, 'refPoint') && ~isempty(problem.refPoint);

if hasRefPoint
    refPoint = reshape(problem.refPoint, 1, []);
    if numel(refPoint) ~= nObj
        error('problem.refPoint length must match problem.nObj.');
    end
    hvState = prepare_hv_state(refPoint, nObj);
else
    refPoint = [];
    hvState = struct();
end

for i = 1:seedPoolSize
    x = lb + rand(1, dim) .* (ub - lb);
    seedPool(i) = initialize_personal_best(evaluate_individual(x, problem, template));
    evalCount = evalCount + 1;

    if hasRefPoint
        [archive, bestHV, hvCurve] = register_evaluation(archive, seedPool(i), ...
            bestHV, hvCurve, evalCount, archiveMaxSize, nObj, refPoint, hvState, ...
            options.gapAwareRefinement);
    end
end

if ~hasRefPoint
    refPoint = derive_ref_point(seedPool, nObj);
    fprintf('Reference point fallback was used: [%s]\n', num2str(refPoint));
    hvState = prepare_hv_state(refPoint, nObj);
    archive = repmat(template, 0, 1);
    bestHV = 0;

    for i = 1:evalCount
        [archive, bestHV, hvCurve] = register_evaluation(archive, seedPool(i), ...
            bestHV, hvCurve, i, archiveMaxSize, nObj, refPoint, hvState, ...
            options.gapAwareRefinement);
    end
end

seedPool = rank_and_crowd(seedPool, nObj);
if options.guidedInitialization
    population = choose_guided_centers(seedPool, popSize, lb, ub, refPoint, nObj);
else
    population = choose_seed_pool_without_guidance(seedPool, popSize);
end
population = rank_and_crowd(population, nObj);
for i = 1:numel(population)
    population(i).ParentPosition = population(i).Position;
end
end

function refPoint = derive_ref_point(population, nObj)
obj = reshape([population.Objectives], nObj, []).';
maxVal = max(obj, [], 1);
minVal = min(obj, [], 1);
span = max(maxVal - minVal, 1);
refPoint = maxVal + 0.10 * span;
end

function population = choose_guided_centers(seedPool, popSize, lb, ub, refPoint, nObj)
available = true(numel(seedPool), 1);
population = repmat(seedPool(1), 0, 1);

if any([seedPool.Feasible])
    ideal = min(reshape([seedPool([seedPool.Feasible]).Objectives], nObj, []).', [], 1);
else
    ideal = min(reshape([seedPool.Objectives], nObj, []).', [], 1);
end

while numel(population) < popSize
    rest = find(available);
    weights = rand(1, nObj);
    weights = weights / sum(weights);
    score = inf(numel(rest), 1);

    for i = 1:numel(rest)
        score(i) = tchebycheff_score(seedPool(rest(i)), ideal, weights, refPoint);
    end

    rankVal = [seedPool(rest).Rank].';
    [~, order] = sortrows([score, rankVal], [1, 2]);
    shortlist = rest(order(1:min(5, numel(order))));

    if isempty(population)
        chosen = shortlist(1);
    else
        diversity = zeros(numel(shortlist), 1);
        for i = 1:numel(shortlist)
            diversity(i) = decision_distance(seedPool(shortlist(i)).Position, population, lb, ub);
        end
        [~, pick] = max(diversity);
        chosen = shortlist(pick);
    end

    population(end + 1, 1) = seedPool(chosen); %#ok<AGROW>
    available(chosen) = false;
end
end

function population = choose_seed_pool_without_guidance(seedPool, popSize)
pick = randperm(numel(seedPool), popSize);
population = seedPool(pick);
end

function d = decision_distance(position, population, lb, ub)
if isempty(population)
    d = inf;
    return;
end

range = max(ub - lb, eps);
allPos = reshape([population.Position], numel(position), []).';
dist = sqrt(sum(((allPos - position) ./ range) .^ 2, 2));
d = min(dist);
end

function ind = evaluate_individual(position, problem, template)
ind = template;
ind.Position = reshape(position, 1, []);

try
    [obj, g] = problem.evalFcn(ind.Position);
catch ME
    if contains(ME.message, 'Too many output arguments')
        obj = problem.evalFcn(ind.Position);
        g = [];
    else
        rethrow(ME);
    end
end

ind.Objectives = reshape(obj, 1, []);
ind.Constraints = reshape(g, 1, []);

if numel(ind.Objectives) ~= problem.nObj
    error('The objective vector length must equal problem.nObj.');
end

if isempty(ind.Constraints)
    ind.CV = 0;
else
    ind.CV = sum(max(ind.Constraints, 0));
end

ind.Feasible = ind.CV <= 1e-12;
end

function ind = initialize_personal_best(ind)
ind.PBestPosition = ind.Position;
ind.PBestObjectives = ind.Objectives;
ind.PBestConstraints = ind.Constraints;
ind.PBestCV = ind.CV;
end

function ind = inherit_personal_best(ind, parent)
ind.PBestPosition = parent.PBestPosition;
ind.PBestObjectives = parent.PBestObjectives;
ind.PBestConstraints = parent.PBestConstraints;
ind.PBestCV = parent.PBestCV;
end

function pbest = personal_best_as_individual(ind, template)
pbest = template;
if isempty(ind.PBestPosition)
    pbest.Position = ind.Position;
    pbest.Objectives = ind.Objectives;
    pbest.Constraints = ind.Constraints;
    pbest.CV = ind.CV;
else
    pbest.Position = ind.PBestPosition;
    pbest.Objectives = ind.PBestObjectives;
    pbest.Constraints = ind.PBestConstraints;
    pbest.CV = ind.PBestCV;
end
pbest.Feasible = pbest.CV <= 1e-12;
end

function ind = update_personal_best(ind, archive, refPoint)
if isempty(ind.PBestPosition)
    ind = initialize_personal_best(ind);
    return;
end

old = personal_best_as_individual(ind, ind);
if constraint_dominates(ind, old)
    ind = initialize_personal_best(ind);
    return;
end
if constraint_dominates(old, ind)
    return;
end

newNovelty = objective_novelty(ind, archive, refPoint);
oldNovelty = objective_novelty(old, archive, refPoint);

if newNovelty > oldNovelty + 1e-12
    ind = initialize_personal_best(ind);
elseif abs(newNovelty - oldNovelty) <= 1e-12
    weights = rand(1, numel(ind.Objectives));
    weights = weights / sum(weights);
    ideal = min([ind.Objectives; old.Objectives], [], 1);
    if tchebycheff_score(ind, ideal, weights, refPoint) < ...
            tchebycheff_score(old, ideal, weights, refPoint)
        ind = initialize_personal_best(ind);
    end
end
end

function ok = explorpolis_accept(candidate, archive, lb, ub, tau, refPoint)
if isempty(archive)
    ok = true;
    return;
end

range = max(ub - lb, eps);
pos = reshape([archive.Position], numel(candidate.Position), []).';
dist = sqrt(sum(((pos - candidate.Position) ./ range) .^ 2, 2)) / max(numel(candidate.Position), 1);
near = archive(dist <= tau);

if isempty(near)
    ok = true;
    return;
end

for i = 1:numel(near)
    if constraint_dominates(near(i), candidate)
        ok = false;
        return;
    end
end

for i = 1:numel(near)
    if constraint_dominates(candidate, near(i))
        ok = true;
        return;
    end
end

ok = objective_novelty(candidate, archive, refPoint) >= median_archive_spacing(archive, refPoint);
end

function s = median_archive_spacing(archive, refPoint)
if numel(archive) <= 1
    s = 0;
    return;
end

scale = max(abs(refPoint), 1);
obj = reshape([archive.Objectives], numel(refPoint), []).' ./ scale;
nearest = inf(size(obj, 1), 1);

for i = 1:size(obj, 1)
    diff = obj - obj(i, :);
    dist = sqrt(sum(diff .^ 2, 2));
    dist(i) = inf;
    nearest(i) = min(dist);
end

s = median(nearest);
end

function archive = update_archive(archive, candidate, archiveMaxSize, nObj, useGapAwareRefinement)
% 中文说明：
% archive 仅保存可行且互不支配的代表性解，
% 用于后续 leader 选择、HV 记录和多样性维护。
if ~candidate.Feasible
    return;
end
if isempty(archive)
    archive = candidate;
    archive = rank_and_crowd(archive, nObj);
    return;
end

keep = true(numel(archive), 1);
for i = 1:numel(archive)
    if constraint_dominates(archive(i), candidate)
        return;
    end
    if constraint_dominates(candidate, archive(i))
        keep(i) = false;
    elseif norm(candidate.Objectives - archive(i).Objectives) <= 1e-10
        return;
    end
end

archive = archive(keep);
archive(end + 1, 1) = candidate; %#ok<AGROW>
archive = rank_and_crowd(archive, nObj);

if numel(archive) > archiveMaxSize
    if nObj == 2 && useGapAwareRefinement
        % 双目标时优先保留端点、稀疏段和断裂段附近的代表解。
        keepIdx = gap_preserving_subset_indices(archive, archiveMaxSize);
        archive = archive(keepIdx);
    else
        order = sort_by_rank_crowding(archive);
        archive = archive(order(1:archiveMaxSize));
    end
    archive = rank_and_crowd(archive, nObj);
end
end

function [archive, bestHV, hvCurve] = register_evaluation(archive, candidate, ...
    bestHV, hvCurve, evalCount, archiveMaxSize, nObj, refPoint, hvState, ...
    useGapAwareRefinement)
% 中文说明：
% 每次产生新解后同步更新 archive，并记录当前“历史最好 HV”。

archive = update_archive(archive, candidate, archiveMaxSize, nObj, useGapAwareRefinement);
if isempty(archive)
    currentHV = 0;
elseif mod(evalCount, hvState.updateStride) ~= 0 && evalCount < numel(hvCurve)
    currentHV = bestHV;
else
    currentHV = compute_hv(archive, refPoint, hvState);
end
bestHV = max(bestHV, currentHV);
hvCurve(evalCount) = bestHV;
end

function hvState = prepare_hv_state(refPoint, nObj)
hvState.refPoint = refPoint;
hvState.nObj = nObj;
if nObj > 2
    hvState.unitSamples = rand(1500, nObj);
else
    hvState.unitSamples = [];
end
if nObj > 3
    hvState.updateStride = 5;
else
    hvState.updateStride = 1;
end
end

function hv = compute_hv(archive, refPoint, hvState)
obj = reshape([archive.Objectives], numel(refPoint), []).';
obj = obj(all(obj < refPoint, 2), :);
if isempty(obj)
    hv = 0;
    return;
end

if numel(refPoint) == 2
    obj = sortrows(obj, 1);
    bestY = inf;
    clean = zeros(0, 2);
    for i = 1:size(obj, 1)
        if obj(i, 2) < bestY
            clean(end + 1, :) = obj(i, :); %#ok<AGROW>
            bestY = obj(i, 2);
        end
    end
    hv = 0;
    top = refPoint(2);
    for i = 1:size(clean, 1)
        hv = hv + max(refPoint(1) - clean(i, 1), 0) * max(top - clean(i, 2), 0);
        top = min(top, clean(i, 2));
    end
    return;
end

lower = min(obj, [], 1);
span = max(refPoint - lower, eps);
samples = lower + hvState.unitSamples .* span;
dominated = false(size(samples, 1), 1);
for i = 1:size(obj, 1)
    dominated = dominated | all(obj(i, :) <= samples, 2);
end
hv = prod(span) * mean(dominated);
end

function population = rank_and_crowd(population, nObj)
if isempty(population)
    return;
end

[population, fronts] = fast_sort(population);
for f = 1:numel(fronts)
    front = fronts{f};
    if isempty(front)
        continue;
    end

    for i = front
        population(i).CrowdingDistance = 0;
    end

    if numel(front) <= 2
        for i = front
            population(i).CrowdingDistance = inf;
        end
        continue;
    end

    if all(~[population(front).Feasible])
        values = [population(front).CV].';
        [sorted, order] = sort(values, 'ascend');
        idx = front(order);
        population(idx(1)).CrowdingDistance = inf;
        population(idx(end)).CrowdingDistance = inf;
        span = max(sorted(end) - sorted(1), eps);
        for k = 2:numel(idx) - 1
            if ~isinf(population(idx(k)).CrowdingDistance)
                population(idx(k)).CrowdingDistance = ...
                    population(idx(k)).CrowdingDistance + ...
                    (sorted(k + 1) - sorted(k - 1)) / span;
            end
        end
        continue;
    end

    obj = reshape([population(front).Objectives], nObj, []).';
    for j = 1:nObj
        [sorted, order] = sort(obj(:, j), 'ascend');
        idx = front(order);
        population(idx(1)).CrowdingDistance = inf;
        population(idx(end)).CrowdingDistance = inf;
        span = max(sorted(end) - sorted(1), eps);
        for k = 2:numel(idx) - 1
            if ~isinf(population(idx(k)).CrowdingDistance)
                population(idx(k)).CrowdingDistance = ...
                    population(idx(k)).CrowdingDistance + ...
                    (sorted(k + 1) - sorted(k - 1)) / span;
            end
        end
    end
end
end

function [population, fronts] = fast_sort(population)
n = numel(population);
S = cell(n, 1);
domCount = zeros(n, 1);
fronts = {[]};

for i = 1:n
    S{i} = [];
    domCount(i) = 0;
    for j = 1:n
        if i == j
            continue;
        end
        if constraint_dominates(population(i), population(j))
            S{i}(end + 1) = j; %#ok<AGROW>
        elseif constraint_dominates(population(j), population(i))
            domCount(i) = domCount(i) + 1;
        end
    end
    if domCount(i) == 0
        population(i).Rank = 1;
        fronts{1}(end + 1) = i; %#ok<AGROW>
    else
        population(i).Rank = inf;
    end
end

f = 1;
while true
    next = [];
    for i = fronts{f}
        for j = S{i}
            domCount(j) = domCount(j) - 1;
            if domCount(j) == 0
                population(j).Rank = f + 1;
                next(end + 1) = j; %#ok<AGROW>
            end
        end
    end
    if isempty(next)
        break;
    end
    fronts{f + 1} = next; %#ok<AGROW>
    f = f + 1;
end
end

function order = sort_by_rank_crowding(population)
r = [population.Rank].';
c = finite_crowding([population.CrowdingDistance].');
[~, order] = sortrows([r, -c], [1, 2]);
end

function order = sort_by_weakness(population)
r = [population.Rank].';
c = finite_crowding([population.CrowdingDistance].');
cv = [population.CV].';
[~, order] = sortrows([-r, c, -cv], [1, 2, 3]);
end

function c = finite_crowding(c)
mask = isfinite(c);
if any(mask)
    c(~mask) = max(c(mask)) + 1;
else
    c(:) = 1;
end
end

function population = environmental_select(population, popSize, nObj, useGapAwareRefinement)
% 中文说明：
% 环境选择负责在父代与子代合并后保留下一代种群，
% 本质上是多目标版本的“优胜劣汰”。
population = rank_and_crowd(population, nObj);
selected = [];
rankValue = 1;

while numel(selected) < popSize
    members = find([population.Rank] == rankValue);
    if isempty(members)
        break;
    end
    if numel(selected) + numel(members) <= popSize
        selected = [selected; members(:)]; %#ok<AGROW>
    else
        sub = population(members);
        fillCount = popSize - numel(selected);
        if nObj == 2 && useGapAwareRefinement
            % 双目标最后一层筛选时保留边界点与大间隙端点，减少断裂段丢失。
            localIdx = gap_preserving_subset_indices(sub, fillCount);
        else
            order = sort_by_rank_crowding(sub);
            localIdx = order(1:fillCount);
        end
        selected = [selected; members(localIdx).']; %#ok<AGROW>
        break;
    end
    rankValue = rankValue + 1;
end

population = rank_and_crowd(population(selected), nObj);
end

function population = assign_groups(population, nGroups, dim)
% 中文说明：
% 分组用于构造“组 leader”机制。
% 双目标时按前沿顺序分组，更利于覆盖前沿不同区段；
% 其他情形仍使用决策空间投影分组。
if isempty(population)
    return;
end

if numel(population(1).Objectives) == 2
    obj = reshape([population.Objectives], 2, []).';
    [~, order] = sort(obj(:, 1), 'ascend');
else
    pos = reshape([population.Position], dim, []).';
    proj = pos * randn(dim, 1);
    [~, order] = sort(proj, 'ascend');
end
groupId = ceil((1:numel(population))' * nGroups / numel(population));
assigned = zeros(numel(population), 1);
assigned(order) = groupId;

for i = 1:numel(population)
    population(i).Group = assigned(i);
end
end

function leader = select_global_leader(archive, population)
if ~isempty(archive)
    leader = sample_by_crowding(archive);
else
    leader = sample_by_crowding(population([population.Rank] == min([population.Rank])));
end
end

function leader = select_group_leader(population, groupId, fallback)
groupMembers = population([population.Group] == groupId);
if isempty(groupMembers)
    leader = fallback;
    return;
end
bestRank = min([groupMembers.Rank]);
leader = sample_by_crowding(groupMembers([groupMembers.Rank] == bestRank));
end

function ind = sample_by_crowding(population)
if numel(population) == 1
    ind = population;
    return;
end

c = [population.CrowdingDistance].';
infIdx = find(isinf(c));
if ~isempty(infIdx)
    ind = population(infIdx(randi(numel(infIdx))));
    return;
end

w = c - min(c) + eps;
w = w / sum(w);
ind = population(find(rand <= cumsum(w), 1, 'first'));
end

function better = locally_better(a, b, archive, refPoint)
if constraint_dominates(a, b)
    better = true;
    return;
end
if constraint_dominates(b, a)
    better = false;
    return;
end

weights = rand(1, numel(a.Objectives));
weights = weights / sum(weights);
ideal = min([a.Objectives; b.Objectives], [], 1);
if ~isempty(archive)
    ideal = min([ideal; reshape([archive.Objectives], numel(a.Objectives), []).'], [], 1);
end

scoreA = tchebycheff_score(a, ideal, weights, refPoint);
scoreB = tchebycheff_score(b, ideal, weights, refPoint);

if abs(scoreA - scoreB) <= 1e-12
    better = objective_novelty(a, archive, refPoint) >= objective_novelty(b, archive, refPoint);
else
    better = scoreA < scoreB;
end
end

function score = tchebycheff_score(ind, ideal, weights, refPoint)
scale = max(abs(refPoint - ideal), 1);
score = max(weights .* abs((ind.Objectives - ideal) ./ scale)) + 1e6 * ind.CV;
end

function novelty = objective_novelty(ind, archive, refPoint)
if isempty(archive)
    novelty = inf;
    return;
end
scale = max(abs(refPoint), 1);
obj = reshape([archive.Objectives], numel(refPoint), []).';
dist = sqrt(sum(((obj - ind.Objectives) ./ scale) .^ 2, 2));
novelty = min(dist);
end

function chosen = pick_local_candidate(a, b, archive, refPoint)
if constraint_dominates(a, b)
    chosen = a;
elseif constraint_dominates(b, a)
    chosen = b;
elseif locally_better(a, b, archive, refPoint)
    chosen = a;
else
    chosen = b;
end
end

function position = backoff_try(current, archive, population, lb, ub, refPoint, useGapAwareRefinement)
% 中文说明：
% 回退搜索用于给失败个体第二次机会。
% 双目标时会适度偏向更收敛的 archive leader，以增强跳出局部盆地的能力。
dim = numel(current.Position);
if isempty(archive)
    position = current.Position + 0.25 * randn(1, dim) .* (ub - lb);
    position = min(max(position, lb), ub);
    return;
end

isBiObjective = numel(current.Objectives) == 2;
if isBiObjective && useGapAwareRefinement
    gapInfo = archive_gap_profile(archive, refPoint);
    gapRatio = 1;
    if ~isempty(gapInfo.gaps)
        gapRatio = max(gapInfo.gaps) / max(median(gapInfo.gaps), 1e-12);
    end
    if gapRatio > 2.4 && rand < 0.70
        % 当前 archive 出现明显大缺口时，直接采用断裂段感知回退。
        position = gap_guided_backoff(current, archive, population, lb, ub, refPoint);
        position = min(max(position, lb), ub);
        return;
    end
end

if isBiObjective && useGapAwareRefinement && rand < 0.55
    leader = select_convergence_leader(archive, refPoint);
else
    leader = select_global_leader(archive, population);
end
strongOrder = sort_by_rank_crowding(population);
peer = population(strongOrder(randi(max(1, ceil(0.20 * numel(population))))));

position = leader.Position + rand(1, dim) .* (leader.Position - current.Position) + ...
    0.15 * randn(1, dim) .* (peer.Position - current.Position);

if isBiObjective && useGapAwareRefinement && rand < 0.35
    % 双目标困难问题中，最后一个变量通常决定局部/全局盆地，单维跳跃有助于跳出局部峰
    position(end) = lb(end) + rand * (ub(end) - lb(end));
    if dim > 1
        position(1:end-1) = 0.60 * position(1:end-1) + 0.40 * leader.Position(1:end-1);
    end
end
position = min(max(position, lb), ub);
end

function delta = compute_delta(population, dim)
delta = zeros(numel(population), dim);
for i = 1:numel(population)
    if ~isempty(population(i).ParentPosition)
        delta(i, :) = population(i).Position - population(i).ParentPosition;
    end
end
end

function position = add_archive_differential(position, archive, evalCount, maxEval)
% 中文说明：
% 从 archive 中抽取两个代表解做差分扰动，
% 让位置更新保留一定的“历史前沿方向”信息。
if numel(archive) < 2
    return;
end

idx = randperm(numel(archive), 2);
span = archive(idx(1)).Position - archive(idx(2)).Position;
scale = 0.25 * (1 - evalCount / maxEval);
position = position + scale .* randn(1, numel(position)) .* span;
end

function position = adaptive_polynomial_mutation(position, parent, lb, ub, prob, eta, evalCount, maxEval)
% 中文说明：
% 自适应多项式变异：
% 前期变异更强，后期逐渐减弱，用来平衡探索和收敛。
progress = evalCount / max(maxEval, 1);
effectiveProb = prob * (0.40 + 0.60 * (1 - progress));
mask = rand(1, numel(position)) < effectiveProb;

if ~any(mask)
    if rand < 0.15
        [~, idx] = max(abs(position - parent));
        mask(idx) = true;
    else
        return;
    end
end

mutated = position;
for j = find(mask)
    yl = lb(j);
    yu = ub(j);
    if yu <= yl
        continue;
    end

    y = min(max(mutated(j), yl), yu);
    delta1 = (y - yl) / (yu - yl);
    delta2 = (yu - y) / (yu - yl);
    rnd = rand;
    mutPow = 1 / (eta + 1);

    if rnd <= 0.5
        xy = 1 - delta1;
        val = 2 * rnd + (1 - 2 * rnd) * (xy^(eta + 1));
        deltaq = val^mutPow - 1;
    else
        xy = 1 - delta2;
        val = 2 * (1 - rnd) + 2 * (rnd - 0.5) * (xy^(eta + 1));
        deltaq = 1 - val^mutPow;
    end

    mutated(j) = y + deltaq * (yu - yl);
end

position = min(max(mutated, lb), ub);
end

function position = biobjective_crossover_refinement(position, current, globalLeader, ...
    groupLeader, archive, lb, ub, evalCount, maxEval, refPoint)
% 中文说明：
% 面向双目标问题的二次增强算子。
% 当 archive 呈现断裂特征时，更偏向稀疏区 leader；
% 当 archive 更像连续前沿时，更偏向收敛 leader。
progress = evalCount / max(maxEval, 1);
if progress < 0.10 || rand > (0.35 + 0.25 * progress)
    return;
end

if ~isempty(archive)
    gapInfo = archive_gap_profile(archive, refPoint);
    gapRatio = 1;
    if ~isempty(gapInfo.gaps)
        gapRatio = max(gapInfo.gaps) / max(median(gapInfo.gaps), 1e-12);
    end
    r = rand;
    if gapRatio > 3
        if r < 0.60
            mate = select_sparse_region_leader(archive, refPoint);
        elseif r < 0.75
            mate = select_convergence_leader(archive, refPoint);
        elseif r < 0.90
            mate = groupLeader;
        else
            mate = globalLeader;
        end
    else
        if r < 0.55
            mate = select_convergence_leader(archive, refPoint);
        elseif r < 0.75
            mate = select_sparse_region_leader(archive, refPoint);
        elseif r < 0.90
            mate = groupLeader;
        else
            mate = globalLeader;
        end
    end
elseif rand < 0.50
    mate = groupLeader;
else
    mate = globalLeader;
end

child = sbx_recombine(position, mate.Position, lb, ub, 18);

% 适度保留当前搜索方向，避免交叉后完全偏离 BHO 的主干更新
position = 0.70 * child + 0.30 * (position + 0.25 * (globalLeader.Position - current.Position));
position = real(position);
position = min(max(position, lb), ub);
end

function child = sbx_recombine(parent1, parent2, lb, ub, etaC)
% 中文说明：
% 简化版 SBX（模拟二进制交叉），用于双目标问题中的局部前沿修正。
child = parent1;
for j = 1:numel(parent1)
    if rand > 0.90 || abs(parent1(j) - parent2(j)) <= 1e-14
        continue;
    end

    y1 = min(parent1(j), parent2(j));
    y2 = max(parent1(j), parent2(j));
    yl = lb(j);
    yu = ub(j);
    randq = rand;

    beta = 1 + 2 * (y1 - yl) / max(y2 - y1, 1e-12);
    beta = max(beta, 1e-12);
    alpha = 2 - beta^(-(etaC + 1));
    if randq <= 1 / alpha
        betaq = (randq * alpha)^(1 / (etaC + 1));
    else
        betaq = (1 / (2 - randq * alpha))^(1 / (etaC + 1));
    end
    c1 = 0.5 * ((y1 + y2) - betaq * (y2 - y1));

    beta = 1 + 2 * (yu - y2) / max(y2 - y1, 1e-12);
    beta = max(beta, 1e-12);
    alpha = 2 - beta^(-(etaC + 1));
    if randq <= 1 / alpha
        betaq = (randq * alpha)^(1 / (etaC + 1));
    else
        betaq = (1 / (2 - randq * alpha))^(1 / (etaC + 1));
    end
    c2 = 0.5 * ((y1 + y2) + betaq * (y2 - y1));

    if rand < 0.5
        child(j) = c1;
    else
        child(j) = c2;
    end
end

child = real(child);
child = min(max(child, lb), ub);
end

function leader = select_sparse_region_leader(archive, refPoint)
% 中文说明：
% 选择 archive 中位于“目标空间最大缺口”两端的代表解，
% 用来补足稀疏段和断裂段。
gapInfo = archive_gap_profile(archive, refPoint);
if isempty(gapInfo.pairs)
    leader = sample_by_crowding(archive);
    return;
end

pair = gapInfo.pairs(gapInfo.order(1), :);
if rand < 0.5
    leader = archive(pair(1));
else
    leader = archive(pair(2));
end
end

function leader = select_convergence_leader(archive, refPoint)
% 中文说明：
% 选择 archive 中更靠近理想点的代表解，
% 用来把局部盆地中的个体往全局优良区域拉回。
obj = reshape([archive.Objectives], numel(refPoint), []).';
ideal = min(obj, [], 1);
scale = max(refPoint - ideal, 1e-12);
score = sum((obj - ideal) ./ scale, 2);
[~, idx] = min(score);
leader = archive(idx);
end

function position = gap_guided_backoff(current, archive, population, lb, ub, refPoint)
% 中文说明：
% 面向双目标大间隙/断裂前沿的回退策略。
% 优先围绕最大间隙两端和桥接区域重采样，减少某段 PF 被长期遗漏。
gapInfo = archive_gap_profile(archive, refPoint);
if isempty(gapInfo.pairs)
    leader = select_global_leader(archive, population);
    position = leader.Position + 0.20 * randn(1, numel(current.Position)) .* (ub - lb);
    position = min(max(position, lb), ub);
    return;
end

pair = gapInfo.pairs(gapInfo.order(1), :);
left = archive(pair(1));
right = archive(pair(2));

if rand < 0.30
    % 对不规则/断裂前沿，保留一定概率直接在稀疏端点附近跳跃
    anchor = left;
    if rand < 0.5
        anchor = right;
    end
    position = 0.65 * anchor.Position + 0.35 * current.Position + ...
        0.18 * randn(1, numel(current.Position)) .* (ub - lb);
else
    alpha = 0.35 + 0.30 * rand;
    midpoint = alpha * left.Position + (1 - alpha) * right.Position;
    span = right.Position - left.Position;
    position = midpoint + 0.20 * randn(1, numel(current.Position)) .* span + ...
        0.15 * rand(1, numel(current.Position)) .* (midpoint - current.Position);
end
if numel(current.Position) > 1 && rand < 0.45
    % 对常见的盆地切换变量做一次重采样，提升跨段跳转概率。
    position(end) = lb(end) + rand * (ub(end) - lb(end));
end
position = min(max(position, lb), ub);
end

function info = archive_gap_profile(archive, refPoint)
% 中文说明：
% 按目标值对 archive 排序，估计相邻点之间的缺口大小。
% 该信息可用于判断前沿是否存在明显断裂/稀疏段。
info = struct('pairs', [], 'gaps', [], 'order', []);
if numel(archive) < 2
    return;
end

obj = reshape([archive.Objectives], numel(refPoint), []).';
[obj, sortIdx] = sortrows(obj, 1);
scale = max(max(obj, [], 1) - min(obj, [], 1), 1e-12);

pairs = zeros(size(obj, 1) - 1, 2);
gaps = zeros(size(obj, 1) - 1, 1);
for i = 1:size(obj, 1) - 1
    pairs(i, :) = sortIdx(i:i+1);
    gaps(i) = norm((obj(i + 1, :) - obj(i, :)) ./ scale);
end
[~, order] = sort(gaps, 'descend');

info.pairs = pairs;
info.gaps = gaps;
info.order = order;
end

function keepIdx = gap_preserving_subset_indices(population, keepCount)
% 中文说明：
% 双目标保形截断策略。
% 先保留前沿两端、最收敛点和若干最大间隙端点，再用 maximin 准则补足其余位置。
if numel(population) <= keepCount
    keepIdx = 1:numel(population);
    return;
end

nObj = numel(population(1).Objectives);
obj = reshape([population.Objectives], nObj, []).';
[objSorted, sortIdx] = sortrows(obj, 1);

selectedLocal = [1, size(objSorted, 1)];

objMin = min(objSorted, [], 1);
objSpan = max(objSorted, [], 1) - objMin;
objSpan(objSpan <= 1e-12) = 1;
convScore = sum((objSorted - objMin) ./ objSpan, 2);
[~, convIdx] = min(convScore);
selectedLocal(end + 1) = convIdx; %#ok<AGROW>

if size(objSorted, 1) > 2
    gaps = sqrt(sum(((objSorted(2:end, :) - objSorted(1:end-1, :)) ./ objSpan) .^ 2, 2));
    [~, gapOrder] = sort(gaps, 'descend');
    gapQuota = min(numel(gapOrder), max(1, ceil(0.20 * keepCount)));
    for i = 1:gapQuota
        g = gapOrder(i);
        selectedLocal(end + 1:end + 2) = [g, g + 1]; %#ok<AGROW>
    end
end

selectedLocal = unique(selectedLocal, 'stable');
keepIdx = sortIdx(selectedLocal);

if numel(keepIdx) < keepCount
    remain = setdiff(1:numel(population), keepIdx);
    if ~isempty(remain)
        need = min(keepCount - numel(keepIdx), numel(remain));
        extraLocal = maximin_subset_indices(population(remain), need, nObj);
        keepIdx = [keepIdx(:); remain(extraLocal(:)).']; %#ok<AGROW>
    end
end

if numel(keepIdx) < keepCount
    order = sort_by_rank_crowding(population);
    for i = 1:numel(order)
        if ~ismember(order(i), keepIdx)
            keepIdx(end + 1) = order(i); %#ok<AGROW>
            if numel(keepIdx) >= keepCount
                break;
            end
        end
    end
end

keepIdx = unique(keepIdx, 'stable');
if numel(keepIdx) > keepCount
    keepIdx = keepIdx(1:keepCount);
end
keepIdx = sort(keepIdx);
end

function keepIdx = maximin_subset_indices(population, keepCount, nObj)
if numel(population) <= keepCount
    keepIdx = 1:numel(population);
    return;
end

obj = reshape([population.Objectives], nObj, []).';
objMin = min(obj, [], 1);
objSpan = max(obj, [], 1) - objMin;
objSpan(objSpan <= 1e-12) = 1;
obj = (obj - objMin) ./ objSpan;

seedIdx = unique(arrayfun(@(m) find(obj(:, m) == min(obj(:, m)), 1, 'first'), 1:nObj));
if isempty(seedIdx)
    seedIdx = 1;
end
seedIdx = seedIdx(:).';

while numel(seedIdx) < keepCount
    remain = setdiff(1:size(obj, 1), seedIdx);
    dist = pdist2(obj(remain, :), obj(seedIdx, :));
    [~, bestPos] = max(min(dist, [], 2));
    seedIdx(end + 1) = remain(bestPos); %#ok<AGROW>
end

keepIdx = sort(seedIdx(1:keepCount));
end

function flag = constraint_dominates(a, b)
if a.Feasible && ~b.Feasible
    flag = true;
elseif ~a.Feasible && b.Feasible
    flag = false;
elseif ~a.Feasible && ~b.Feasible
    flag = a.CV < b.CV - 1e-12;
else
    flag = all(a.Objectives <= b.Objectives) && any(a.Objectives < b.Objectives);
end
end
