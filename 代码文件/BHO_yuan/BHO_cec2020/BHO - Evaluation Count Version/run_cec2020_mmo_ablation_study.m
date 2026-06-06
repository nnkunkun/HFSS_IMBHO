function study = run_cec2020_mmo_ablation_study(varargin)
%RUN_CEC2020_MMO_ABLATION_STUDY Run the IMBHO module-level ablation study.
% 中文说明：
% 该脚本仅比较 IMBHO 完整版本及其关键模块消融版本，
% 自动汇总 HV/IGD/Friedman/Runtime 并导出论文可用表格。

cfg = default_config();
cfg = parse_name_value(cfg, varargin{:});

rootDir = fileparts(mfilename('fullpath'));
cfg.outputDir = fullfile(rootDir, 'results_cec2020_mmo_ablation');
if exist(cfg.outputDir, 'dir') ~= 7
    mkdir(cfg.outputDir);
end

addpath(genpath(resolve_platemo_root()));
problems = cec2020_mmo_selected_problems();
problems = filter_problems(problems, cfg.problemTags);
variants = ablation_catalog();

nP = numel(problems);
nA = numel(variants);
nR = cfg.runs;

HV = nan(nP, nA, nR);
IGD = nan(nP, nA, nR);
Runtime = nan(nP, nA, nR);
NDS = nan(nP, nA, nR);
records = cell(nP, nA, nR);

fprintf('Starting IMBHO ablation study with %d problems, %d variants, %d runs.\n', nP, nA, nR);

for ip = 1:nP
    problem = problems(ip);
    fprintf('\n==== Ablation problem %s (%d objectives, %d variables) ====\n', ...
        problem.tag, problem.nObj, problem.dim);

    for ir = 1:nR
        seed = cfg.baseSeed + ir - 1;
        if cfg.verboseEvery > 0 && (mod(ir - 1, cfg.verboseEvery) == 0 || ir == nR)
            fprintf('Run %d/%d, seed = %d\n', ir, nR, seed);
        end

        for ia = 1:nA
            localCfg = cfg;
            localCfg.seed = seed;
            localCfg.bhoOptions = variants(ia).options;
            localCfg.algorithmName = variants(ia).name;

            result = run_bho_on_problem(problem, localCfg);
            metrics = compute_mo_metrics(result.decs, result.objs, problem.refPF, ...
                struct('hvSamples', cfg.hvSamples));

            HV(ip, ia, ir) = metrics.HV;
            IGD(ip, ia, ir) = metrics.IGD;
            Runtime(ip, ia, ir) = result.runtime;
            NDS(ip, ia, ir) = metrics.NDS;
            records{ip, ia, ir} = result;

            if cfg.verboseEvery > 0 && (mod(ir - 1, cfg.verboseEvery) == 0 || ir == nR)
                fprintf('  %-20s HV=%8.4f IGD=%8.4f Time=%6.3fs\n', ...
                    variants(ia).name, metrics.HV, metrics.IGD, result.runtime);
            end
        end
    end
end

study = struct();
study.config = cfg;
study.problems = problems;
study.variants = variants;
study.metrics.HV = HV;
study.metrics.IGD = IGD;
study.metrics.Runtime = Runtime;
study.metrics.NDS = NDS;
study.records = records;
study.summary = summarize_metrics(HV, IGD, Runtime, NDS);

write_ablation_tables(study);
export_cec2020_mmo_ablation_report(study);

save(fullfile(cfg.outputDir, 'cec2020_mmo_ablation_study.mat'), 'study', '-v7.3');
fprintf('\nAblation study completed. Results saved to %s\n', cfg.outputDir);
end

function cfg = default_config()
cfg.runs = 30;
cfg.popSize = 60;
cfg.maxEval = 1500;
cfg.baseSeed = 2026;
cfg.hvSamples = 30000;
cfg.problemTags = {};
cfg.verboseEvery = 0;
end

function cfg = parse_name_value(cfg, varargin)
if mod(numel(varargin), 2) ~= 0
    error('Optional arguments must appear as name/value pairs.');
end
for i = 1:2:numel(varargin)
    name = varargin{i};
    if ~isfield(cfg, name)
        error('Unknown configuration field: %s', name);
    end
    cfg.(name) = varargin{i+1};
end
end

function problems = filter_problems(problems, problemTags)
if isempty(problemTags)
    return;
end

if isstring(problemTags)
    problemTags = cellstr(problemTags);
end

mask = ismember({problems.tag}, problemTags);
problems = problems(mask);
if isempty(problems)
    error('No problems matched the requested problemTags subset.');
end
end

function variants = ablation_catalog()
base = default_bho_options();
variants = struct( ...
    'name', { ...
        'IMBHO-full', ...
        'w/o guided init', ...
        'w/o archive diff', ...
        'w/o adaptive mut', ...
        'w/o gap-aware refine', ...
        'w/o fallback search'}, ...
    'options', { ...
        base, ...
        make_options(base, 'guidedInitialization', false), ...
        make_options(base, 'archiveDifferential', false), ...
        make_options(base, 'adaptiveMutation', false), ...
        make_options(base, 'gapAwareRefinement', false), ...
        make_options(base, 'fallbackSearch', false)} ...
    );
