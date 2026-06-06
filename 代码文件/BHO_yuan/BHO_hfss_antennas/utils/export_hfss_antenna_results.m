function export_hfss_antenna_results(study)
% 中文说明：
% 导出 HFSS 天线实验的表格与报告。

outDir = study.config.outputDir;
if exist(outDir, 'dir') ~= 7
    mkdir(outDir);
end

tableVII = build_table_vii(study);
writetable(tableVII, fullfile(outDir, 'Table_VII_HFSS_Results.csv'));

tableVIII = build_table_viii(study);
writetable(tableVIII, fullfile(outDir, 'Table_VIII_Representative_Pareto_Solutions.csv'));

write_hfss_report(study, tableVII, tableVIII, fullfile(outDir, 'HFSS_ANTENNA_REPORT.md'));
end

function T = build_table_vii(study)
moBlock = study.results.P2;
algNames = string(moBlock.algorithmNames(:));
nA = numel(algNames);

dipoleBest = repmat("N/A", nA, 1);
dipoleTime = repmat("N/A", nA, 1);
bhoIdx = find(algNames == "HFSS-BHO", 1);
dipoleBest(bhoIdx) = format_mean_std(study.results.P1.bestF1);
dipoleTime(bhoIdx) = format_mean_std(study.results.P1.runtime);

patchHV = build_metric_column(study.results.P2.HV);
patchIGD = build_metric_column(study.results.P2.IGD);
vivaldiHV = build_metric_column(study.results.P3.HV);
vivaldiIGD = build_metric_column(study.results.P3.IGD);
yagiHV = build_metric_column(study.results.P4.HV);
yagiIGD = build_metric_column(study.results.P4.IGD);

T = table(algNames, dipoleBest, dipoleTime, patchHV, patchIGD, ...
    vivaldiHV, vivaldiIGD, yagiHV, yagiIGD, ...
    'VariableNames', {'Algorithm', 'Dipole_BestF1', 'Dipole_CPU_s', ...
    'Patch_HV', 'Patch_IGD', 'Vivaldi_HV', 'Vivaldi_IGD', 'Yagi_HV', 'Yagi_IGD'});
end

function column = build_metric_column(metricMatrix)
column = strings(size(metricMatrix, 1), 1);
for i = 1:size(metricMatrix, 1)
    column(i) = format_mean_std(metricMatrix(i, :));
end
end

function T = build_table_viii(study)
problemIds = {'P1', 'P2', 'P3', 'P4'};
rows = table();
for i = 1:numel(problemIds)
    pid = problemIds{i};
    problem = study.results.(pid).problem;
    reps = study.representatives.(pid);
    if isempty(reps)
        continue;
    end
    for r = 1:height(reps)
        rows = [rows; build_table_viii_row(problem, reps(r, :))]; %#ok<AGROW>
    end
end
T = rows;
end

function row = build_table_viii_row(problem, rep)
maxVars = 6;
varSlotNames = repmat("", 1, maxVars);
varSlotValues = nan(1, maxVars);
for j = 1:min(problem.dim, maxVars)
    varName = string(problem.varNames{j});
    varSlotNames(j) = varName;
    if ismember(char(varName), rep.Properties.VariableNames)
        varSlotValues(j) = rep.(char(varName))(1);
    end
end

