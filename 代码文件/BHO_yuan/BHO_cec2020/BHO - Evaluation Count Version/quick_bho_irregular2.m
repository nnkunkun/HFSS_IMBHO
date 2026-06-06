cd('W:/Formal/BHO_yuan/BHO_cec2020/BHO - Evaluation Count Version');
addpath(genpath(resolve_platemo_root()));
problems = {'MMF10','MMF12'};
for ip = 1:numel(problems)
    p = cec2020_mmo_get_problem(problems{ip});
    fprintf('\nProblem %s\n', p.tag);
    for seed = 1:3
        cfg = struct('popSize',60,'maxEval',800,'seed',3000+seed);
        r = run_bho_on_problem(p,cfg);
        m = compute_mo_metrics(r.decs,r.objs,p.refPF,struct('hvSamples',20000));
        fprintf('seed %d HV=%.4f IGD=%.4f NDS=%d time=%.2f\n', seed, m.HV, m.IGD, m.NDS, r.runtime);
    end
end