end

function options = default_bho_options()
options = struct( ...
    'guidedInitialization', true, ...
    'archiveDifferential', true, ...
    'adaptiveMutation', true, ...
    'gapAwareRefinement', true, ...
    'fallbackSearch', true);
end

function options = make_options(base, varargin)
options = base;
for i = 1:2:numel(varargin)
    options.(varargin{i}) = logical(varargin{i+1});
end
end

function summary = summarize_metrics(HV, IGD, Runtime, NDS)
summary.HV.mean = mean(HV, 3, 'omitnan');
summary.HV.std = std(HV, 0, 3, 'omitnan');
summary.IGD.mean = mean(IGD, 3, 'omitnan');
summary.IGD.std = std(IGD, 0, 3, 'omitnan');
summary.Runtime.mean = mean(Runtime, 3, 'omitnan');
summary.Runtime.std = std(Runtime, 0, 3, 'omitnan');
summary.NDS.mean = mean(NDS, 3, 'omitnan');
summary.NDS.std = std(NDS, 0, 3, 'omitnan');

summary.Friedman.HV = friedman_ranks(summary.HV.mean, true);
summary.Friedman.IGD = friedman_ranks(summary.IGD.mean, false);
end

function ranks = friedman_ranks(problemByAlgorithm, maximize)
nP = size(problemByAlgorithm, 1);
nA = size(problemByAlgorithm, 2);
rankMatrix = nan(nP, nA);
for i = 1:nP
    rankMatrix(i, :) = tied_rank(problemByAlgorithm(i, :), maximize);
end
ranks.rankMatrix = rankMatrix;
ranks.meanRank = mean(rankMatrix, 1, 'omitnan');
end

function rankRow = tied_rank(values, maximize)
if maximize
    values = -values;
end

[sortedVals, order] = sort(values, 'ascend');
rankRow = zeros(size(values));
i = 1;
while i <= numel(values)
    j = i;
    while j < numel(values) && abs(sortedVals(j + 1) - sortedVals(i)) < 1e-12
        j = j + 1;
    end
    avgRank = mean(i:j);
    rankRow(order(i:j)) = avgRank;
    i = j + 1;
end
end

function write_ablation_tables(study)
outputDir = study.config.outputDir;
problems = study.problems;
variants = study.variants;

tableCfg = table( ...
    ["runs"; "population_size"; "max_eval"; "hv_samples"; "problem_tags"], ...
    [string([study.config.runs; study.config.popSize; study.config.maxEval; study.config.hvSamples]); ...
     string(strjoin({study.problems.tag}, ','))], ...
    'VariableNames', {'Item', 'Value'});
writetable(tableCfg, fullfile(outputDir, 'Ablation_Config.csv'));

tableHV = build_metric_table(study.summary.HV.mean, study.summary.HV.std, variants, problems);
writetable(tableHV, fullfile(outputDir, 'Table_VI_Ablation_HV.csv'));

tableIGD = build_metric_table(study.summary.IGD.mean, study.summary.IGD.std, variants, problems);
writetable(tableIGD, fullfile(outputDir, 'Table_VII_Ablation_IGD.csv'));

hvBestCount = sum(study.summary.HV.mean >= max(study.summary.HV.mean, [], 2) - 1e-12, 1).';
igdBestCount = sum(study.summary.IGD.mean <= min(study.summary.IGD.mean, [], 2) + 1e-12, 1).';
tableSummary = table( ...
    string({variants.name})', ...
    on_off_column(variants, 'guidedInitialization'), ...
    on_off_column(variants, 'archiveDifferential'), ...
    on_off_column(variants, 'adaptiveMutation'), ...
    on_off_column(variants, 'gapAwareRefinement'), ...
    on_off_column(variants, 'fallbackSearch'), ...
    study.summary.Friedman.HV.meanRank(:), ...
    study.summary.Friedman.IGD.meanRank(:), ...
    (study.summary.Friedman.HV.meanRank(:) + study.summary.Friedman.IGD.meanRank(:)) / 2, ...
    hvBestCount, ...
    igdBestCount, ...
    mean(study.summary.Runtime.mean, 1, 'omitnan')', ...
    'VariableNames', { ...
        'Variant', 'GuidedInit', 'ArchiveDiff', 'AdaptiveMutation', 'GapAwareRefine', 'FallbackSearch', ...
        'HVRank', 'IGDRank', 'AverageRank', 'HVBestCount', 'IGDBestCount', 'MeanRuntimeS'});
writetable(tableSummary, fullfile(outputDir, 'Table_VIII_Ablation_Friedman.csv'));
writetable(tableSummary, fullfile(outputDir, 'Table_VIII_Ablation_Summary.csv'));
end

