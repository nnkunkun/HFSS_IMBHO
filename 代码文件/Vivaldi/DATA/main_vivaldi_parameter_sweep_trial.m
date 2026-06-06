function main_vivaldi_parameter_sweep_trial(varargin)
    trial_samples = 8;
    if nargin >= 1 && ~isempty(varargin{1})
        trial_samples = varargin{1};
    end

    validateattributes(trial_samples, {'numeric'}, {'scalar', 'integer', '>=', 5, '<=', 10});
    main_vivaldi_parameter_sweep(trial_samples, 'trial');
end
