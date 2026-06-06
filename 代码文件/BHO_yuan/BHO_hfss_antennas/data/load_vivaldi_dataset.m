function dataset = load_vivaldi_dataset()
% 中文说明：
% P3: Vivaldi Antenna，三目标宽带工程问题。
% 数据集中没有逐频增益曲线，因此这里使用可获得的峰值增益作为宽带增益代理项。
% 最小化形式：min [ mean(|S11|), -G_proxy, -BW ].

workspaceRoot = fileparts(fileparts(mfilename('fullpath')));
resultsDir = fullfile(fileparts(workspaceRoot), 'Vivaldi results');
Ts11 = readtable(fullfile(resultsDir, 'all_s11_data.csv'));
Tsum = readtable(fullfile(resultsDir, 'summary_metrics.csv'));

simulationIds = string(Tsum.SimulationID);
n = height(Tsum);
X = [Tsum.Wslot, Tsum.Wtaper, Tsum.Ltapper, Tsum.Wbalun, Tsum.Wstrip, Tsum.Lstrip_offset];
obj = zeros(n, 3);
meanS11Linear = zeros(n, 1);
gainProxyDB = Tsum.PeakGain_dB;
bwGHz = zeros(n, 1);

allIds = string(Ts11.SimulationID);
for i = 1:n
    sub = Ts11(allIds == simulationIds(i), :);
    meanS11Linear(i) = mean(10.^(sub.S11_dB / 20));
    bwGHz(i) = compute_s11_bandwidth(sub.Freq_GHz, sub.S11_dB, -10);
    obj(i, 1) = meanS11Linear(i);
    obj(i, 2) = -gainProxyDB(i);
    obj(i, 3) = -bwGHz(i);
end

records = table();
records.Problem = repmat("P3", n, 1);
records.Antenna = repmat("Vivaldi Antenna", n, 1);
records.SimulationID = simulationIds;
records.Wslot = X(:, 1);
records.Wtaper = X(:, 2);
records.Ltapper = X(:, 3);
records.Wbalun = X(:, 4);
records.Wstrip = X(:, 5);
records.Lstrip_offset = X(:, 6);
records.MeanAbsS11_Linear = meanS11Linear;
records.PeakGainProxy_dBi = gainProxyDB;
records.BW_GHz = bwGHz;
records.MinS11_dB = Tsum.MinS11_dB;
records.MinS11_Freq_GHz = Tsum.MinS11_Freq_GHz;
records.S11_File = fullfile(resultsDir, strcat(simulationIds, "_S11_clean.csv"));
records.Gain_File = fullfile(resultsDir, strcat(simulationIds, "_Gain_clean.csv"));
records.PrimaryCurveFile = records.S11_File;

dataset = finalize_dataset(records, X, obj, {'Wslot', 'Wtaper', 'Ltapper', 'Wbalun', 'Wstrip', 'Lstrip_offset'}, ...
    {'MeanAbsS11_Linear', 'Negative_PeakGainProxy', 'Negative_BW_GHz'}, "P3", "Vivaldi Antenna", nan, 'pareto3d');
dataset.problemTitle = 'P3: Vivaldi Antenna tri-objective broadband problem';
dataset.objectiveDisplayNames = {'mean(|S11|)', '-Gain proxy', '-BW'};
end
