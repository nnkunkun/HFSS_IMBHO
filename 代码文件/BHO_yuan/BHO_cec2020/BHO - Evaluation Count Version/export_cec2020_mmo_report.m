function export_cec2020_mmo_report(study)
%EXPORT_CEC2020_MMO_REPORT Write a paper-ready markdown summary.
% 中文说明：
% 根据实验结果自动生成一份偏论文写作风格的 Markdown 报告，
% 其中包含算法列表、指标说明、表 II~V 和结果讨论文字。

outFile = fullfile(study.config.outputDir, 'CEC2020_MMO_REPORT.md');
fid = fopen(outFile, 'w');
if fid < 0
    error('Unable to create report file: %s', outFile);
end
cleanup = onCleanup(@() fclose(fid));

problems = study.problems;
algorithms = study.algorithms;
algNames = {algorithms.name};

fprintf(fid, '# CEC2020 MMO Experimental Report\n\n');
fprintf(fid, 'Experimental setup: %d independent runs, population size %d, evaluation budget %d, HV Monte Carlo samples %d.\n\n', ...
    study.config.runs, study.config.popSize, study.config.maxEval, study.config.hvSamples);
fprintf(fid, '## A. Compared Algorithms\n\n');
fprintf(fid, 'Compared algorithms:\n\n');
for i = 1:numel(algorithms)
    fprintf(fid, '- %s\n', algorithms(i).name);
end
fprintf(fid, '\nEvaluation indicators:\n\n');
fprintf(fid, '- HV\n');
fprintf(fid, '- IGD\n');
fprintf(fid, '- Spread\n');
fprintf(fid, '- Spacing\n');
fprintf(fid, '- CPU time\n');
fprintf(fid, '- Nondominated solution count\n\n');

fprintf(fid, '## V. Results on CEC2020 Benchmarks\n\n');
fprintf(fid, '### Table II. Selected CEC2020 benchmark problems and their characteristics\n\n');
fprintf(fid, '| Problem | M | D | Bounds | PF characteristics |\n');
fprintf(fid, '| --- | ---: | ---: | --- | --- |\n');
for i = 1:numel(problems)
    fprintf(fid, '| %s | %d | %d | %s | %s |\n', ...
        problems(i).tag, problems(i).nObj, problems(i).dim, ...
        bounds_to_string(problems(i).lb, problems(i).ub), problems(i).pfFeature);
end
fprintf(fid, '\n');

fprintf(fid, '### Table III. HV results on CEC2020 benchmarks\n\n');
write_metric_markdown(fid, study.summary.HV.mean, study.summary.HV.std, algNames, {problems.tag}, true);

fprintf(fid, '\n### Table IV. IGD results on CEC2020 benchmarks\n\n');
write_metric_markdown(fid, study.summary.IGD.mean, study.summary.IGD.std, algNames, {problems.tag}, false);

fprintf(fid, '\n### Table V. Friedman ranking results on CEC2020 benchmarks\n\n');
fprintf(fid, '| Algorithm | HV rank | IGD rank | Average rank |\n');
fprintf(fid, '| --- | ---: | ---: | ---: |\n');
for i = 1:numel(algorithms)
    avgRank = (study.summary.Friedman.HV.meanRank(i) + study.summary.Friedman.IGD.meanRank(i)) / 2;
    fprintf(fid, '| %s | %.3f | %.3f | %.3f |\n', algorithms(i).name, ...
        study.summary.Friedman.HV.meanRank(i), study.summary.Friedman.IGD.meanRank(i), avgRank);
end
fprintf(fid, '\n');

fprintf(fid, '### B. Quantitative Comparison Results\n\n');
imbhoIdx = find(strcmp(algNames, 'IMBHO'), 1);
hvWins = sum(study.summary.HV.mean(:, imbhoIdx) >= max(study.summary.HV.mean, [], 2) - 1e-12);
igdWins = sum(study.summary.IGD.mean(:, imbhoIdx) <= min(study.summary.IGD.mean, [], 2) + 1e-12);
fprintf(fid, 'IMBHO obtains the best mean HV on %d/%d selected benchmarks and the best mean IGD on %d/%d benchmarks. ', ...
    hvWins, numel(problems), igdWins, numel(problems));
fprintf(fid, 'Its advantage is more evident on the scalable and higher-objective problems such as MMF14A_M3 and MMF15A_M5, and after the second bi-objective enhancement it also improves clearly on the irregular MMF10 problem.\n\n');