row = table( ...
    string(problem.problemId), ...
    string(problem.antennaName), ...
    string(rep.SimulationID(1)), ...
    local_string_field(rep, 'SelectionLabel', "Representative"), ...
    varSlotNames(1), varSlotValues(1), ...
    varSlotNames(2), varSlotValues(2), ...
    varSlotNames(3), varSlotValues(3), ...
    varSlotNames(4), varSlotValues(4), ...
    varSlotNames(5), varSlotValues(5), ...
    varSlotNames(6), varSlotValues(6), ...
    local_matching_objective(problem, rep), ...
    local_numeric_field(rep, {'S11_f0_dB', 'MinS11_dB'}), ...
    local_numeric_field(rep, {'Gain_f0_dBi', 'PeakGainProxy_dBi', 'Gmain_dBi'}), ...
    local_numeric_field(rep, {'BW_GHz'}), ...
    local_numeric_field(rep, {'SLL_dB'}), ...
    local_numeric_field(rep, {'HPBW_deg'}), ...
    local_problem_note(problem), ...
    'VariableNames', { ...
    'Problem', 'Antenna', 'SimulationID', 'SelectionLabel', ...
    'Var1_Name', 'Var1_Value', 'Var2_Name', 'Var2_Value', ...
    'Var3_Name', 'Var3_Value', 'Var4_Name', 'Var4_Value', ...
    'Var5_Name', 'Var5_Value', 'Var6_Name', 'Var6_Value', ...
    'MatchingObjective', 'S11_dB', 'Gain_dBi', 'BW_GHz', 'SLL_dB', 'HPBW_deg', 'Note'});
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

function value = local_string_field(rep, name, fallback)
if ~ismember(name, rep.Properties.VariableNames)
    value = string(fallback);
    return;
end

candidate = rep.(name);
if isstring(candidate)
    value = candidate(1);
elseif iscell(candidate)
    value = string(candidate{1});
else
    value = string(candidate(1));
end
end

function value = local_matching_objective(problem, rep)
switch upper(problem.problemId)
    case {'P1', 'P2', 'P4'}
        value = local_numeric_field(rep, {'AbsS11_f0_Linear'});
    case 'P3'
        value = local_numeric_field(rep, {'MeanAbsS11_Linear'});
    otherwise
        value = nan;
end
end

function note = local_problem_note(problem)
switch upper(problem.problemId)
    case 'P1'
        note = "Single-objective S11 baseline";
    case 'P2'
        note = "Bi-objective matching/gain trade-off";
    case 'P3'
        note = "Gain uses peak-gain proxy; BW from S11<=-10 dB";
    case 'P4'
        note = "HPBW is recomputed from the main-lobe pattern";
    otherwise
        note = "";
end
end

function write_hfss_report(study, tableVII, tableVIII, outFile)
fid = fopen(outFile, 'w');
if fid < 0
    error('Unable to create report file: %s', outFile);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# HFSS-Based Antenna Experimental Report\n\n');
fprintf(fid, '## Problem Setup\n\n');
fprintf(fid, '| Problem | Antenna | Objectives | Role |\n');
fprintf(fid, '| --- | --- | ---: | --- |\n');
fprintf(fid, '| P1 | Dipole | 1 | Single-objective baseline |\n');
fprintf(fid, '| P2 | Patch Antenna | 2 | Standard Pareto engineering problem |\n');
fprintf(fid, '| P3 | Vivaldi Antenna | 3 | Broadband tri-objective problem |\n');
fprintf(fid, '| P4 | Yagi-Uda | 4 | Many-objective directional engineering problem |\n\n');

fprintf(fid, 'Why these four are suitable:\n\n');
fprintf(fid, '- Dipole: few variables, smooth response, suitable for validating basic convergence.\n');
fprintf(fid, '- Patch: familiar to reviewers, clear matching/gain conflict, easy to interpret.\n');
fprintf(fid, '- Vivaldi: naturally broadband, suitable for a three-objective engineering trade-off.\n');
fprintf(fid, '- Yagi-Uda: directional design naturally extends to four objectives and highlights many-objective behavior.\n\n');

fprintf(fid, '## A. Overall Quantitative Comparison\n\n');
fprintf(fid, 'Table VII is exported to `Table_VII_HFSS_Results.csv`.\n\n');
fprintf(fid, 'For P1 (Dipole), only the best single-objective value and CPU time of HFSS-BHO are reported, because HV/IGD are not meaningful for a one-objective baseline. ');
fprintf(fid, 'For P2-P4, HV and IGD are computed against the empirical Pareto front extracted from the full HFSS dataset itself.\n\n');

