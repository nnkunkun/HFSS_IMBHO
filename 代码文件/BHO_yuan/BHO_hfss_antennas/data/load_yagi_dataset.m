function dataset = load_yagi_dataset()
% 中文说明：
% P4: Yagi-Uda，四目标 many-objective 工程问题。
% 数据集中原始 HPBW 列为空，因此根据主平面方向图自动补算。
% 最小化形式：min [ -Gmain , SLL , HPBW , |S11(f0)| ].

workspaceRoot = fileparts(fileparts(mfilename('fullpath')));
resultsDir = fullfile(fileparts(workspaceRoot), 'Yagi results');
T = readtable(fullfile(resultsDir, 'successful_simulations.csv'));

n = height(T);
X = [T.Ldir, T.Ldri, T.L1, T.Sdir, T.Sref, T.Wdri];
obj = zeros(n, 4);
hpbwDeg = nan(n, 1);

for i = 1:n
    patternFile = fullfile(resultsDir, sprintf('%s_patterns.csv', T.SimulationID{i}));
    patternTable = readtable(patternFile);
    mainPlane = string(T.MainPlane{i});
    cut = patternTable(strcmpi(string(patternTable.CutName), mainPlane), :);
    hpbwDeg(i) = compute_hpbw_from_mainlobe(cut.Theta_deg, cut.Gain_dBi);

    obj(i, 1) = -T.Gmain_dBi(i);
    obj(i, 2) = T.SLL_dB(i);
    obj(i, 3) = hpbwDeg(i);
    obj(i, 4) = T.AbsS11_f0_Linear(i);
end

records = table();
records.Problem = repmat("P4", n, 1);
records.Antenna = repmat("Yagi-Uda", n, 1);
records.SimulationID = string(T.SimulationID);
records.Ldir = X(:, 1);
records.Ldri = X(:, 2);
records.L1 = X(:, 3);
records.Sdir = X(:, 4);
records.Sref = X(:, 5);
records.Wdri = X(:, 6);
records.Gmain_dBi = T.Gmain_dBi;
records.SLL_dB = T.SLL_dB;
records.HPBW_deg = hpbwDeg;
records.S11_f0_dB = T.S11_f0_dB;
records.AbsS11_f0_Linear = T.AbsS11_f0_Linear;
records.MainPlane = string(T.MainPlane);
records.Patterns_File = fullfile(resultsDir, strcat(string(T.SimulationID), "_patterns.csv"));
records.S11_File = fullfile(resultsDir, strcat(string(T.SimulationID), "_S11.csv"));
records.GainPhi0_File = fullfile(resultsDir, strcat(string(T.SimulationID), "_GainPhi0.csv"));
records.GainPhi90_File = fullfile(resultsDir, strcat(string(T.SimulationID), "_GainPhi90.csv"));
records.PrimaryCurveFile = records.Patterns_File;

dataset = finalize_dataset(records, X, obj, {'Ldir', 'Ldri', 'L1', 'Sdir', 'Sref', 'Wdri'}, ...
    {'Negative_Gmain', 'SLL_dB', 'HPBW_deg', 'AbsS11_f0_Linear'}, "P4", "Yagi-Uda", 2.25, 'parallel');
dataset.problemTitle = 'P4: Yagi-Uda four-objective many-objective problem';
dataset.objectiveDisplayNames = {'-Gmain', 'SLL', 'HPBW', '|S11(f0)|'};
end

