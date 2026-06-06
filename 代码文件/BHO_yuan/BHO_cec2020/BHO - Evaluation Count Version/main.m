clc; clear; close all;
% 中文说明：
% main.m 用于快速演示当前改进版 BHO 在一个默认 CEC2020 MMO 问题上的运行效果，
% 适合做单问题调试与可视化检查。

addpath(genpath(resolve_platemo_root()));
rng(1);

problem = example_mo_problem();
cfg = struct('popSize', 100, 'maxEval', 4000, 'seed', 1);
disp([problem.tag, ' | Objectives: ', num2str(problem.nObj), ' | Dim: ', num2str(problem.dim)]);
disp('IMBHO is now running on a selected CEC2020 multimodal multi-objective benchmark');

result = run_bho_on_problem(problem, cfg);
metrics = compute_mo_metrics(result.decs, result.objs, problem.refPF);
archiveObjectives = NDSort(result.objs, 1);
archiveObjectives = result.objs(archiveObjectives == 1, :);

figure('Color', 'w', 'Position', [100 100 1000 420]);

if problem.nObj == 2
    subplot(1, 2, 1);
    plot(problem.refPF(:, 1), problem.refPF(:, 2), 'k-', 'LineWidth', 1.2);
    hold on;
    scatter(archiveObjectives(:, 1), archiveObjectives(:, 2), 24, 'r', 'filled');
    hold off;
    xlabel('f_1');
    ylabel('f_2');
    title([problem.tag, ' Pareto Front']);
    legend('Reference PF', 'IMBHO', 'Location', 'best');
    grid on;
    box on;
elseif problem.nObj == 3
    subplot(1, 2, 1);
    plot3(problem.refPF(:, 1), problem.refPF(:, 2), problem.refPF(:, 3), 'k.');
    hold on;
    scatter3(archiveObjectives(:, 1), archiveObjectives(:, 2), archiveObjectives(:, 3), 24, 'r', 'filled');
    hold off;
    xlabel('f_1');
    ylabel('f_2');
    zlabel('f_3');
    title([problem.tag, ' Pareto Front']);
    legend('Reference PF', 'IMBHO', 'Location', 'best');
    grid on;
    box on;
else
    subplot(1, 2, 1);
    parallelcoords(archiveObjectives);
    xlabel('Objective index');
    ylabel('Objective value');
    title([problem.tag, ' Parallel Coordinates']);
    grid on;
    box on;
end

subplot(1, 2, 2);
plot(result.hvCurve, 'b-', 'LineWidth', 1.6);
xlabel('Evaluation #');
ylabel('Best-so-far Hypervolume');
title('Hypervolume Curve');
grid on;
box on;

disp(metrics);

