cd('W:/Formal/BHO_yuan/BHO_cec2020/BHO - Evaluation Count Version');
addpath(genpath(resolve_platemo_root()));
problems = {'MMF12','MMF15A_M5'};
for ip = 1:numel(problems)
    p = cec2020_mmo_get_problem(problems{ip});
    cfg = struct('popSize',60,'maxEval',800,'seed',1);
    r = run_bho_on_problem(p,cfg);
    m = compute_mo_metrics(r.decs,r.objs,p.refPF);
    fprintf('%s IMBHO HV=%.4f IGD=%.4f NDS=%d\n', p.tag, m.HV, m.IGD, m.NDS);
end
