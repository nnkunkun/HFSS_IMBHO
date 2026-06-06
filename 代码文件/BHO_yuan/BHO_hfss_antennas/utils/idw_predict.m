function y = idw_predict(x, model)
% 中文说明：
% 使用逆距离加权（IDW）在已有 HFSS 样本上构造平滑代理评价。
% 这样无需重新调用 HFSS，也能在连续空间中运行优化算法。

if isvector(x)
    x = reshape(x, 1, []);
end

span = max(model.ub - model.lb, eps);
xn = (x - model.lb) ./ span;
Xn = (model.X - model.lb) ./ span;

y = zeros(size(x, 1), size(model.Y, 2));
for i = 1:size(xn, 1)
    dist = sqrt(sum((Xn - xn(i, :)) .^ 2, 2));
    [dist, order] = sort(dist, 'ascend');
    if dist(1) <= 1e-12
        y(i, :) = model.Y(order(1), :);
        continue;
    end

    k = min(model.k, numel(order));
    dist = dist(1:k);
    idx = order(1:k);
    w = 1 ./ (dist .^ model.power + 1e-12);
    w = w / sum(w);
    y(i, :) = w.' * model.Y(idx, :);
end
end

