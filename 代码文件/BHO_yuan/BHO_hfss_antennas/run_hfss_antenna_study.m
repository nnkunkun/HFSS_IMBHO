function study = run_hfss_antenna_study(varargin)
% 中文说明：
% 运行四个 HFSS 天线问题的完整实验。
% P1 使用单目标 BHO 做收敛性基线验证；
% P2-P4 使用 NSGA-II、MOEA/D、NSGA-III、RVEA 与 HFSS-BHO 做对比。

startup_hfss_paths();
cfg = default_config();
cfg = parse_name_value(cfg, varargin{:});
rootDir = fileparts(mfilename('fullpath'));
cfg.outputDir = fullfile(rootDir, 'results_hfss');
if exist(cfg.outputDir, 'dir') ~= 7
    mkdir(cfg.outputDir);
end

problems = hfss_problem_catalog();
algorithms = algorithm_catalog();
study = struct();
study.config = cfg;
study.problems = problems;

for i = 1:numel(problems)
    problem = problems(i);
    pid = problem.problemId;
    fprintf('\n==== %s | %s | objectives=%d ====\n', pid, problem.antennaName, problem.nObj);

    if problem.nObj == 1
        resultBlock = struct();
        resultBlock.problem = problem;
        resultBlock.algorithmNames = {'HFSS-BHO'};
        resultBlock.records = cell(cfg.runs, 1);
        resultBlock.bestF1 = nan(cfg.runs, 1);
        resultBlock.runtime = nan(cfg.runs, 1);

        for ir = 1:cfg.runs
            localCfg = cfg;
            localCfg.seed = cfg.baseSeed + ir - 1;
            result = run_hfss_bho_problem(problem, localCfg);
            resultBlock.records{ir} = result;
            resultBlock.bestF1(ir) = min(result.mappedObjs(:, 1));
            resultBlock.runtime(ir) = result.runtime;
            fprintf('Run %d/%d | HFSS-BHO best f1 = %.6f | time = %.3fs\n', ...
                ir, cfg.runs, resultBlock.bestF1(ir), result.runtime);
        end
    else
        nA = numel(algorithms);
        resultBlock = struct();
        resultBlock.problem = problem;
        resultBlock.algorithmNames = {algorithms.name};
        resultBlock.records = cell(nA, cfg.runs);
        resultBlock.HV = nan(nA, cfg.runs);
        resultBlock.IGD = nan(nA, cfg.runs);
        resultBlock.Spread = nan(nA, cfg.runs);
        resultBlock.Spacing = nan(nA, cfg.runs);
        resultBlock.Runtime = nan(nA, cfg.runs);
        resultBlock.NDS = nan(nA, cfg.runs);

        for ir = 1:cfg.runs
            localCfg = cfg;
            localCfg.seed = cfg.baseSeed + ir - 1;
            fprintf('Run %d/%d, seed = %d\n', ir, cfg.runs, localCfg.seed);

            for ia = 1:nA
                result = algorithms(ia).runner(problem, localCfg);
                metrics = compute_mo_metrics_hfss(result.mappedDecs, result.mappedObjs, ...
                    problem.dataset.refPF, struct('hvSamples', cfg.hvSamples));

                resultBlock.records{ia, ir} = result;
                resultBlock.HV(ia, ir) = metrics.HV;
                resultBlock.IGD(ia, ir) = metrics.IGD;
                resultBlock.Spread(ia, ir) = metrics.Spread;
                resultBlock.Spacing(ia, ir) = metrics.Spacing;
                resultBlock.Runtime(ia, ir) = result.runtime;
                resultBlock.NDS(ia, ir) = metrics.NDS;

                fprintf('  %-10s HV=%8.4f IGD=%8.4f Time=%6.3fs NDS=%4d\n', ...
                    algorithms(ia).name, metrics.HV, metrics.IGD, result.runtime, metrics.NDS);
            end
        end
    end

    study.results.(pid) = resultBlock;
end

study.representatives = build_representative_blocks(study);
export_hfss_antenna_results(study);
plot_hfss_pareto_figures(study);
plot_hfss_em_figures(study);
save(fullfile(cfg.outputDir, 'hfss_antenna_study.mat'), 'study', '-v7.3');
fprintf('\nHFSS antenna study completed. Results saved to %s\n', cfg.outputDir);
end

function cfg = default_config()
cfg.runs = 5;
cfg.popSize = 60;
cfg.maxEval = 300;
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
    cfg.(name) = varargin{i + 1};
end
end

function algorithms = algorithm_catalog()
algorithms = struct( ...
    'name', {'NSGA-II', 'MOEA/D', 'NSGA-III', 'RVEA', 'HFSS-BHO'}, ...
    'runner', { ...
        @(problem, cfg) run_platemo_baseline_hfss(@NSGAII, problem, cfg), ...
        @(problem, cfg) run_platemo_baseline_hfss(@MOEAD, problem, cfg), ...
        @(problem, cfg) run_platemo_baseline_hfss(@NSGAIII, problem, cfg), ...
        @(problem, cfg) run_platemo_baseline_hfss(@RVEA, problem, cfg), ...
        @(problem, cfg) run_hfss_bho_problem(problem, cfg)} ...
    );
end

function representativeBlocks = build_representative_blocks(study)
problemIds = fieldnames(study.results);
representativeBlocks = struct();

for i = 1:numel(problemIds)
    pid = problemIds{i};
    block = study.results.(pid);
    problem = block.problem;

    if problem.nObj == 1
        allRecords = table();
        for ir = 1:numel(block.records)
            allRecords = [allRecords; block.records{ir}.mappedRecords]; %#ok<AGROW>
        end
    else
        bhoIdx = find(strcmp(block.algorithmNames, 'HFSS-BHO'), 1);
        allRecords = table();
        for ir = 1:size(block.records, 2)
            allRecords = [allRecords; block.records{bhoIdx, ir}.mappedRecords]; %#ok<AGROW>
        end
    end

    if isempty(allRecords)
        representativeBlocks.(pid) = table();
        continue;
    end

    [~, uniqueIdx] = unique(string(allRecords.SimulationID), 'stable');
    candidateRecords = allRecords(uniqueIdx, :);
    [tf, loc] = ismember(string(candidateRecords.SimulationID), string(problem.dataset.records.SimulationID));
    candidateRecords = candidateRecords(tf, :);
    candidateObj = problem.dataset.obj(loc(tf), :);
    if size(candidateObj, 2) > 1
        ndMask = non_dominated_mask(candidateObj);
        candidateRecords = candidateRecords(ndMask, :);
        candidateObj = candidateObj(ndMask, :);
    end

    [selectedIdx, labels] = select_representative_solutions_hfss(problem, candidateRecords, candidateObj, 10);
    reps = candidateRecords(selectedIdx, :);
    reps.SelectionLabel = labels(:);
    representativeBlocks.(pid) = reps;
end
end