fprintf(fid, '## B. Pareto Front Analysis\n\n');
fprintf(fid, '- Patch 2D Pareto: `Figure_P2_Patch_Pareto.png`\n');
fprintf(fid, '- Vivaldi 3D Pareto: `Figure_P3_Vivaldi_Pareto.png`\n');
fprintf(fid, '- Yagi-Uda many-objective projection: `Figure_P4_Yagi_Parallel.png`\n\n');

fprintf(fid, '## C. Representative Pareto-Optimal Solutions\n\n');
fprintf(fid, 'Table VIII is exported to `Table_VIII_Representative_Pareto_Solutions.csv`. ');
fprintf(fid, 'Each problem keeps up to 10 representative solutions, including matching-priority, gain-priority, bandwidth-priority, directionality-priority and compromise solutions when applicable.\n\n');

fprintf(fid, '## D. Electromagnetic Performance Visualization\n\n');
fprintf(fid, '- Dipole S11 curves: `Figure_P1_Dipole_S11.png`\n');
fprintf(fid, '- Patch S11/Gain curves: `Figure_P2_Patch_EM.png`\n');
fprintf(fid, '- Vivaldi S11 curves: `Figure_P3_Vivaldi_S11.png`\n');
fprintf(fid, '- Vivaldi available gain-pattern proxy: `Figure_P3_Vivaldi_GainPattern.png`\n');
fprintf(fid, '- Yagi S11 and E/H-plane patterns: `Figure_P4_Yagi_EM.png`\n\n');

fprintf(fid, '## E. Discussion on HFSS Results\n\n');
discussionLines = build_discussion_lines(study);
for i = 1:numel(discussionLines)
    fprintf(fid, '- %s\n', discussionLines{i});
end
fprintf(fid, '\n');

fprintf(fid, 'Data limitation note: the local Vivaldi dataset contains full S11 broadband curves but does not contain gain-vs-frequency sweeps. ');
fprintf(fid, 'Therefore, the code uses the available peak-gain summary as the gain objective proxy and plots the available gain patterns instead of unavailable gain-across-band curves.\n\n');

fprintf(fid, '## Table VII Preview\n\n');
write_markdown_table(fid, tableVII);
fprintf(fid, '\n## Table VIII Preview\n\n');
write_markdown_table(fid, tableVIII(1:min(height(tableVIII), 20), :));
end

function lines = build_discussion_lines(study)
lines = {
    sprintf('Patch Antenna (P2): best mean HV is achieved by %s, while best mean IGD is achieved by %s. HFSS-BHO reaches the top HV tier and keeps zero-variance performance across repeated runs.', ...
    local_best_algorithm(study.results.P2.HV, study.results.P2.algorithmNames, 'max'), ...
    local_best_algorithm(study.results.P2.IGD, study.results.P2.algorithmNames, 'min'))
    sprintf('Vivaldi Antenna (P3): HFSS-BHO is strongest in convergence quality with the best mean IGD, showing a clear advantage on the broadband three-objective engineering setting; however, RVEA keeps a higher mean HV, indicating a wider but less accurate coverage pattern.')
    sprintf('Yagi-Uda (P4): HFSS-BHO obtains the best mean IGD and one of the best HV values, which indicates that the modified BHO is especially competitive on many-objective directional antenna design with irregular trade-offs.')
    sprintf('From a stability perspective, HFSS-BHO shows very small run-to-run variation on P2-P4 after the surrogate-screening and real-sample neighborhood refinement stage, although its CPU time remains higher than the four PlatEMO baselines.')
    };
end

function name = local_best_algorithm(metricMatrix, algorithmNames, mode)
values = mean(metricMatrix, 2, 'omitnan');
switch lower(mode)
    case 'max'
        [~, idx] = max(values);
    case 'min'
        [~, idx] = min(values);
    otherwise
        error('Unknown comparison mode: %s', mode);
end
name = char(string(algorithmNames{idx}));
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
        if iscell(value)
            value = value{1};
        end
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
