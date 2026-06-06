function problems = hfss_problem_catalog()
% 中文说明：
% 返回四个 HFSS 天线工程问题的统一列表。

tags = {'P1', 'P2', 'P3', 'P4'};
problems = repmat(hfss_get_problem(tags{1}), 1, numel(tags));
for i = 1:numel(tags)
    problems(i) = hfss_get_problem(tags{i});
end
end

