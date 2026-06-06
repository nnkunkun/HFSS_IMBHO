function plot_cec2020_visualizations(study)
%PLOT_CEC2020_VISUALIZATIONS Draw representative Pareto-front visualizations.
% 中文说明：
% 自动绘制论文中需要的代表性 Pareto 前沿图：
% 双目标二维图、三目标三维图，以及高目标平行坐标图。

outDir = study.config.outputDir;
algNames = {study.algorithms.name};
colors = lines(numel(algNames));

plot_problem_overlay(study, 'MMF12', outDir, algNames, colors);
plot_problem_overlay(study, 'MMF14A_M3', outDir, algNames, colors);
plot_parallel_problem(study, 'MMF15A_M5', outDir, algNames, colors);
end

function plot_problem_overlay(study, tag, outDir, algNames, colors)
[problem, ip] = locate_problem(study, tag);
bestIdx = best_run_indices(study.metrics.HV, ip);

figure('Color', 'w', 'Position', [120 120 960 700]);
hold on;
grid on;
box on;

if problem.nObj == 2
    plot(problem.refPF(:, 1), problem.refPF(:, 2), 'k-', 'LineWidth', 1.5, 'DisplayName', 'Reference PF');
    for ia = 1:numel(algNames)
        result = study.records{ip, ia, bestIdx(ia)};
        objs = nondominated(result.objs);
        scatter(objs(:, 1), objs(:, 2), 30, 'MarkerFaceColor', colors(ia, :), ...
            'MarkerEdgeColor', 'none', 'DisplayName', algNames{ia}, 'MarkerFaceAlpha', 0.75);
    end
    xlabel('f_1');
    ylabel('f_2');
else
    plot3(problem.refPF(:, 1), problem.refPF(:, 2), problem.refPF(:, 3), 'k.', ...
        'MarkerSize', 6, 'DisplayName', 'Reference PF');
    for ia = 1:numel(algNames)
        result = study.records{ip, ia, bestIdx(ia)};
        objs = nondominated(result.objs);
        scatter3(objs(:, 1), objs(:, 2), objs(:, 3), 28, colors(ia, :), ...
            'filled', 'DisplayName', algNames{ia});
    end
    xlabel('f_1');
    ylabel('f_2');
    zlabel('f_3');
    view(36, 24);
end

title(sprintf('%s Pareto Front Comparison', problem.tag), 'Interpreter', 'none');
legend('Location', 'bestoutside');
hold off;
saveas(gcf, fullfile(outDir, sprintf('Figure_%s.png', problem.tag)));
close(gcf);
end

function plot_parallel_problem(study, tag, outDir, algNames, colors)
[problem, ip] = locate_problem(study, tag);
bestIdx = best_run_indices(study.metrics.HV, ip);

figure('Color', 'w', 'Position', [120 120 1300 500]);
tiledlayout(1, numel(algNames), 'TileSpacing', 'compact', 'Padding', 'compact');

for ia = 1:numel(algNames)
    nexttile;
    result = study.records{ip, ia, bestIdx(ia)};
    objs = nondominated(result.objs);
    objs = normalize_rows(objs);
    if size(objs, 1) > 35
        idx = round(linspace(1, size(objs, 1), 35));
        objs = objs(idx, :);
    end
    lightColor = 1 - 0.65 * (1 - colors(ia, :));
    plot(1:problem.nObj, objs', 'Color', lightColor, 'LineWidth', 0.9);
    hold on;
    plot(1:problem.nObj, mean(objs, 1), 'Color', colors(ia, :), 'LineWidth', 2.0);
    hold off;
    xlim([1, problem.nObj]);
    ylim([0, 1.02]);
    xticks(1:problem.nObj);
    xlabel('Objective index');
    ylabel('Normalized value');
    title(algNames{ia});
    grid on;
    box on;
end

sgtitle(sprintf('%s Parallel-Coordinate View', problem.tag), 'Interpreter', 'none');
saveas(gcf, fullfile(outDir, sprintf('Figure_%s.png', problem.tag)));
close(gcf);
end

function objs = normalize_rows(objs)
mins = min(objs, [], 1);
spans = max(objs, [], 1) - mins;
spans(spans <= eps) = 1;
objs = (objs - mins) ./ spans;
end

function [problem, ip] = locate_problem(study, tag)
ip = find(strcmp({study.problems.tag}, tag), 1);
if isempty(ip)
    error('Problem %s was not found in the study structure.', tag);
end
problem = study.problems(ip);
end

function idx = best_run_indices(HV, ip)
slice = reshape(HV(ip, :, :), size(HV, 2), size(HV, 3));
[~, idx] = max(slice, [], 2);
idx = idx(:)';
end

function objs = nondominated(objs)
if isempty(objs)
    return;
end
front = NDSort(objs, 1);
objs = objs(front == 1, :);
end
