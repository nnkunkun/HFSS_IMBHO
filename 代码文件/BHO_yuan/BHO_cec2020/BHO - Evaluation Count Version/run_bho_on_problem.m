function result = run_bho_on_problem(problem, config)
%RUN_BHO_ON_PROBLEM Run the improved BHO on a selected CEC2020 MMO problem.
% 中文说明：
% 调用改进后的 BHO 核心算法，整理 archive 与最终种群中的有效解，
% 最终输出成统一的 decs/objs/runtime 结构，方便和基线对比。

ensure_cec2020_mmo_path(problem.rootDir);
rng(config.seed, 'twister');
timerId = tic;

bhoOptions = struct();
if isfield(config, 'bhoOptions') && ~isempty(config.bhoOptions)
    bhoOptions = config.bhoOptions;
end

[archive, hvCurve, core] = BHO(config.popSize, config.maxEval, ...
    problem.lb, problem.ub, problem.dim, problem, bhoOptions);

finalPop = core.finalPopulation;

archiveDecs = zeros(0, problem.dim);
archiveObjs = zeros(0, problem.nObj);
if ~isempty(archive)
    archiveDecs = reshape([archive.Position], problem.dim, []).';
    archiveObjs = reshape([archive.Objectives], problem.nObj, []).';
end

finalDecs = reshape([finalPop.Position], problem.dim, []).';
finalObjs = reshape([finalPop.Objectives], problem.nObj, []).';

decs = [archiveDecs; finalDecs];
objs = [archiveObjs; finalObjs];

if ~isempty(objs)
    merged = unique([round(decs, 12), round(objs, 12)], 'rows', 'stable');
    decs = merged(:, 1:problem.dim);
    objs = merged(:, problem.dim+1:end);
end

if isfield(config, 'algorithmName') && ~isempty(config.algorithmName)
    result.name = config.algorithmName;
else
    result.name = 'IMBHO';
end
result.decs = decs;
result.objs = objs;
result.cons = zeros(size(objs, 1), 1);
result.runtime = toc(timerId);
result.fe = core.evalCount;
result.hvCurve = hvCurve;
result.archiveSize = size(objs, 1);
end
