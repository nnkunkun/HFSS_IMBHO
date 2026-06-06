function problem = hfss_get_problem(problemId)
% 中文说明：
% 构造 HFSS 天线工程问题的统一描述结构。
% 优化阶段使用 IDW 代理评价，结果阶段再映射回最近真实 HFSS 样本。

dataset = load_hfss_antenna_dataset(problemId);

problem = struct();
problem.problemId = dataset.problemId;
problem.tag = sprintf('%s_%s', dataset.problemId, regexprep(dataset.antennaName, '\s+', ''));
problem.name = dataset.problemTitle;
problem.antennaName = dataset.antennaName;
problem.nObj = dataset.nObj;
problem.dim = dataset.dim;
problem.lb = dataset.lb;
problem.ub = dataset.ub;
problem.varNames = dataset.varNames;
problem.objNames = dataset.objNames;
problem.f0GHz = dataset.f0GHz;
problem.visualization = dataset.visualization;
problem.dataset = dataset;
problem.rootDir = fileparts(fileparts(mfilename('fullpath')));
% 统一预留参考帕累托前沿和参考点字段，避免 P1-P4 结构体字段不一致。
% 对单目标问题，这两个字段保持为空即可。
problem.refPF = [];
problem.refPoint = [];

if problem.nObj == 1
    problem.evalFcn = @(x) local_eval_single(x, dataset.model);
else
    problem.evalFcn = @(x) local_eval_multi(x, dataset.model);
    problem.refPF = dataset.refPF;
    problem.refPoint = dataset.refPoint;
end
end

function f = local_eval_single(x, model)
f = idw_predict(x, model);
f = f(1);
end

function [obj, g] = local_eval_multi(x, model)
obj = idw_predict(x, model);
if size(obj, 1) > 1
    obj = obj(1, :);
end
g = [];
end
