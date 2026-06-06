function generate_export_script(params, export_types, sim_id, config, script_filename)
    % 生成HFSS控制脚本文件
    
    fid = fopen(script_filename, 'w');
    if fid == -1
        error('无法创建脚本文件: %s', script_filename);
    end
    
    try
        % VBScript头部 - 添加更多调试信息
        fprintf(fid, 'Option Explicit\n');
        fprintf(fid, 'On Error Resume Next\n\n');
        
        fprintf(fid, 'WScript.Echo "开始执行HFSS脚本..."\n');
        fprintf(fid, 'WScript.Echo "当前时间: " & Now()\n\n');
        
        fprintf(fid, 'Dim oHfssApp\n');
        fprintf(fid, 'Dim oDesktop\n');
        fprintf(fid, 'Dim oProject\n');
        fprintf(fid, 'Dim oDesign\n');
        fprintf(fid, 'Dim oModule\n\n');
        
        % 尝试创建HFSS对象
        fprintf(fid, 'WScript.Echo "创建HFSS对象..."\n');
        fprintf(fid, 'Set oHfssApp = CreateObject("AnsoftHfss.HfssScriptInterface")\n');
        fprintf(fid, 'If Err.Number <> 0 Then\n');
        fprintf(fid, '    WScript.Echo "错误: 无法创建HFSS对象, 错误号: " & Err.Number & ", 描述: " & Err.Description\n');
        fprintf(fid, '    WScript.Quit 1\n');
        fprintf(fid, 'End If\n');
        fprintf(fid, 'WScript.Echo "HFSS对象创建成功"\n\n');
        
        fprintf(fid, 'Set oDesktop = oHfssApp.GetAppDesktop()\n');
        fprintf(fid, 'oDesktop.RestoreWindow\n');
        fprintf(fid, 'oDesktop.CloseAllWindows\n\n');
        
        % 打开项目
        fprintf(fid, 'WScript.Echo "打开项目: %s"\n', config.hfss_project);
        fprintf(fid, 'Set oProject = oDesktop.OpenProject("%s")\n', config.hfss_project);
        fprintf(fid, 'If Err.Number <> 0 Then\n');
        fprintf(fid, '    WScript.Echo "错误: 无法打开项目, 错误号: " & Err.Number & ", 描述: " & Err.Description\n');
        fprintf(fid, '    WScript.Quit 1\n');
        fprintf(fid, 'End If\n');
        fprintf(fid, 'WScript.Echo "项目打开成功"\n\n');
        
        % ... 其余代码保持不变 ...
        
        fclose(fid);
        fprintf('已生成HFSS控制脚本: %s\n', script_filename);
        
    catch ME
        fclose(fid);
        rethrow(ME);
    end
end