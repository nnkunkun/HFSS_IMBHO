function [obj, g] = cec2020_mmo_problem_eval(x, problem)
%CEC2020_MMO_PROBLEM_EVAL BHO-compatible CEC2020 MMO evaluation wrapper.
% 中文说明：
% BHO 核心实现要求问题评价函数返回 [目标值, 约束值] 两个输出，
% 而 CEC2020 MMO 基准本身是无约束问题，所以这里补一个空约束返回。

obj = cec2020_mmo_evaluate(x, problem);
if size(obj, 1) > 1
    error('BHO expects a single-solution evaluation in cec2020_mmo_problem_eval.');
end
g = [];
end
