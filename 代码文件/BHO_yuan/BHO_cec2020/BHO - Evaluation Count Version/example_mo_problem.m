function problem = example_mo_problem()
%EXAMPLE_MO_PROBLEM Default CEC2020 MMO demo problem for quick testing.
% 中文说明：
% 这里给 main.m 提供默认测试问题。
% 当前默认选择 MMF12，便于观察断裂 Pareto 前沿上的表现。
problem = cec2020_mmo_get_problem('MMF12');
end
