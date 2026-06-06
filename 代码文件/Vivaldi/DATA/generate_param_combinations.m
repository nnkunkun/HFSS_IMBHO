function combinations = generate_param_combinations(parameters_to_sweep, n_samples)
    % 生成参数组合 - 使用拉丁超立方采样
    % parameters_to_sweep: 参数配置 [参数名, 起始值, 结束值]
    % n_samples: 采样数量（可选，默认为自动计算）
    
    num_params = size(parameters_to_sweep, 1);
    
    if num_params == 0
        combinations = [];
        return;
    end
    
    % 如果没有指定采样数量，根据参数数量自动计算
    if nargin < 2 || isempty(n_samples)
        % 默认每个参数采样10次，但不超过1000次
        n_samples = min(10^num_params, 1000);
    end
    
    % 为每个参数生成数值范围 [min, max]
    param_ranges = cell(1, num_params);
    for i = 1:num_params
        start_val = parameters_to_sweep{i, 2};
        end_val = parameters_to_sweep{i, 3};
        param_ranges{i} = [start_val, end_val];
    end
    
    % 使用拉丁超立方采样生成参数组合
    combinations = latin_hypercube_sampling(param_ranges, n_samples);
    
    fprintf('使用拉丁超立方采样生成了 %d 种参数组合\n', size(combinations, 1));
end