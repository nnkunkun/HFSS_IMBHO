cd('W:/Formal/BHO_yuan/BHO_cec2020/BHO - Evaluation Count Version');
addpath(genpath(resolve_platemo_root()));
problems = {'MMF1','MMF10','MMF11','MMF14A_M3'};
algs = {@NSGAII,@MOEAD,@NSGAIII,@RVEA};
for ip = 1:numel(problems)
    p = cec2020_mmo_get_problem(problems{ip});
    fprintf('\nProblem %s\n', p.tag);
    cfg = struct('popSize',60,'maxEval',800,'seed',1);
    r = run_bho_on_problem(p,cfg);
    m = compute_mo_metrics(r.decs,r.objs,p.refPF);
    fprintf('IMBHO HV=%.4f IGD=%.4f NDS=%d\n', m.HV, m.IGD, m.NDS);
    for ia = 1:numel(algs)
        rb = run_platemo_baseline(algs{ia}, p, cfg);
        mb = compute_mo_metrics(rb.decs,rb.objs,p.refPF);
        fprintf('%s HV=%.4f IGD=%.4f NDS=%d\n', func2str(algs{ia}), mb.HV, mb.IGD, mb.NDS);
    end
end
