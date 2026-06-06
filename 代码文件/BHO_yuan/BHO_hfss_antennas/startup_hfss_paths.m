function startup_hfss_paths()
% 中文说明：
% 为 HFSS 天线版 BHO 工程添加所需路径。
% 该版本与 CEC2020 版本完全独立，便于单独管理工程问题实验。

rootDir = fileparts(mfilename('fullpath'));
addpath(rootDir);
addpath(fullfile(rootDir, 'algorithms'));
addpath(fullfile(rootDir, 'problems'));
addpath(fullfile(rootDir, 'data'));
addpath(fullfile(rootDir, 'utils'));
addpath(genpath(resolve_platemo_root()));
end

