function visualize_lhs_sampling(param_combinations, parameters_to_sweep)
    % 可视化拉丁超立方采样结果
    
    num_params = size(parameters_to_sweep, 1);
    
    if num_params >= 2
        figure('Position', [100, 100, 800, 600]);
        
        % 绘制参数对之间的散点图
        for i = 1:num_params
            for j = i+1:num_params
                subplot(num_params-1, num_params-1, (i-1)*(num_params-1) + j-1);
                scatter(param_combinations(:, i), param_combinations(:, j), 20, 'filled');
                xlabel(parameters_to_sweep{i,1});
                ylabel(parameters_to_sweep{j,1});
                grid on;
            end
        end
        
        sgtitle('拉丁超立方采样参数分布');
        saveas(gcf, 'lhs_sampling_distribution.png');
    end
    
    % 绘制每个参数的直方图
    figure('Position', [100, 100, 1200, 400]);
    for i = 1:num_params
        subplot(1, num_params, i);
        histogram(param_combinations(:, i), 10);
        xlabel(parameters_to_sweep{i,1});
        ylabel('频数');
        title(sprintf('%s分布', parameters_to_sweep{i,1}));
        grid on;
    end
    sgtitle('参数值分布直方图');
    saveas(gcf, 'parameter_distributions.png');
end