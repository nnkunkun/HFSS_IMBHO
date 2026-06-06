function run_hfss_simulation(hfss_exe_path, vbs_script_path)
    % 运行HFSS仿真
    
    % 移除路径中的引号
    hfss_exe_path = strrep(hfss_exe_path, '"', '');
    vbs_script_path = strrep(vbs_script_path, '"', '');
    
    % 检查文件是否存在
    if ~exist(hfss_exe_path, 'file')
        error('HFSS可执行文件不存在: %s', hfss_exe_path);
    end
    if ~exist(vbs_script_path, 'file')
        error('VBS脚本文件不存在: %s', vbs_script_path);
    end
    
    % 使用不同的命令格式尝试
    % 方法1: 直接使用系统命令
    command = sprintf('""%s" -RunScriptAndExit "%s""', hfss_exe_path, vbs_script_path);
    
    fprintf('执行HFSS命令...\n');
    fprintf('命令: %s\n', command);
    
    % 运行系统命令
    [status, cmdout] = system(command);
    
    % 如果方法1失败，尝试方法2：使用cd命令
    if status ~= 0
        fprintf('方法1失败，尝试方法2...\n');
        [hfss_dir, ~, ~] = fileparts(hfss_exe_path);
        command = sprintf('cd /d "%s" && "%s" -RunScriptAndExit "%s"', ...
                         hfss_dir, hfss_exe_path, vbs_script_path);
        [status, cmdout] = system(command);
    end
    
    % 如果方法2失败，尝试方法3：使用start命令
    if status ~= 0
        fprintf('方法2失败，尝试方法3...\n');
        command = sprintf('start "" /wait "%s" -RunScriptAndExit "%s"', ...
                         hfss_exe_path, vbs_script_path);
        [status, cmdout] = system(command);
    end
    
    if status ~= 0
        error('HFSS执行失败! 状态码: %d\n输出信息: %s\n请检查:\n1. HFSS是否正确安装\n2. 许可证是否有效\n3. 路径中是否有特殊字符', status, cmdout);
    end
    
    fprintf('HFSS执行完成\n');
    
    % 等待一段时间确保文件写入完成
    pause(10); % 增加等待时间
end