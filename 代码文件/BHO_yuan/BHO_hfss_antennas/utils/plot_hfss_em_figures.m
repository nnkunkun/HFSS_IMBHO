function plot_hfss_em_figures(study)
% 中文说明：
% 输出四个天线问题的电磁性能可视化图。

outDir = study.config.outputDir;
plot_dipole_s11(study.representatives.P1, outDir);
plot_patch_em(study.representatives.P2, outDir);
plot_vivaldi_em(study.representatives.P3, outDir);
plot_yagi_em(study.representatives.P4, outDir);
end

function plot_dipole_s11(reps, outDir)
if isempty(reps)
    return;
end
pick = reps(1:min(3, height(reps)), :);
figure('Color', 'w', 'Position', [100 100 760 520]);
hold on;
for i = 1:height(pick)
    [freqGHz, s11dB] = local_read_xy(pick.S11_File(i), {'Freq_GHz', 'Freq [GHz]'}, {'S11_dB', 'dB(St11) []', 'dB(St(Driver_T1,Driver_T1)) []'});
    plot(freqGHz, s11dB, 'LineWidth', 1.5, 'DisplayName', char(string(pick.SimulationID(i))));
end
yline(-10, '--k', 'LineWidth', 1);
xlabel('Frequency [GHz]');
ylabel('S_{11} [dB]');
title('Dipole S11 curves');
legend('Location', 'best');
grid on;
box on;
saveas(gcf, fullfile(outDir, 'Figure_P1_Dipole_S11.png'));
close(gcf);
end

function plot_patch_em(reps, outDir)
if isempty(reps)
    return;
end
pick = reps(1:min(3, height(reps)), :);
figure('Color', 'w', 'Position', [100 100 980 420]);
subplot(1, 2, 1);
hold on;
for i = 1:height(pick)
    [freqGHz, s11dB] = local_read_xy(pick.Combined_File(i), {'Freq_GHz', 'Freq [GHz]'}, {'S11_dB', 'dB(St11) []'});
    plot(freqGHz, s11dB, 'LineWidth', 1.4, 'DisplayName', char(string(pick.SelectionLabel(i))));
end
yline(-10, '--k');
xlabel('Frequency [GHz]');
ylabel('S_{11} [dB]');
title('Patch S11 curves');
grid on;
box on;
legend('Location', 'best');

subplot(1, 2, 2);
hold on;
for i = 1:height(pick)
    [freqGHz, gainDB] = local_read_xy(pick.Combined_File(i), {'Freq_GHz', 'Freq [GHz]'}, {'Gain_dB', 'Gain_dBi'});
    plot(freqGHz, gainDB, 'LineWidth', 1.4, 'DisplayName', char(string(pick.SelectionLabel(i))));
end
xlabel('Frequency [GHz]');
ylabel('Gain [dBi]');
title('Patch gain curves');
grid on;
box on;
legend('Location', 'best');
saveas(gcf, fullfile(outDir, 'Figure_P2_Patch_EM.png'));
close(gcf);
end

function plot_vivaldi_em(reps, outDir)
if isempty(reps)
    return;
end
pick = reps(1:min(3, height(reps)), :);

figure('Color', 'w', 'Position', [100 100 760 520]);
hold on;
for i = 1:height(pick)
    [freqGHz, s11dB] = local_read_xy(pick.S11_File(i), {'Freq_GHz', 'Freq [GHz]'}, {'S11_dB', 'dB(St11) []'});
    plot(freqGHz, s11dB, 'LineWidth', 1.4, 'DisplayName', char(string(pick.SelectionLabel(i))));
end
yline(-10, '--k');
xlabel('Frequency [GHz]');
ylabel('S_{11} [dB]');
title('Vivaldi S11 curves');
legend('Location', 'best');
grid on;
box on;
saveas(gcf, fullfile(outDir, 'Figure_P3_Vivaldi_S11.png'));
close(gcf);

figure('Color', 'w', 'Position', [100 100 760 520]);
hold on;
for i = 1:height(pick)
    [thetaDeg, gainDB] = local_read_xy(pick.Gain_File(i), {'Theta_deg', 'Theta [deg]'}, {'Gain_dB', 'dB(GainTotal) []'});
    plot(thetaDeg, gainDB, 'LineWidth', 1.4, 'DisplayName', char(string(pick.SelectionLabel(i))));