function T = build_metric_table(meanMatrix, stdMatrix, variants, problems)
nA = numel(variants);
nP = numel(problems);
contents = strings(nA, nP + 1);
contents(:, 1) = string({variants.name})';
for ip = 1:nP
    for ia = 1:nA
        contents(ia, ip + 1) = sprintf('%.4f +/- %.4f', meanMatrix(ip, ia), stdMatrix(ip, ia));
    end
end
varNames = [{'Variant'}, matlab.lang.makeValidName({problems.tag})];
T = cell2table(cellstr(contents), 'VariableNames', varNames);
end

function values = on_off_column(variants, fieldName)
values = strings(numel(variants), 1);
for i = 1:numel(variants)
    if variants(i).options.(fieldName)
        values(i) = "On";
    else
        values(i) = "Off";
    end
end
end

function export_cec2020_mmo_ablation_report(study)
outFile = fullfile(study.config.outputDir, 'CEC2020_MMO_ABLATION_REPORT.md');
fid = fopen(outFile, 'w');
if fid < 0
    error('Unable to create report file: %s', outFile);
end
cleanup = onCleanup(@() fclose(fid));

variants = study.variants;
problems = study.problems;
fullIdx = find(strcmp({variants.name}, 'IMBHO-full'), 1);

avgHV = mean(study.summary.HV.mean, 1, 'omitnan');
avgIGD = mean(study.summary.IGD.mean, 1, 'omitnan');
hvDrop = avgHV(fullIdx) - avgHV;
igdRise = avgIGD - avgIGD(fullIdx);
avgRank = (study.summary.Friedman.HV.meanRank + study.summary.Friedman.IGD.meanRank) / 2;
[~, bestRankIdx] = min(avgRank);

fprintf(fid, '# CEC2020 MMO Ablation Report\n\n');
fprintf(fid, 'Experimental setup: %d independent runs, population size %d, evaluation budget %d, HV Monte Carlo samples %d.\n\n', ...
    study.config.runs, study.config.popSize, study.config.maxEval, study.config.hvSamples);

fprintf(fid, '## A. Ablation Variants\n\n');
for i = 1:numel(variants)
    fprintf(fid, '- %s\n', variants(i).name);
end
fprintf(fid, '\n');

fprintf(fid, 'The ablation modules are Guided initialization, archive differential perturbation, adaptive mutation, gap-aware refinement, and fallback search. ');
fprintf(fid, 'Each ablated variant removes exactly one module while keeping the remaining modules identical to IMBHO-full.\n\n');

fprintf(fid, '## B. Quantitative Summary\n\n');
fprintf(fid, 'The best average Friedman rank in this run is obtained by %s. ', variants(bestRankIdx).name);

ablatedIdx = setdiff(1:numel(variants), fullIdx);
positiveHVDrop = hvDrop(ablatedIdx);
positiveIGDRise = igdRise(ablatedIdx);
[maxHVDrop, hvPos] = max(positiveHVDrop);
[maxIGDRise, igdPos] = max(positiveIGDRise);
hvWorstIdx = ablatedIdx(hvPos);
igdWorstIdx = ablatedIdx(igdPos);

if maxHVDrop > 0
    fprintf(fid, 'Relative to IMBHO-full, removing %s causes the largest average HV drop (%.4f). ', ...
        normalize_variant_name(variants(hvWorstIdx).name), maxHVDrop);
else
    fprintf(fid, 'Under this budget, no ablated variant shows a positive average HV drop relative to IMBHO-full. ');
end
if maxIGDRise > 0
    fprintf(fid, 'Removing %s causes the largest average IGD degradation (%.4f). ', ...
        normalize_variant_name(variants(igdWorstIdx).name), maxIGDRise);
else
    fprintf(fid, 'Under this budget, no ablated variant shows a positive average IGD degradation relative to IMBHO-full. ');
end
fprintf(fid, 'The formal interpretation should rely on the exported HV, IGD, and Friedman tables, especially when the run count is small.\n\n');

fprintf(fid, '## C. Exported Tables\n\n');
fprintf(fid, '- Table_VI_Ablation_HV.csv: mean +/- std HV on each selected problem.\n');
fprintf(fid, '- Table_VII_Ablation_IGD.csv: mean +/- std IGD on each selected problem.\n');
fprintf(fid, '- Table_VIII_Ablation_Friedman.csv: module switches, Friedman ranks, best counts, and mean runtime.\n');
fprintf(fid, '- Table_VIII_Ablation_Summary.csv: compatibility copy of the Friedman summary table.\n\n');

fprintf(fid, '## D. Per-Problem Notes\n\n');
for ip = 1:numel(problems)
    [~, bestHVIdx] = max(study.summary.HV.mean(ip, :));
    [~, bestIGDIdx] = min(study.summary.IGD.mean(ip, :));
    fprintf(fid, '- %s: best HV = %s, best IGD = %s\n', ...
        problems(ip).tag, variants(bestHVIdx).name, variants(bestIGDIdx).name);
end
end

function name = normalize_variant_name(name)
if strcmp(name, 'IMBHO-full')
    name = 'no module';
elseif startsWith(name, 'w/o ')
    name = extractAfter(name, 'w/o ');
end
end
