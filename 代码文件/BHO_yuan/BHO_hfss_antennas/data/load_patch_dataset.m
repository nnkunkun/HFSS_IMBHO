function dataset = load_patch_dataset()
% 中文说明：
% P2: Patch Antenna，双目标标准工程 Pareto 问题。
% 目标：最小化中心频率 f0=12 GHz 处的 |S11|，同时最大化增益。
% 最小化形式：min [ |S11(f0)| , -G(f0) ].

workspaceRoot = fileparts(fileparts(mfilename('fullpath')));
resultsDir = fullfile(fileparts(workspaceRoot), 'Patch results');
T = readtable(fullfile(resultsDir, 'all_simulations_combined.csv'));

simulationIds = string(T.SimulationID);
[groupId, idList] = findgroups(simulationIds);
freqGrid = unique(T.Freq_GHz);
[~, centerIdx] = min(abs(freqGrid - mean([min(freqGrid), max(freqGrid)])));
f0GHz = freqGrid(centerIdx);

n = numel(idList);
X = zeros(n, 5);
obj = zeros(n, 2);
s11dB = zeros(n, 1);
gainDB = zeros(n, 1);

for i = 1:n
    sub = T(groupId == i, :);
    X(i, :) = [sub.patchX(1), sub.patchY(1), sub.subH(1), sub.feedX(1), sub.feedLength(1)];
    [~, idx] = min(abs(sub.Freq_GHz - f0GHz));
    s11dB(i) = sub.S11_dB(idx);
    gainDB(i) = sub.Gain_dB(idx);
    obj(i, 1) = 10^(s11dB(i) / 20);
    obj(i, 2) = -gainDB(i);
end

records = table();
records.Problem = repmat("P2", n, 1);
records.Antenna = repmat("Patch Antenna", n, 1);
records.SimulationID = idList;
records.patchX = X(:, 1);
records.patchY = X(:, 2);
records.subH = X(:, 3);
records.feedX = X(:, 4);
records.feedLength = X(:, 5);
records.S11_f0_dB = s11dB;
records.AbsS11_f0_Linear = obj(:, 1);
records.Gain_f0_dBi = gainDB;
records.Combined_File = fullfile(resultsDir, strcat(idList, "_combined_results.csv"));
records.S11_File = fullfile(resultsDir, strcat(idList, "_S11.csv"));
records.Gain_File = fullfile(resultsDir, strcat(idList, "_Gain.csv"));
records.PrimaryCurveFile = records.Combined_File;

dataset = finalize_dataset(records, X, obj, {'patchX', 'patchY', 'subH', 'feedX', 'feedLength'}, ...
    {'AbsS11_f0_Linear', 'Negative_Gain_f0'}, "P2", "Patch Antenna", f0GHz, 'pareto2d');
dataset.problemTitle = 'P2: Patch Antenna bi-objective engineering problem';
dataset.objectiveDisplayNames = {'|S11(f0)|', '-Gain(f0)'};
end
