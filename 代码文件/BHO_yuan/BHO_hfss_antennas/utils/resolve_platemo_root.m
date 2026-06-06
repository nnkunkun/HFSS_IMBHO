function platemoRoot = resolve_platemo_root()
%RESOLVE_PLATEMO_ROOT Locate the local PlatEMO installation used in study.
% 中文说明：
% 自动定位当前工作区中下载的 PlatEMO 目录，
% 避免实验脚本里写死绝对路径。

baseDir = fileparts(mfilename('fullpath'));
candidate = fullfile(baseDir, '..', '..', 'external', 'PlatEMO-master', 'PlatEMO');
candidate = char(java.io.File(candidate).getCanonicalPath());

if exist(candidate, 'dir') ~= 7
    error('PlatEMO was not found at: %s', candidate);
end

platemoRoot = candidate;
end
