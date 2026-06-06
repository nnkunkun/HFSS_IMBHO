function result = run_hfss_bho_problem(problem, config)
% 中文说明：
% 统一运行 HFSS 天线版 BHO。
% P1 走单目标 BHO，P2-P4 走多目标 BHO，并在结束后映射回真实 HFSS 样本。

timerId = tic;
if problem.nObj == 1
    result = BHO_singleobjective_hfss(problem, config);
    result.runtime = toc(timerId);
    mapped = map_to_real_samples(result.decs, problem.dataset);
    result.mappedDecs = mapped.decs;
    result.mappedObjs = mapped.objs;
    result.mappedRecords = mapped.records;
    return;
end

[archive, hvCurve, core] = BHO_multiobjective_core_hfss(config.popSize, config.maxEval, ...
    problem.lb, problem.ub, problem.dim, problem);

finalPop = core.finalPopulation;
archiveDecs = zeros(0, problem.dim);
archiveObjs = zeros(0, problem.nObj);
if ~isempty(archive)
    archiveDecs = reshape([archive.Position], problem.dim, []).';
    archiveObjs = reshape([archive.Objectives], problem.nObj, []).';
end
finalDecs = reshape([finalPop.Position], problem.dim, []).';
finalObjs = reshape([finalPop.Objectives], problem.nObj, []).';

result = struct();
result.name = 'HFSS-BHO-MO';
result.rawDecs = [archiveDecs; finalDecs];
result.rawObjs = [archiveObjs; finalObjs];
result.decs = hfss_surrogate_refinement(result.rawDecs, problem, config);
if isempty(result.decs)
    result.decs = result.rawDecs;
end
result.objs = idw_predict(result.decs, problem.dataset.model);
result.hvCurve = hvCurve;
result.fe = core.evalCount;
result.runtime = toc(timerId);

mapped = map_to_real_samples(result.decs, problem.dataset);
result.mappedDecs = mapped.decs;
result.mappedObjs = mapped.objs;
result.mappedRecords = mapped.records;
end
