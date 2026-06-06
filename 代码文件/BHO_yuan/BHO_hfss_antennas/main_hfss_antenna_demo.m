clc; clear; close all;
% 中文说明：
% HFSS 天线版快速演示脚本。
% 默认演示 P2 Patch Antenna，便于快速检查数据加载、代理评价和 BHO 输出是否正常。

startup_hfss_paths();

problem = hfss_get_problem('P2');
cfg = struct('popSize', 40, 'maxEval', 160, 'seed', 2026, 'runs', 1, 'baseSeed', 2026, 'hvSamples', 10000);
disp(problem.name);
result = run_hfss_bho_problem(problem, cfg);
metrics = compute_mo_metrics_hfss(result.mappedDecs, result.mappedObjs, problem.dataset.refPF, struct('hvSamples', 10000));

disp('Representative mapped HFSS solutions:');
disp(result.mappedRecords(1:min(5, height(result.mappedRecords)), :));
disp(metrics);

