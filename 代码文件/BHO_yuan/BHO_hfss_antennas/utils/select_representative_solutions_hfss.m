function [selectedIdx, labels] = select_representative_solutions_hfss(problem, records, obj, count)
% 中文说明：
% 从候选 Pareto 解中选出代表性工程方案。
% 优先包含“匹配优先 / 增益优先 / 带宽或方向图优先 / 折中解”等典型点，
% 然后再用 maximin 准则补足其余位置。

if nargin < 4
    count = 10;
end

if isempty(records)
    selectedIdx = [];
    labels = strings(0, 1);
    return;
end

n = height(records);
if n <= count
    selectedIdx = (1:n).';
    labels = repmat("Representative", n, 1);
    return;
end

selectedIdx = [];
labels = strings(0, 1);

switch upper(problem.problemId)
    case 'P1'
        [~, order] = sort(obj(:, 1), 'ascend');
        selectedIdx = order(1:count);
        labels = repmat("Low-|S11|", count, 1);
        return;

    case 'P2'
        [selectedIdx, labels] = add_anchor(records.AbsS11_f0_Linear, 'Matching-priority', selectedIdx, labels, 'ascend');
        [selectedIdx, labels] = add_anchor(records.Gain_f0_dBi, 'Gain-priority', selectedIdx, labels, 'descend');

    case 'P3'
        [selectedIdx, labels] = add_anchor(records.MeanAbsS11_Linear, 'Matching-priority', selectedIdx, labels, 'ascend');
        [selectedIdx, labels] = add_anchor(records.PeakGainProxy_dBi, 'Gain-priority', selectedIdx, labels, 'descend');
        [selectedIdx, labels] = add_anchor(records.BW_GHz, 'Bandwidth-priority', selectedIdx, labels, 'descend');

    case 'P4'
        [selectedIdx, labels] = add_anchor(records.Gmain_dBi, 'Gain-priority', selectedIdx, labels, 'descend');
        [selectedIdx, labels] = add_anchor(records.SLL_dB, 'SLL-priority', selectedIdx, labels, 'ascend');
        [selectedIdx, labels] = add_anchor(records.HPBW_deg, 'HPBW-priority', selectedIdx, labels, 'ascend');
        [selectedIdx, labels] = add_anchor(records.AbsS11_f0_Linear, 'Matching-priority', selectedIdx, labels, 'ascend');
end

objMin = min(obj, [], 1);
objSpan = max(obj, [], 1) - objMin;
objSpan(objSpan <= 1e-12) = 1;
objNorm = (obj - objMin) ./ objSpan;
balancedScore = max(objNorm, [], 2);
[~, balancedIdx] = min(balancedScore);
if ~ismember(balancedIdx, selectedIdx)
    selectedIdx(end + 1, 1) = balancedIdx; %#ok<AGROW>
    labels(end + 1, 1) = "Compromise"; %#ok<AGROW>
end

while numel(selectedIdx) < count
    remain = setdiff(1:n, selectedIdx);
    dist = pdist2(objNorm(remain, :), objNorm(selectedIdx, :));
    [~, bestPos] = max(min(dist, [], 2));
    selectedIdx(end + 1, 1) = remain(bestPos); %#ok<AGROW>
    labels(end + 1, 1) = "Representative"; %#ok<AGROW>
end
end

function [indices, labels] = add_anchor(values, labelName, indices, labels, mode)
valid = ~isnan(values);
if ~any(valid)
    return;
end

candidateIdx = find(valid);
candidateValues = values(valid);
if strcmpi(mode, 'descend')
    [~, order] = max(candidateValues);
else
    [~, order] = min(candidateValues);
end
pick = candidateIdx(order);
if ~ismember(pick, indices)
    indices(end + 1, 1) = pick; %#ok<AGROW>
    labels(end + 1, 1) = string(labelName); %#ok<AGROW>
end
end

