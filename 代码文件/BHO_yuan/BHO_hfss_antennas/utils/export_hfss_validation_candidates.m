function allRows = export_hfss_validation_candidates(outputDir, countPerProblem)
% 中文说明：
% 导出一套适合拿去 HFSS 二次复算的验证解清单。
% P1 输出单目标最优附近的 6 个代表解；
% P2/P4 输出真实 HFSS 数据中的代表性 Pareto 解；
% P3 如果真实 Pareto 数量不足 6，则补充近 Pareto 工程候选，并明确标注。

if nargin < 1 || isempty(outputDir)
    rootDir = fileparts(fileparts(mfilename('fullpath')));
    outputDir = fullfile(rootDir, 'results_hfss');
end
if nargin < 2 || isempty(countPerProblem)
    countPerProblem = 6;
end
if exist(outputDir, 'dir') ~= 7
    mkdir(outputDir);
end

problemIds = {'P1', 'P2', 'P3', 'P4'};
allRows = table();
for i = 1:numel(problemIds)
    problem = hfss_get_problem(problemIds{i});
    rows = build_problem_candidates(problem, countPerProblem);
    allRows = [allRows; rows]; %#ok<AGROW>
    writetable(rows, fullfile(outputDir, sprintf('%s_HFSS_validation_candidates.csv', problem.problemId)));
end

writetable(allRows, fullfile(outputDir, 'HFSS_validation_candidates_all.csv'));
write_validation_markdown(allRows, fullfile(outputDir, 'HFSS_validation_candidates.md'));
end

function rows = build_problem_candidates(problem, countPerProblem)
records = problem.dataset.records;
obj = problem.dataset.obj;

if problem.nObj == 1
    [~, order] = sort(obj(:, 1), 'ascend');
    chosen = order(1:min(countPerProblem, numel(order)));
    labels = arrayfun(@(k) sprintf('Best-S11-%d', k), 1:numel(chosen), 'UniformOutput', false);
    sourceTags = repmat("Best-single-objective", numel(chosen), 1);
    rows = build_rows_from_indices(problem, chosen, string(labels(:)), sourceTags);
    return;
end

ndMask = non_dominated_mask(obj);
ndIdx = find(ndMask);
ndRecords = records(ndMask, :);
ndObj = obj(ndMask, :);

takeCount = min(countPerProblem, height(ndRecords));
[selectedLocalIdx, labels] = select_representative_solutions_hfss(problem, ndRecords, ndObj, takeCount);
chosen = ndIdx(selectedLocalIdx(:));
labelStrings = string(labels(:));
sourceTags = repmat("Pareto-optimal", numel(chosen), 1);

if numel(chosen) < countPerProblem
    extraNeed = countPerProblem - numel(chosen);
    [extraIdx, extraLabels] = select_near_pareto_candidates(problem, chosen, extraNeed);
    chosen = [chosen; extraIdx(:)]; %#ok<AGROW>
    labelStrings = [labelStrings; extraLabels(:)]; %#ok<AGROW>
    sourceTags = [sourceTags; repmat("Near-Pareto", numel(extraIdx), 1)]; %#ok<AGROW>
end

rows = build_rows_from_indices(problem, chosen, labelStrings, sourceTags);
end