end
xlabel('Theta [deg]');
ylabel('Gain [dB]');
title('Vivaldi available gain-pattern proxy');
legend('Location', 'best');
grid on;
box on;
saveas(gcf, fullfile(outDir, 'Figure_P3_Vivaldi_GainPattern.png'));
close(gcf);
end

function plot_yagi_em(reps, outDir)
if isempty(reps)
    return;
end
pick = reps(1:min(2, height(reps)), :);
figure('Color', 'w', 'Position', [100 100 1000 420]);

subplot(1, 2, 1);
hold on;
for i = 1:height(pick)
    [freqGHz, s11dB] = local_read_xy(pick.S11_File(i), {'Freq_GHz', 'Freq [GHz]'}, {'S11_dB', 'dB(St11) []', 'dB(St(Driver_T1,Driver_T1)) []'});
    plot(freqGHz, s11dB, 'LineWidth', 1.3, 'DisplayName', char(string(pick.SelectionLabel(i))));
end
yline(-10, '--k');
xlabel('Frequency [GHz]');
ylabel('S_{11} [dB]');
title('Yagi S11 curves');
legend('Location', 'best');
grid on;
box on;

subplot(1, 2, 2);
hold on;
for i = 1:height(pick)
    [theta0, gain0] = local_read_xy(pick.GainPhi0_File(i), {'Theta_deg', 'Theta [deg]'}, {'Gain_dB', 'dB(GainTotal) [] - Freq=''2.25GHz'' Phi=''0deg'''});
    [theta90, gain90] = local_read_xy(pick.GainPhi90_File(i), {'Theta_deg', 'Theta [deg]'}, {'Gain_dB', 'dB(GainTotal) [] - Freq=''2.25GHz'' Phi=''90deg'''});
    plot(theta0, gain0, 'LineWidth', 1.2, 'DisplayName', sprintf('%s | Phi0', char(string(pick.SelectionLabel(i)))));
    plot(theta90, gain90, '--', 'LineWidth', 1.2, 'DisplayName', sprintf('%s | Phi90', char(string(pick.SelectionLabel(i)))));
end
xlabel('Theta [deg]');
ylabel('Gain [dBi]');
title('Yagi E-plane / H-plane patterns');
legend('Location', 'best');
grid on;
box on;
saveas(gcf, fullfile(outDir, 'Figure_P4_Yagi_EM.png'));
close(gcf);
end

function [x, y] = local_read_xy(fileValue, xCandidates, yCandidates)
% 中文说明：
% 兼容不同 HFSS 导出文件的列名差异，优先按候选列名匹配；
% 如果匹配不到，就退化为读取前两个数值列。
filePath = local_path_string(fileValue);
T = readtable(filePath, 'VariableNamingRule', 'preserve');
[x, xIdx] = local_pick_numeric_column(T, xCandidates, []);
[y, ~] = local_pick_numeric_column(T, yCandidates, xIdx);
end

function [column, idx] = local_pick_numeric_column(T, candidates, excludedIdx)
names = string(T.Properties.VariableNames);
normalizedNames = local_normalize_names(names);
idx = [];

for i = 1:numel(candidates)
    target = local_normalize_names(string(candidates{i}));
    hit = find(normalizedNames == target, 1);
    if ~isempty(hit) && isnumeric(T{:, hit}) && ~ismember(hit, excludedIdx)
        idx = hit;
        break;
    end
end

if isempty(idx)
    numericMask = false(1, width(T));
    for j = 1:width(T)
        numericMask(j) = isnumeric(T{:, j});
    end
    numericIdx = find(numericMask);
    numericIdx = setdiff(numericIdx, excludedIdx, 'stable');
    if isempty(numericIdx)
        error('No numeric columns found in %s.', strjoin(names, ', '));
    end
    idx = numericIdx(1);
end

column = T{:, idx};
column = column(:);
end

function normalized = local_normalize_names(names)
normalized = lower(regexprep(string(names), '[^a-zA-Z0-9]+', ''));
end

function pathStr = local_path_string(fileValue)
if iscell(fileValue)
    fileValue = fileValue{1};
end
pathStr = char(string(fileValue));
end
