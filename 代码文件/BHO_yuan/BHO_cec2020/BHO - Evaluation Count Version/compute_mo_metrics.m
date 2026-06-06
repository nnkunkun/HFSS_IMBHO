function metrics = compute_mo_metrics(PopDec, PopObj, refPF, varargin)
%COMPUTE_MO_METRICS Compute standard multi-objective indicators.
% 中文说明：
% 统一计算多目标实验常用指标：
% HV、IGD、Spread、Spacing 以及非支配解个数。
% 这里直接复用 PlatEMO 的解对象格式，保证与基线算法口径一致。

opts.hvSamples = 200000;
if ~isempty(varargin)
    inputOpts = varargin{1};
    if isfield(inputOpts, 'hvSamples')
        opts.hvSamples = inputOpts.hvSamples;
    end
end

metrics = struct('HV', nan, 'IGD', nan, 'Spread', nan, ...
    'Spacing', nan, 'NDS', 0);

if isempty(PopObj)
    return;
end

PopCon = zeros(size(PopObj, 1), 1);
Population = SOLUTION(PopDec, PopObj, PopCon);
Best = Population.best;

if isempty(Best)
    return;
end

BestObj = Best.objs;
metrics.HV = local_hv(BestObj, refPF, opts.hvSamples);
metrics.IGD = mean(min(pdist2(refPF, BestObj), [], 2));
metrics.Spread = local_spread(BestObj, refPF);
metrics.Spacing = local_spacing(BestObj);
metrics.NDS = size(BestObj, 1);
end

function score = local_spacing(PopObj)
if isempty(PopObj)
    score = nan;
    return;
end
Distance = pdist2(PopObj, PopObj, 'cityblock');
Distance(logical(eye(size(Distance, 1)))) = inf;
score = std(min(Distance, [], 2));
end

function score = local_spread(PopObj, optimum)
if isempty(PopObj) || size(PopObj, 2) ~= size(optimum, 2)
    score = nan;
    return;
end
Dis1 = pdist2(PopObj, PopObj);
Dis1(logical(eye(size(Dis1, 1)))) = inf;
[~, E] = max(optimum, [], 1);
Dis2 = pdist2(optimum(E, :), PopObj);
d1 = sum(min(Dis2, [], 2));
d2 = mean(min(Dis1, [], 2));
den = d1 + max(size(PopObj, 1) - size(PopObj, 2), 1) * d2;
score = (d1 + sum(abs(min(Dis1, [], 2) - d2))) / max(den, eps);
end

function hv = local_hv(PopObj, refPF, sampleNum)
[N, M] = size(PopObj);
fmin = min(min(PopObj, [], 1), zeros(1, M));
fmax = max(refPF, [], 1);
scale = (fmax - fmin) * 1.1;
scale(scale <= eps) = 1;

PopObj = (PopObj - repmat(fmin, N, 1)) ./ repmat(scale, N, 1);
PopObj(any(PopObj > 1, 2), :) = [];
RefPoint = ones(1, M);

if isempty(PopObj)
    hv = 0;
elseif M < 4
    pl = sortrows(PopObj);
    S = {1, pl};
    for k = 1:M-1
        SNew = {};
        for i = 1:size(S, 1)
            slices = slice_front(S{i, 2}, k, RefPoint);
            for j = 1:size(slices, 1)
                entry = {slices{j, 1} * S{i, 1}, slices{j, 2}};
                SNew = add_slice(entry, SNew); %#ok<AGROW>
            end
        end
        S = SNew;
    end
    hv = 0;
    for i = 1:size(S, 1)
        p = head(S{i, 2});
        hv = hv + S{i, 1} * abs(p(M) - RefPoint(M));
    end
else
    MaxValue = RefPoint;
    MinValue = min(PopObj, [], 1);
    Samples = rand(sampleNum, M) .* repmat(MaxValue - MinValue, sampleNum, 1) + repmat(MinValue, sampleNum, 1);
    for i = 1:size(PopObj, 1)
        dominated = true(size(Samples, 1), 1);
        for m = 1:M
            dominated = dominated & PopObj(i, m) <= Samples(:, m);
        end
        Samples(dominated, :) = [];
        if isempty(Samples)
            break;
        end
    end
    hv = prod(MaxValue - MinValue) * (1 - size(Samples, 1) / sampleNum);
end
end

function S = slice_front(pl, k, RefPoint)
p = head(pl);
pl = tail(pl);
ql = [];
S = {};
while ~isempty(pl)
    ql = insert_point(p, k + 1, ql);
    pNext = head(pl);
    entry = {abs(p(k) - pNext(k)), ql};
    S = add_slice(entry, S);
    p = pNext;
    pl = tail(pl);
end
ql = insert_point(p, k + 1, ql);
entry = {abs(p(k) - RefPoint(k)), ql};
S = add_slice(entry, S);
end

function ql = insert_point(p, k, pl)
flag1 = false;
flag2 = false;
ql = [];
hp = head(pl);
while ~isempty(pl) && hp(k) < p(k)
    ql = [ql; hp]; %#ok<AGROW>
    pl = tail(pl);
    hp = head(pl);
end
ql = [ql; p];
m = length(p);
while ~isempty(pl)
    q = head(pl);
    for i = k:m
        if p(i) < q(i)
            flag1 = true;
        elseif p(i) > q(i)
            flag2 = true;
        end
    end
    if ~(flag1 && ~flag2)
        ql = [ql; q]; %#ok<AGROW>
    end
    pl = tail(pl);
end
end

function p = head(pl)
if isempty(pl)
    p = [];
else
    p = pl(1, :);
end
end

function ql = tail(pl)
if size(pl, 1) < 2
    ql = [];
else
    ql = pl(2:end, :);
end
end

function SNew = add_slice(entry, S)
found = false;
for k = 1:size(S, 1)
    if isequal(entry{2}, S{k, 2})
        S{k, 1} = S{k, 1} + entry{1};
        found = true;
        break;
    end
end
if ~found
    S(end+1, :) = entry; %#ok<AGROW>
end
SNew = S;
end
