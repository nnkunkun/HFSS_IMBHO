function dataset = load_dipole_dataset()
% 中文说明：
% P1: Dipole，单目标基线问题。
% 目标：最小化中心频率 f0=0.9 GHz 处的线性反射系数 |S11(f0)|.

workspaceRoot = fileparts(fileparts(mfilename('fullpath')));
resultsDir = fullfile(fileparts(workspaceRoot), 'Dipole results');
T = readtable(fullfile(resultsDir, 'all_simulations_combined.csv'));

simulationIds = string(T.SimulationID);
[groupId, idList] = findgroups(simulationIds);
freqGrid = unique(T.Freq_GHz);
[~, centerIdx] = min(abs(freqGrid - mean([min(freqGrid), max(freqGrid)])));
f0GHz = freqGrid(centerIdx);

n = numel(idList);
X = zeros(n, 3);
obj = zeros(n, 1);
s11dB = zeros(n, 1);

for i = 1:n
    sub = T(groupId == i, :);
    X(i, :) = [sub.dipole_length(1), sub.wire_rad(1), sub.port_gap(1)];
    [~, idx] = min(abs(sub.Freq_GHz - f0GHz));
    s11dB(i) = sub.S11_dB(idx);
    obj(i, 1) = 10^(s11dB(i) / 20);
end

records = table();
records.Problem = repmat("P1", n, 1);
records.Antenna = repmat("Dipole", n, 1);
records.SimulationID = idList;
records.dipole_length = X(:, 1);
records.wire_rad = X(:, 2);
records.port_gap = X(:, 3);
records.S11_f0_dB = s11dB;
records.AbsS11_f0_Linear = obj(:, 1);
records.S11_File = fullfile(resultsDir, strcat(idList, "_S11.csv"));
records.PrimaryCurveFile = records.S11_File;

dataset = finalize_dataset(records, X, obj, {'dipole_length', 'wire_rad', 'port_gap'}, ...
    {'AbsS11_f0_Linear'}, "P1", "Dipole", f0GHz, 's11');
dataset.problemTitle = 'P1: Dipole single-objective baseline';
dataset.objectiveDisplayNames = {'|S11(f0)|'};
end

