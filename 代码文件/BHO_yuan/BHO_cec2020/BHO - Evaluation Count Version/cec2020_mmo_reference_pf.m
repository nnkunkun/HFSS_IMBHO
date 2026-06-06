function refPF = cec2020_mmo_reference_pf(problem)
%CEC2020_MMO_REFERENCE_PF Load or synthesize the PF reference set.
% 中文说明：
% 优先从官方提供的参考 PF 文件中读取真实前沿。
% 若某个可扩展问题没有给定文件，则按其理论前沿形状合成参考点集。

if isfield(problem, 'refPFFile') && ~isempty(problem.refPFFile) && exist(problem.refPFFile, 'file') == 2
    S = load(problem.refPFFile);
    if isfield(S, 'PF')
        refPF = S.PF;
        return;
    end
end

nSamples = 4000;
refPF = generate_positive_sphere(nSamples, problem.nObj, problem.pfRadius);
end

function PF = generate_positive_sphere(nSamples, nObj, radius)
state = rng;
cleanup = onCleanup(@() rng(state));
rng(2020 + 31 * nObj, 'twister');
X = rand(nSamples, nObj);
X = X ./ sqrt(sum(X.^2, 2));
PF = radius .* X;
end
