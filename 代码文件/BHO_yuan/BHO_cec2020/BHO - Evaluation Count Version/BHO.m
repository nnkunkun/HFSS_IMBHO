function [archive, hvCurve, result] = BHO(popSize, maxEval, lb, ub, dim, problem, options)
% Wrapper kept for backward file compatibility. 中文：保留旧入口，内部转调新的多目标核心实现。
if nargin < 7
    options = struct();
end

[archive, hvCurve, result] = BHO_multiobjective_core( ...
    popSize, maxEval, lb, ub, dim, problem, options);
end
