function study = run_cec2020_mmo_study(varargin)
%RUN_CEC2020_MMO_STUDY Run the full CEC2020 MMO comparison study.
% 中文说明：
% 这是整套实验的总控脚本。
% 它会依次运行：
% 1. 选定的 CEC2020 MMO 问题
% 2. 四个对比算法 + 改进 BHO
% 3. 多次独立重复实验
% 然后自动汇总指标、输出表格、画图并生成文字报告。

cfg = default_config();
cfg = parse_name_value(cfg, varargin{:});

rootDir = fileparts(mfilename('fullpath'));
cfg.outputDir = fullfile(rootDir, 'results_cec2020_mmo');
if exist(cfg.outputDir, 'dir') ~= 7
    mkdir(cfg.outputDir);
end

addpath(genpath(resolve_platemo_root()));
problems = cec2020_mmo_selected_problems();
algorithms = algorithm_catalog();

nP = numel(problems);
nA = numel(algorithms);
nR = cfg.runs;

HV = nan(nP, nA, nR);
IGD = nan(nP, nA, nR);
Spread = nan(nP, nA, nR);
Spacing = nan(nP, nA, nR);
Runtime = nan(nP, nA, nR);
NDS = nan(nP, nA, nR);
records = cell(nP, nA, nR);

fprintf('Starting CEC2020 MMO study with %d problems, %d algorithms, %d runs.\n', nP, nA, nR);

for ip = 1:nP
    problem = problems(ip);
    fprintf('\n==== Problem %s (%d objectives, %d variables) ====\n', ...
        problem.tag, problem.nObj, problem.dim);

    for ir = 1:nR
        seed = cfg.baseSeed + ir - 1;
        fprintf('Run %d/%d, seed = %d\n', ir, nR, seed);

        for ia = 1:nA
            localCfg = cfg;
            localCfg.seed = seed;

            result = algorithms(ia).runner(problem, localCfg);
            metrics = compute_mo_metrics(result.decs, result.objs, problem.refPF, ...
                struct('hvSamples', cfg.hvSamples));

            HV(ip, ia, ir) = metrics.HV;
            IGD(ip, ia, ir) = metrics.IGD;
            Spread(ip, ia, ir) = metrics.Spread;
            Spacing(ip, ia, ir) = metrics.Spacing;
            Runtime(ip, ia, ir) = result.runtime;
            NDS(ip, ia, ir) = metrics.NDS;
            records{ip, ia, ir} = result;

            fprintf('  %-8s HV=%8.4f IGD=%8.4f Spread=%7.4f Spacing=%7.4f Time=%6.3fs\n', ...
                algorithms(ia).name, metrics.HV, metrics.IGD, metrics.Spread, ...
                metrics.Spacing, result.runtime);
        end
    end
end

study = struct();
study.config = cfg;
study.problems = problems;
study.algorithms = algorithms;
study.metrics.HV = HV;
study.metrics.IGD = IGD;
study.metrics.Spread = Spread;
study.metrics.Spacing = Spacing;
study.metrics.Runtime = Runtime;
study.metrics.NDS = NDS;
study.records = records;
study.summary = summarize_metrics(HV, IGD, Spread, Spacing, Runtime, NDS);
study.significance = pairwise_significance(HV, IGD, algorithms);

write_summary_tables(study);
plot_cec2020_visualizations(study);
export_cec2020_mmo_report(study);

save(fullfile(cfg.outputDir, 'cec2020_mmo_study.mat'), 'study', '-v7.3');
fprintf('\nStudy completed. Results saved to %s\n', cfg.outputDir);
end

function cfg = default_config()
cfg.runs = 30;
cfg.popSize = 60;
cfg.maxEval = 1500;
cfg.baseSeed = 2026;
cfg.hvSamples = 30000;
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

function algorithms = algorithm_catalog()
algorithms = struct( ...
    'name', {'NSGA-II', 'MOEA/D', 'NSGA-III', 'RVEA', 'IMBHO'}, ...
    'runner', { ...
        @(problem, cfg) run_platemo_baseline(@NSGAII, problem, cfg), ...
        @(problem, cfg) run_platemo_baseline(@MOEAD, problem, cfg), ...
        @(problem, cfg) run_platemo_baseline(@NSGAIII, problem, cfg), ...
        @(problem, cfg) run_platemo_baseline(@RVEA, problem, cfg), ...
        @(problem, cfg) run_bho_on_problem(problem, cfg)} ...
    );
end

function summary = summarize_metrics(HV, IGD, Spread, Spacing, Runtime, NDS)
summary.HV.mean = mean(HV, 3, 'omitnan');
summary.HV.std = std(HV, 0, 3, 'omitnan');
summary.IGD.mean = mean(IGD, 3, 'omitnan');
summary.IGD.std = std(IGD, 0, 3, 'omitnan');
summary.Spread.mean = mean(Spread, 3, 'omitnan');
summary.Spread.std = std(Spread, 0, 3, 'omitnan');
summary.Spacing.mean = mean(Spacing, 3, 'omitnan');
summary.Spacing.std = std(Spacing, 0, 3, 'omitnan');
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