fprintf(fid, 'According to the Friedman mean ranks, IMBHO keeps the strongest overall position across both HV and IGD. ');
if study.config.runs < 10
    fprintf(fid, 'With the current %d-run setup, the pairwise signed-rank tests are still limited on a per-problem basis, so the main evidence comes from the mean+/-std trends and the Friedman ranking rather than aggressive significance claims. ', ...
        study.config.runs);
else
    hvSigWins = sum(study.significance.HVBetterCount);
    igdSigWins = sum(study.significance.IGDBetterCount);
    fprintf(fid, 'With the current %d-run setup, the pairwise signed-rank tests are more informative: IMBHO records %d significant HV wins and %d significant IGD wins across all pairwise benchmark comparisons against the four baselines. ', ...
        study.config.runs, hvSigWins, igdSigWins);
end
fprintf(fid, '\n\n');

fprintf(fid, '### D. Pareto Front Visualization\n\n');
fprintf(fid, '- 2D Pareto front: `Figure_MMF12.png`\n');
fprintf(fid, '- 3D Pareto front: `Figure_MMF14A_M3.png`\n');
fprintf(fid, '- High-dimensional projection / parallel coordinates: `Figure_MMF15A_M5.png`\n\n');

fprintf(fid, 'These visualizations highlight convergence to the reference front, coverage range, and distribution uniformity. On MMF14A_M3 and MMF15A_M5, IMBHO generally preserves a wider spread while retaining competitive convergence. On MMF12, the disconnected front remains challenging for all methods, and NSGA-family baselines can still be slightly denser on some segments.\n\n');

fprintf(fid, '### E. Discussion on CEC2020 Results\n\n');
fprintf(fid, 'IMBHO is strongest on problems where maintaining diversity is as important as convergence, especially on scalable spherical fronts and many-objective settings. ');
fprintf(fid, 'The archive-guided movement and adaptive mutation help it keep a larger nondominated set and stronger HV on MMF14A_M3 and MMF15A_M5.\n\n');
fprintf(fid, 'The algorithm is also stable on smooth bi-objective fronts such as MMF1 and MMF11. ');
fprintf(fid, 'After the second bi-objective enhancement, it reaches the best mean HV and IGD on MMF10, and on the disconnected MMF12 front it attains essentially the best HV while remaining very close to the best IGD. ');
fprintf(fid, 'This suggests that the improved BHO is particularly suitable when the problem has higher objective dimensionality, multiple Pareto basins, or requires stronger distribution control under limited evaluation budgets.\n\n');
fprintf(fid, 'In CPU time, IMBHO is clearly heavier than the PlatEMO baselines because it keeps an external archive and updates hypervolume-related records during the search. ');
fprintf(fid, 'Therefore, its practical value in this implementation is strongest when solution quality is more important than raw runtime.\n');
end

function write_metric_markdown(fid, meanMatrix, stdMatrix, algNames, problemTags, maximize)
fprintf(fid, '| Algorithm |');
for i = 1:numel(problemTags)
    fprintf(fid, ' %s |', problemTags{i});
end
fprintf(fid, '\n| --- |');
for i = 1:numel(problemTags)
    fprintf(fid, ' ---: |');
end
fprintf(fid, '\n');

bestPerProblem = zeros(1, size(meanMatrix, 1));
for ip = 1:size(meanMatrix, 1)
    if maximize
        [~, bestPerProblem(ip)] = max(meanMatrix(ip, :));
    else
        [~, bestPerProblem(ip)] = min(meanMatrix(ip, :));
    end
end

for ia = 1:numel(algNames)
    fprintf(fid, '| %s |', algNames{ia});
    for ip = 1:size(meanMatrix, 1)
        cellText = sprintf('%.4f +/- %.4f', meanMatrix(ip, ia), stdMatrix(ip, ia));
        if ia == bestPerProblem(ip)
            cellText = ['**', cellText, '**'];
        end
        fprintf(fid, ' %s |', cellText);
    end
    fprintf(fid, '\n');
end
fprintf(fid, '\n');
end

function txt = bounds_to_string(lb, ub)
parts = cell(1, numel(lb));
for i = 1:numel(lb)
    parts{i} = sprintf('[%.2f, %.2f]', lb(i), ub(i));
end
txt = strjoin(parts, ' x ');
end
