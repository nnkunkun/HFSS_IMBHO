function ensure_cec2020_mmo_path(rootDir)
%ENSURE_CEC2020_MMO_PATH Put local CEC2020 MMO functions ahead of PlatEMO.
% 中文说明：
% PlatEMO 中也带有部分 MMF 同名问题类。
% 为避免 MATLAB 路径冲突，这里把本项目使用的 CEC2020 函数目录固定放到最前面。

persistent initializedRoot
target = fullfile(rootDir, 'cec2020_mmo', 'functions');

if isempty(initializedRoot) || ~strcmp(initializedRoot, target)
    addpath(target, '-begin');
    initializedRoot = target;
end
end