function stats = pairwise_significance(HV, IGD, algorithms)
imbhoIdx = find(strcmp({algorithms.name}, 'IMBHO'), 1);
if isempty(imbhoIdx)
    stats = struct();
    return;
end

nP = size(HV, 1);
nA = size(HV, 2);
stats.HVBetterCount = zeros(1, nA);
stats.IGDBetterCount = zeros(1, nA);
stats.HVPValue = nan(nP, nA);
stats.IGDPValue = nan(nP, nA);

if exist('signrank', 'file') ~= 2
    return;
end

for ia = 1:nA
    if ia == imbhoIdx
        continue;
    end

    for ip = 1:nP
        hvA = squeeze(HV(ip, imbhoIdx, :));
        hvB = squeeze(HV(ip, ia, :));
        igdA = squeeze(IGD(ip, imbhoIdx, :));
        igdB = squeeze(IGD(ip, ia, :));

        stats.HVPValue(ip, ia) = safe_signrank(hvA, hvB);
        stats.IGDPValue(ip, ia) = safe_signrank(igdA, igdB);

        if mean(hvA, 'omitnan') > mean(hvB, 'omitnan') && stats.HVPValue(ip, ia) < 0.05
            stats.HVBetterCount(ia) = stats.HVBetterCount(ia) + 1;
        end
        if mean(igdA, 'omitnan') < mean(igdB, 'omitnan') && stats.IGDPValue(ip, ia) < 0.05
            stats.IGDBetterCount(ia) = stats.IGDBetterCount(ia) + 1;
        end
    end
end
end

function p = safe_signrank(a, b)
try
    if all(abs(a - b) < 1e-12)
        p = 1;
    else
        p = signrank(a, b);
    end
catch
    p = 1;
end
end

function write_summary_tables(study)
outputDir = study.config.outputDir;
problems = study.problems;
algorithms = study.algorithms;

tableCfg = table( ...
    ["runs"; "population_size"; "max_eval"; "hv_samples"], ...
    string([study.config.runs; study.config.popSize; study.config.maxEval; study.config.hvSamples]), ...
    'VariableNames', {'Item', 'Value'});
writetable(tableCfg, fullfile(outputDir, 'Study_Config.csv'));

tableII = table( ...
    string({problems.tag})', ...
    [problems.nObj]', ...
    [problems.dim]', ...
    string(arrayfun(@(p) bounds_to_string(p.lb, p.ub), problems, 'UniformOutput', false))', ...
    string({problems.pfFeature})', ...
    'VariableNames', {'Problem', 'Objectives', 'DecisionVariables', 'Bounds', 'PFCharacteristics'});
writetable(tableII, fullfile(outputDir, 'Table_II_Selected_CEC2020_Benchmarks.csv'));

tableIII = build_metric_table(study.summary.HV.mean, study.summary.HV.std, algorithms, problems);
writetable(tableIII, fullfile(outputDir, 'Table_III_HV_results.csv'));

tableIV = build_metric_table(study.summary.IGD.mean, study.summary.IGD.std, algorithms, problems);
writetable(tableIV, fullfile(outputDir, 'Table_IV_IGD_results.csv'));

tableV = table(string({algorithms.name})', ...
    study.summary.Friedman.HV.meanRank(:), ...
    study.summary.Friedman.IGD.meanRank(:), ...
    ((study.summary.Friedman.HV.meanRank(:) + study.summary.Friedman.IGD.meanRank(:)) ./ 2), ...
    'VariableNames', {'Algorithm', 'HVRank', 'IGDRank', 'AverageRank'});
writetable(tableV, fullfile(outputDir, 'Table_V_Friedman_ranking.csv'));
end

function T = build_metric_table(meanMatrix, stdMatrix, algorithms, problems)
nA = numel(algorithms);
nP = numel(problems);
contents = strings(nA, nP + 1);
contents(:, 1) = string({algorithms.name})';
for ip = 1:nP
    for ia = 1:nA
        contents(ia, ip + 1) = sprintf('%.4f +/- %.4f', meanMatrix(ip, ia), stdMatrix(ip, ia));
    end
end
varNames = [{'Algorithm'}, matlab.lang.makeValidName({problems.tag})];
T = cell2table(cellstr(contents), 'VariableNames', varNames);
end

function txt = bounds_to_string(lb, ub)
parts = cell(1, numel(lb));
for i = 1:numel(lb)
    parts{i} = sprintf('[%.2f, %.2f]', lb(i), ub(i));
end
txt = strjoin(parts, ' x ');
end
