function plot_hfss_pareto_figures(study)
% 中文说明：
% 输出 Patch / Vivaldi / Yagi-Uda 的 Pareto 可视化图。

outDir = study.config.outputDir;

plot_patch_pareto(study.results.P2.problem, study.representatives.P2, outDir);
plot_vivaldi_pareto(study.results.P3.problem, study.representatives.P3, outDir);
plot_yagi_parallel(study.results.P4.problem, study.representatives.P4, outDir);
end

function plot_patch_pareto(problem, reps, outDir)
figure('Color', 'w', 'Position', [100 100 760 560]);
ref = problem.dataset.records(:, {'AbsS11_f0_Linear', 'Gain_f0_dBi'});
refObj = [ref.AbsS11_f0_Linear, -ref.Gain_f0_dBi];
nd = non_dominated_mask(refObj);
scatter(ref.AbsS11_f0_Linear(nd), ref.Gain_f0_dBi(nd), 26, [0.6 0.6 0.6], 'filled');
hold on;
if ~isempty(reps)
    scatter(reps.AbsS11_f0_Linear, reps.Gain_f0_dBi, 48, 'r', 'filled');
end
xlabel('|S_{11}(f_0)| (linear)');
ylabel('Gain(f_0) [dBi]');
title('Patch Antenna 2D Pareto Front');
legend('Empirical PF', 'HFSS-BHO representatives', 'Location', 'best');
grid on;
box on;
saveas(gcf, fullfile(outDir, 'Figure_P2_Patch_Pareto.png'));
close(gcf);
end

function plot_vivaldi_pareto(problem, reps, outDir)
figure('Color', 'w', 'Position', [100 100 760 560]);
ref = problem.dataset.records(:, {'MeanAbsS11_Linear', 'PeakGainProxy_dBi', 'BW_GHz'});
refObj = [ref.MeanAbsS11_Linear, -ref.PeakGainProxy_dBi, -ref.BW_GHz];
nd = non_dominated_mask(refObj);
scatter3(ref.MeanAbsS11_Linear(nd), ref.PeakGainProxy_dBi(nd), ref.BW_GHz(nd), 24, [0.6 0.6 0.6], 'filled');
hold on;
if ~isempty(reps)
    scatter3(reps.MeanAbsS11_Linear, reps.PeakGainProxy_dBi, reps.BW_GHz, 54, 'r', 'filled');
end
xlabel('mean(|S_{11}|)');
ylabel('Gain proxy [dBi]');
zlabel('BW [GHz]');
title('Vivaldi Antenna 3D Pareto Front');
grid on;
box on;
saveas(gcf, fullfile(outDir, 'Figure_P3_Vivaldi_Pareto.png'));
close(gcf);
end

function plot_yagi_parallel(problem, reps, outDir)
figure('Color', 'w', 'Position', [100 100 860 520]);
if isempty(reps)
    close(gcf);
    return;
end

data = [reps.Gmain_dBi, reps.SLL_dB, reps.HPBW_deg, reps.AbsS11_f0_Linear];
labels = {'Gmain', 'SLL', 'HPBW', '|S11|'};

if exist('parallelcoords', 'file') == 2
    parallelcoords(data, 'Labels', labels, 'Color', [0.2 0.45 0.8]);
else
    dataMin = min(data, [], 1);
    dataSpan = max(data, [], 1) - dataMin;
    dataSpan(dataSpan <= 1e-12) = 1;
    dataNorm = (data - dataMin) ./ dataSpan;
    plot(dataNorm.', 'LineWidth', 1.2);
    xticks(1:numel(labels));
    xticklabels(labels);
    ylabel('Normalized value');
end

title('Yagi-Uda 4-objective projection / parallel coordinates');
grid on;
box on;
saveas(gcf, fullfile(outDir, 'Figure_P4_Yagi_Parallel.png'));
close(gcf);
end

