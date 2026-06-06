function problem = cec2020_mmo_get_problem(tag)
%CEC2020_MMO_GET_PROBLEM Return a selected CEC2020 MMO benchmark setup.
% 中文说明：
% 该函数用于根据问题标签构造统一的问题描述结构体。
% 结构体中包含目标数、维数、边界、参考 PF、评价函数句柄等信息，
% 方便 BHO 与 PlatEMO 基线算法共用同一套实验接口。

rootDir = fileparts(mfilename('fullpath'));
tag = upper(strrep(strrep(tag, '-', '_'), ' ', ''));

problem = struct();
problem.suite = 'CEC2020 MMO';
problem.rootDir = rootDir;
problem.tag = '';
problem.name = '';
problem.functionName = '';
problem.nObj = [];
problem.dim = [];
problem.lb = [];
problem.ub = [];
problem.refPFFile = '';
problem.pfRadius = [];
problem.pfFeature = '';
problem.visualization = '';
problem.numPeaks = 2;
problem.constraintFcn = [];

switch tag
    case 'MMF1'
        problem.tag = 'MMF1';
        problem.name = 'MMF1';
        problem.functionName = 'MMF1';
        problem.nObj = 2;
        problem.dim = 2;
        problem.lb = [1, -1];
        problem.ub = [3, 1];
        problem.refPFFile = fullfile(rootDir, 'cec2020_mmo', 'reference_pf', ...
            'MMF1_Reference_PSPF_data.mat');
        problem.pfFeature = 'Continuous concave PF with multimodal decision space';
        problem.visualization = '2d';

    case 'MMF10'
        problem.tag = 'MMF10';
        problem.name = 'MMF10';
        problem.functionName = 'MMF10';
        problem.nObj = 2;
        problem.dim = 2;
        problem.lb = [0.1, 0.1];
        problem.ub = [1.1, 1.1];
        problem.refPFFile = fullfile(rootDir, 'cec2020_mmo', 'reference_pf', ...
            'MMF10_Reference_PSPF_data.mat');
        problem.pfFeature = 'Continuous irregular PF with one global and one local basin';
        problem.visualization = '2d';

    case 'MMF11'
        problem.tag = 'MMF11';
        problem.name = 'MMF11';
        problem.functionName = 'MMF11';
        problem.nObj = 2;
        problem.dim = 2;
        problem.lb = [0.1, 0.1];
        problem.ub = [1.1, 1.1];
        problem.refPFFile = fullfile(rootDir, 'cec2020_mmo', 'reference_pf', ...
            'MMF11_Reference_PSPF_data.mat');
        problem.pfFeature = 'Continuous PF with local-global basin competition';
        problem.visualization = '2d';

    case 'MMF12'
        problem.tag = 'MMF12';
        problem.name = 'MMF12';
        problem.functionName = 'MMF12';
        problem.nObj = 2;
        problem.dim = 2;
        problem.lb = [0, 0];
        problem.ub = [1, 1];
        problem.refPFFile = fullfile(rootDir, 'cec2020_mmo', 'reference_pf', ...
            'MMF12_Reference_PSPF_data.mat');
        problem.pfFeature = 'Disconnected PF with multimodal local structures';
        problem.visualization = '2d';

    case 'MMF14A_M3'
        problem.tag = 'MMF14A_M3';
        problem.name = 'MMF14-a';
        problem.functionName = 'MMF14_a';
        problem.nObj = 3;
        problem.dim = 4;
        problem.lb = zeros(1, problem.dim);
        problem.ub = ones(1, problem.dim);
        problem.refPFFile = fullfile(rootDir, 'cec2020_mmo', 'reference_pf', ...
            'MMF14_a_Reference_PSPF_data.mat');
        problem.pfRadius = 2;
        problem.pfFeature = 'Scalable spherical PF with multiple equivalent global Pareto sets';
        problem.visualization = '3d';

    case 'MMF15A_M5'
        problem.tag = 'MMF15A_M5';
        problem.name = 'MMF15-a';
        problem.functionName = 'MMF15_a';
        problem.nObj = 5;
        problem.dim = 6;
        problem.lb = zeros(1, problem.dim);
        problem.ub = ones(1, problem.dim);
        problem.refPFFile = '';
        problem.pfRadius = 2;
        problem.pfFeature = 'High-dimensional spherical PF with one global and multiple local Pareto sets';
        problem.visualization = 'parallel';

    otherwise
        error('Unsupported CEC2020 MMO problem tag: %s', tag);
end

problem.evalFcn = @(x) cec2020_mmo_problem_eval(x, problem);
problem.refPF = cec2020_mmo_reference_pf(problem);

pfSpan = max(problem.refPF, [], 1) - min(problem.refPF, [], 1);
problem.refPoint = max(problem.refPF, [], 1) + 0.10 .* max(pfSpan, 1e-3);
end
