function F = cec2020_mmo_evaluate(X, problem)
%CEC2020_MMO_EVALUATE Evaluate a selected CEC2020 MMO problem.
% 中文说明：
% 该函数把不同 MMF 问题的 MATLAB 原始实现封装成统一批量评价接口。
% 输入可以是一行解，也可以是多行解；输出始终为 N×M 的目标值矩阵。

if isempty(X)
    F = zeros(0, problem.nObj);
    return;
end

if isvector(X)
    X = reshape(X, 1, []);
end

funcHandle = str2func(problem.functionName);

switch upper(problem.functionName)
    case {'MMF1', 'MMF10', 'MMF11', 'MMF12'}
        F = zeros(size(X, 1), problem.nObj);
        for i = 1:size(X, 1)
            yi = funcHandle(X(i, :));
            F(i, :) = yi(:).';
        end

    case {'MMF14_A', 'MMF15_A'}
        F = funcHandle(X, problem.nObj, problem.numPeaks);

    otherwise
        error('Unsupported CEC2020 MMO function: %s', problem.functionName);
end
end
