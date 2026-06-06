function result = run_platemo_baseline_hfss(algorithmHandle, problem, config)
% 中文说明：
% 用统一接口运行 NSGA-II、MOEA/D、NSGA-III、RVEA 等多目标基线算法，
% 并把输出解集映射回最近的真实 HFSS 样本。

persistent platemoReady
if isempty(platemoReady)
    startup_hfss_paths();
    platemoReady = true;
end

rng(config.seed, 'twister');
evalFcn = @(x) local_eval_user_problem(x, problem);
userProblem = UserProblem( ...
    'N', config.popSize, ...
    'D', problem.dim, ...
    'maxFE', config.maxEval, ...
    'lower', problem.lb, ...
    'upper', problem.ub, ...
    'evalFcn', evalFcn);

Algorithm = algorithmHandle('save', 0, 'outputFcn', @silent_output);
warningState1 = warning('off', 'MATLAB:singularMatrix');
warningState2 = warning('off', 'MATLAB:nearlySingularMatrix');
cleanup = onCleanup(@() restore_warnings(warningState1, warningState2)); %#ok<NASGU>
Algorithm.Solve(userProblem);

Population = Algorithm.result{end};
result = struct();
result.name = func2str(algorithmHandle);
result.decs = Population.decs;
result.objs = Population.objs;
result.cons = Population.cons;
result.runtime = Algorithm.metric.runtime;
result.fe = userProblem.FE;

mapped = map_to_real_samples(result.decs, problem.dataset);
result.mappedDecs = mapped.decs;
result.mappedObjs = mapped.objs;
result.mappedRecords = mapped.records;
end

function [dec, obj, con] = local_eval_user_problem(x, problem)
dec = x;
obj = idw_predict(x, problem.dataset.model);
con = 0;
end

function silent_output(~, ~)
end

function restore_warnings(state1, state2)
warning(state1);
warning(state2);
end

