function problems = cec2020_mmo_selected_problems()
%CEC2020_MMO_SELECTED_PROBLEMS Selected CEC2020 MMO problems used in study.
% 中文说明：
% 这里集中定义论文实验中选用的 CEC2020 MMO 问题集合，
% 便于统一管理和后续批量实验。

tags = {'MMF1', 'MMF10', 'MMF11', 'MMF12', 'MMF14A_M3', 'MMF15A_M5'};
problems = repmat(cec2020_mmo_get_problem(tags{1}), 1, numel(tags));
for i = 1:numel(tags)
    problems(i) = cec2020_mmo_get_problem(tags{i});
end
end
