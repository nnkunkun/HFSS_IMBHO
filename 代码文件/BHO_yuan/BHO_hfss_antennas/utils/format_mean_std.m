function txt = format_mean_std(values)
% 中文说明：
% 将多次重复结果格式化为 mean +/- std 字符串。

values = values(~isnan(values));
if isempty(values)
    txt = "N/A";
else
    txt = sprintf('%.4f +/- %.4f', mean(values), std(values));
end
end