function [selectedIdx, labels] = select_near_pareto_candidates(problem, excludedIdx, extraNeed)
obj = problem.dataset.obj;
n = size(obj, 1);
pool = setdiff((1:n).', excludedIdx(:), 'stable');
if isempty(pool) || extraNeed <= 0
    selectedIdx = zeros(0, 1);
    labels = strings(0, 1);
    return;
end

ideal = min(obj, [], 1);
span = max(obj, [], 1) - ideal;
span(span <= 1e-12) = 1;
objNorm = (obj - ideal) ./ span;
score = max(objNorm, [], 2) + 0.15 * mean(objNorm, 2);
poolScore = score(pool);
[~, order] = sort(poolScore, 'ascend');
orderedPool = pool(order);

selectedIdx = zeros(0, 1);
labels = strings(0, 1);
seedCount = min(numel(orderedPool), max(12, 4 * extraNeed));
candidatePool = orderedPool(1:seedCount);

selectedIdx(end + 1, 1) = candidatePool(1); %#ok<AGROW>
labels(end + 1, 1) = "Near-Pareto-1"; %#ok<AGROW>

while numel(selectedIdx) < min(extraNeed, numel(candidatePool))
    remain = setdiff(candidatePool, selectedIdx, 'stable');
    if isempty(remain)
        break;
    end
    dist = pdist2(objNorm(remain, :), objNorm(selectedIdx, :));
    [~, pos] = max(min(dist, [], 2));
    selectedIdx(end + 1, 1) = remain(pos); %#ok<AGROW>
    labels(end + 1, 1) = "Near-Pareto-" + string(numel(selectedIdx)); %#ok<AGROW>
end
end

function rows = build_rows_from_indices(problem, indices, labels, sourceTags)
indices = indices(:);
labels = labels(:);
sourceTags = sourceTags(:);

rows = table();
for i = 1:numel(indices)
    rows = [rows; build_candidate_row(problem, indices(i), labels(i), sourceTags(i), i)]; %#ok<AGROW>
end
end

function row = build_candidate_row(problem, idx, label, sourceTag, rankId)
records = problem.dataset.records;
rep = records(idx, :);

maxVars = 6;
varNames = repmat("", 1, maxVars);
varValues = nan(1, maxVars);
for j = 1:min(problem.dim, maxVars)
    varNames(j) = string(problem.varNames{j});
    varValues(j) = rep.(problem.varNames{j})(1);
end

row = table( ...
    string(problem.problemId), ...
    string(problem.antennaName), ...
    rankId, ...
    string(label), ...
    string(sourceTag), ...
    string(rep.SimulationID(1)), ...
    problem.f0GHz, ...
    varNames(1), varValues(1), ...
    varNames(2), varValues(2), ...
    varNames(3), varValues(3), ...
    varNames(4), varValues(4), ...
    varNames(5), varValues(5), ...
    varNames(6), varValues(6), ...
    local_numeric_field(rep, {'AbsS11_f0_Linear', 'MeanAbsS11_Linear'}), ...
    local_numeric_field(rep, {'S11_f0_dB', 'MinS11_dB'}), ...
    local_numeric_field(rep, {'Gain_f0_dBi', 'PeakGainProxy_dBi', 'Gmain_dBi'}), ...
    local_numeric_field(rep, {'BW_GHz'}), ...
    local_numeric_field(rep, {'SLL_dB'}), ...
    local_numeric_field(rep, {'HPBW_deg'}), ...
    local_note(problem, sourceTag), ...
    'VariableNames', { ...
    'Problem', 'Antenna', 'Rank', 'SelectionLabel', 'CandidateType', 'SimulationID', 'f0_GHz', ...
    'Var1_Name', 'Var1_Value', 'Var2_Name', 'Var2_Value', ...
    'Var3_Name', 'Var3_Value', 'Var4_Name', 'Var4_Value', ...
    'Var5_Name', 'Var5_Value', 'Var6_Name', 'Var6_Value', ...
    'MatchingMetric', 'S11_dB', 'Gain_dBi', 'BW_GHz', 'SLL_dB', 'HPBW_deg', 'Note'});
end

function value = local_numeric_field(rep, names)
value = nan;
for i = 1:numel(names)
    if ismember(names{i}, rep.Properties.VariableNames)
        candidate = rep.(names{i});
        if ~isempty(candidate)
            value = candidate(1);
            return;
        end
    end
end
end

function note = local_note(problem, sourceTag)
if problem.nObj == 1
    note = "Single-objective best solution for HFSS recheck";
    return;
end

switch upper(problem.problemId)
    case 'P2'
        note = "Patch true Pareto sample from HFSS dataset";
    case 'P3'
        if sourceTag == "Pareto-optimal"
            note = "True Pareto sample from HFSS dataset";
        else
            note = "Near-Pareto candidate because current Vivaldi dataset has only 3 true Pareto samples";
        end
    case 'P4'
        note = "Yagi true Pareto sample from HFSS dataset";
    otherwise
        note = "";
end
end

function write_validation_markdown(T, outFile)
fid = fopen(outFile, 'w');
if fid < 0
    error('Unable to create validation markdown file: %s', outFile);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# HFSS Validation Candidates\n\n');
fprintf(fid, 'This file lists around 6 verification candidates for each antenna problem.\n\n');
fprintf(fid, '- `P1 / Dipole`: top single-objective solutions.\n');
fprintf(fid, '- `P2 / Patch Antenna`: true Pareto-optimal HFSS samples.\n');
fprintf(fid, '- `P3 / Vivaldi Antenna`: 3 true Pareto-optimal samples plus supplementary near-Pareto candidates.\n');
fprintf(fid, '- `P4 / Yagi-Uda`: representative true Pareto-optimal HFSS samples.\n\n');

problemIds = unique(string(T.Problem), 'stable');
for i = 1:numel(problemIds)
    pid = problemIds(i);
    sub = T(string(T.Problem) == pid, :);
    fprintf(fid, '## %s\n\n', pid);
    write_markdown_table(fid, sub);
    fprintf(fid, '\n');
end
end

function write_markdown_table(fid, T)
headers = string(T.Properties.VariableNames);
fprintf(fid, '| %s |\n', strjoin(headers, ' | '));
fprintf(fid, '|');
for i = 1:numel(headers)
    fprintf(fid, ' --- |');
end
fprintf(fid, '\n');

for r = 1:height(T)
    cells = strings(1, width(T));
    for c = 1:width(T)
        value = T{r, c};
        if isnumeric(value)
            if isscalar(value)
                if isnan(value)
                    cells(c) = "NaN";
                else
                    cells(c) = string(value);
                end
            else
                cells(c) = "array";
            end
        else
            cells(c) = string(value);
        end
    end
    fprintf(fid, '| %s |\n', strjoin(cells, ' | '));
end
end
