function [archive, hvCurve, result] = BHO_multiobjective_core_hfss(popSize, maxEval, lb, ub, dim, problem)
% 中文说明：
% HFSS 天线工程版多目标 BHO 入口包装器。
% 该文件保留新工程目录中的统一命名，同时复用已验证的多目标核心实现。

persistent coreReady
if isempty(coreReady)
    coreDir = fullfile(fileparts(fileparts(fileparts(mfilename('fullpath')))), ...
        'BHO_cec2020', 'BHO - Evaluation Count Version');
    addpath(coreDir);
    coreReady = true;
end

[archive, hvCurve, result] = BHO_multiobjective_core(popSize, maxEval, lb, ub, dim, problem);
end

