function result = BHO_singleobjective_hfss(problem, config)
% 中文说明：
% P1 Dipole 使用的单目标 BHO。
% 保留 BHO 的精英/探索双模式更新思想，并针对单目标场景做了简化。

rng(config.seed, 'twister');
popSize = config.popSize;
maxEval = config.maxEval;
lb = problem.lb;
ub = problem.ub;
dim = problem.dim;

X = lb + rand(popSize, dim) .* (ub - lb);
f = zeros(popSize, 1);
for i = 1:popSize
    f(i) = problem.evalFcn(X(i, :));
end
evalCount = popSize;

pBestX = X;
pBestF = f;
[gBestF, bestIdx] = min(f);
gBestX = X(bestIdx, :);
bestCurve = nan(maxEval, 1);
bestCurve(1:evalCount) = gBestF;

while evalCount < maxEval
    [~, order] = sort(f, 'ascend');
    eliteCount = max(1, ceil(0.30 * popSize));
    eliteMask = false(popSize, 1);
    eliteMask(order(1:eliteCount)) = true;
    eliteCenter = mean(X(order(1:eliteCount), :), 1);

    Xnew = X;
    fnew = f;
    for i = 1:popSize
        if evalCount >= maxEval
            break;
        end

        if eliteMask(i)
            step = 0.45 * rand(1, dim) .* (gBestX - X(i, :)) + ...
                0.25 * rand(1, dim) .* (eliteCenter - X(i, :)) + ...
                0.20 * randn(1, dim) .* (pBestX(i, :) - X(i, :));
        else
            peer = randperm(popSize, 2);
            diffStep = X(peer(1), :) - X(peer(2), :);
            stepScale = 0.65 * (1 - evalCount / maxEval) + 0.15;
            step = stepScale * randn(1, dim) .* diffStep + ...
                0.20 * rand(1, dim) .* (gBestX - X(i, :));
        end

        trial = X(i, :) + step;
        trial = trial + 0.05 * randn(1, dim) .* (ub - lb);
        trial = min(max(trial, lb), ub);
        fTrial = problem.evalFcn(trial);
        evalCount = evalCount + 1;

        temp = max(0.01, 1 - evalCount / maxEval);
        accept = fTrial < f(i) || rand < exp(-(fTrial - f(i)) / max(temp, 1e-6));
        if accept
            Xnew(i, :) = trial;
            fnew(i) = fTrial;
        end

        if fTrial < pBestF(i)
            pBestX(i, :) = trial;
            pBestF(i) = fTrial;
        end
        if pBestF(i) < gBestF
            gBestF = pBestF(i);
            gBestX = pBestX(i, :);
        end

        bestCurve(evalCount) = gBestF;
    end

    X = Xnew;
    f = fnew;
end

result = struct();
result.name = 'HFSS-BHO-SO';
result.bestDec = gBestX;
result.bestObj = gBestF;
result.bestCurve = bestCurve(1:evalCount);
result.decs = [X; pBestX; gBestX];
result.objs = [f; pBestF; gBestF];
result.fe = evalCount;
end

