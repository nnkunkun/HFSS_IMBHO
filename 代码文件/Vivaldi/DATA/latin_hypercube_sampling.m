function [samples] = latin_hypercube_sampling(param_ranges, n_samples)
    % 拉丁超立方采样
    % param_ranges: 每个参数的范围，cell数组，每个元素为[min, max]
    % n_samples: 采样数量
    
    n_params = length(param_ranges);
    samples = zeros(n_samples, n_params);
    
    % 为每个参数生成拉丁超立方采样
    for i = 1:n_params
        min_val = param_ranges{i}(1);
        max_val = param_ranges{i}(2);
        
        % 生成拉丁超立方采样
        edges = linspace(0, 1, n_samples + 1);
        strata = randperm(n_samples);
        samples(:, i) = min_val + (strata' - 1 + rand(n_samples, 1)) * ...
                       (max_val - min_val) / n_samples;
    end
end