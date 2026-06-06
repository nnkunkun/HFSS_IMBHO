function result = run_platemo_baseline(algorithmHandle, problem, config)
%RUN_PLATEMO_BASELINE Run a PlatEMO baseline on a selected benchmark.
% 中文说明：
% 用统一接口运行 NSGA-II、MOEA/D、NSGA-III、RVEA 等基线算法，
% 并返回与 BHO 相同格式的结果结构体，方便后续统一算指标和出表。

persistent platemoReady
if isempty(platemoReady)
    addpath(genpath(resolve_platemo_root()));
    platemoReady = true;
end

ensure_cec2020_mmo_path(problem.rootDir);
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
cleanup = onCleanup(@() restore_warnings(warningState1, warningState2));
Algorithm.Solve(userProblem);

Population = Algorithm.result{end};
result.name = func2str(algorithmHandle);
result.decs = Population.decs;
result.objs = Population.objs;
result.cons = Population.cons;
result.runtime = Algorithm.metric.runtime;
result.fe = userProblem.FE;
end

function [dec, obj, con] = local_eval_user_problem(x, problem)
dec = x;
obj = cec2020_mmo_evaluate(x, problem);
con = 0;
end

function silent_output(~, ~)
end

function restore_warnings(state1, state2)
warning(state1);
warning(state2);
end
