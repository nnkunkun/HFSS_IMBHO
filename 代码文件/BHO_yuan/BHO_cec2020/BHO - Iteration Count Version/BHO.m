function [bestFitness, bestPosition, convergence] = BHO(popSize, maxIter, lb, ub, dim, fhd, funcId)

%% ---------- Standardize bounds ----------
if numel(lb) < dim
    lb = ones(1, dim) .* lb;
    ub = ones(1, dim) .* ub;
end

%% ---------- Algorithm hyper-parameters (kept from original) ----------
nGroups          = 4;
eliteRatioSwitch = 0.3;             
cCoeff           = repmat([0.5 0.5 0.5], popSize, 1);
cCoeffRange      = [0.2 0.8 0.2 0.8]; 
nTransfer        = 5;               
rho              = 0.25;            
totalElitePool   = popSize * 10;     

% --- Explorpolis radius (τ)
TAU = 0.30 * sqrt(dim);           


%% ---------- Initialization ----------
iter = 1;
randX = rand(popSize*10, dim);
[~, randCenter] = kmeans(randX, popSize);
X = lb + (ub - lb) .* randCenter;           % population positions
Xnet = build_guided_centers(popSize, X, maxIter, lb, ub, dim, fhd, funcId);

groupIdx = kmeans(X, nGroups);
F = zeros(popSize, 1);
for i = 1:popSize
    F(i) = fhd(X(i,:)', funcId);
end

tab = zeros(popSize, 9);
tab(:,1) = (1:popSize)';       
tab(:,2) = F;                    % fitness

% rank by current fitness
[~, ord] = sort(F, 'ascend');
rankPos = zeros(popSize,1); rankPos(ord) = 1:popSize;
tab(:,3) = rankPos / popSize;    % rank fraction
tab(:,4) = groupIdx;
tab(tab(:,3) <= eliteRatioSwitch, 5) = 1;   % 1=elite, 2=explorer
tab(tab(:,3)  > eliteRatioSwitch, 5) = 2;
%tab(:,6) = 1 - iter/maxIter/2 .* tab(:,3);  % individual scale
Fi_sum = max(sum(F), eps);
tab(:,6) = 1 - (iter/(2*maxIter)) * (F/Fi_sum);  

tab(tab(:,3) > 0.8, 9) = 1;                 % transfer counter seed

% value shaping for groups
F_eps = F + 1e-200;
manValue = max(F_eps) - F_eps;

groupValue = zeros(nGroups,1);
for g = 1:nGroups
    groupValue(g) = (1-rho)*groupValue(g) + sum(manValue(tab(:,4) == g));
end

% personal / group / global bests
pBestX = X;
pBestF = F;

gBestX = zeros(nGroups, dim);
gBestF = inf(nGroups,1);
for g = 1:nGroups
    rows = (tab(:,4) == g);
    [gBestF(g), idx] = min(F(rows));
    gBestX(g,:) = X(find(rows,1,'first') - 1 + idx, :); % locate absolute index
end

[globBestF, idx] = min(F);
globBestX = X(idx,:);

% archives & records
convergence = zeros(maxIter,1);
convergence(iter) = globBestF;

deltaX = zeros(size(X));
archiveX = X;       
archiveF = F;

% "quantum" helper (kept original logic)
quantum = ones(nGroups,2) * 1/sqrt(2);
quantum(:,3:4) = 0;

%% ---------- Main loop ----------
while iter < maxIter
    iter = iter + 1;
    oldX = X;
    oldF = F;

    % back-off container: [id, tryFit, tryX...]
    backList = ones(5*popSize, dim+2) * 1e9;
    backPtr  = 0;

    for i = 1:popSize
        if tab(i,5) == 1
            % -------- ELITE update (greedy attractors) --------
            r = rand(1, dim);

            trial = X(i,:) + deltaX(i,:) + tab(i,6) .* ( ...
                cCoeff(i,1)*r.*(globBestX - X(i,:)) + ...
                cCoeff(i,2)*r.*(gBestX(tab(i,4),:) - X(i,:)) + ...
                cCoeff(i,3)*r.*(pBestX(i,:) - X(i,:)) );

            trial = min(max(trial, lb), ub);
            fTrial = fhd(trial', funcId);

            if fTrial < F(i)
                F(i) = fTrial; X(i,:) = trial;
            else
                % ---------- Explorpolis(τ) ----------
                if explorpolis_accept(trial, fTrial, archiveX, archiveF, lb, ub, TAU,dim)
                    F(i) = fTrial; X(i,:) = trial;
                else
                    backPtr = backPtr + 1;
                    backList(backPtr,:) = [i, fTrial, trial];
                end
            end

        else
            % -------- EXPLORER update (differential-like + expansion/contraction) --------
            improved = false;

            j = randperm(popSize,1);
            if oldF(j) > F(i)
                trial = X(i,:) + (2 - iter/maxIter*2) .* rand .* (oldX(i,:) - oldX(j,:));
            else
                trial = X(i,:) + (2 - iter/maxIter*2) .* rand .* (oldX(j,:) - oldX(i,:));
            end
            trial = min(max(trial, lb), ub);
            fTrial = fhd(trial', funcId);
            if fTrial < F(i)
                F(i) = fTrial; X(i,:) = trial; improved = true;
            else
                % ---------- Explorpolis(τ) ----------
                if explorpolis_accept(trial, fTrial, archiveX, archiveF, lb, ub, TAU,dim)
                    F(i) = fTrial; X(i,:) = trial; improved = true;
                else
                    backPtr = backPtr + 1;
                    backList(backPtr,:) = [i, fTrial, trial];
                end
            end

            if rand > 0.5
                trial = X(i,:) + (2 - iter/maxIter*2)*tab(i,6).*rand(1,dim).*X(i,:);
            else
                trial = X(i,:) - (2 - iter/maxIter*2)*tab(i,6).*rand(1,dim).*X(i,:);
            end
            trial = min(max(trial, lb), ub);
            fTrial = fhd(trial', funcId);
            if fTrial < F(i)
                F(i) = fTrial; X(i,:) = trial; improved = true;
            else
                % ---------- Explorpolis(τ) ----------
                if explorpolis_accept(trial, fTrial, archiveX, archiveF, lb, ub, TAU,dim)
                    F(i) = fTrial; X(i,:) = trial; improved = true;
                else
                    backPtr = backPtr + 1;
                    backList(backPtr,:) = [i, fTrial, trial];
                end
            end

            if ~improved
                % hybrid trial vs elite-combo trial (kept original structure)
                if tab(i,3) < popSize/2
                    mid = 1 + rand(1,dim).*log((globBestF-oldF(i)) / (globBestF - max(oldF) + 1e-30));
                else
                    mid = 1 - rand(1,dim).*log((globBestF-oldF(i)) / (globBestF - max(oldF) + 1e-30));
                end

                if rand < 0.05
                    idxs = 1:popSize; idxs(idxs==i) = [];
                    idxs = idxs(randperm(popSize-1, 3));
                    trial1 = oldX(idxs(1),:) + (0.5 + 0.5*rand) * (oldX(idxs(2),:) - oldX(idxs(3),:));
                else
                    mil  = tanh(abs(globBestF - oldF(i)));
                    lim1 = unifrnd(-atanh(-(iter/maxIter)+1),  atanh(-(iter/maxIter)+1), 1, dim);
                    lim2 = unifrnd(-(1-iter/maxIter), 1-iter/maxIter, 1, dim);
                    trial1 = zeros(1,dim);
                    for d = 1:dim
                        if rand < mil
                            trial1(d) = globBestX(d) + lim1(d) * (mid(d)*globBestX(d) - oldX(randperm(popSize,1), d));
                        else
                            trial1(d) = lim2(d) * oldX(i,d);
                        end
                    end
                end
                trial1 = min(max(trial1, lb), ub);
                f1 = fhd(trial1', funcId);

                r = rand(1, dim);
                trial2 = X(i,:) + deltaX(i,:) + tab(i,6) .* ( ...
                    cCoeff(i,1)*r.*(globBestX - X(i,:)) + ...
                    cCoeff(i,2)*r.*(gBestX(tab(i,4),:) - X(i,:)) + ...
                    cCoeff(i,3)*r.*(pBestX(i,:) - X(i,:)) );
                trial2 = min(max(trial2, lb), ub);
                f2 = fhd(trial2', funcId);

                if f1 < f2
                    if f1 < F(i)
                        X(i,:) = trial1; F(i) = f1;
                        if backPtr > 0, backList(backList(:,1)==i,:) = []; end
                    else
                        % ---------- Explorpolis(τ) ----------
                        if explorpolis_accept(trial1, f1, archiveX, archiveF, lb, ub, TAU,dim)
                            X(i,:) = trial1; F(i) = f1;
                            if backPtr > 0, backList(backList(:,1)==i,:) = []; end
                        else
                            backPtr = backPtr + 1;
                            backList(backPtr,:) = [i, f1, trial1];
                        end
                    end
                else
                    if f2 < F(i)
                        X(i,:) = trial2; F(i) = f2;
                        if backPtr > 0, backList(backList(:,1)==i,:) = []; end
                    else
                        % ---------- Explorpolis(τ) ----------
                        if explorpolis_accept(trial2, f2, archiveX, archiveF, lb, ub, TAU,dim)
                            X(i,:) = trial2; F(i) = f2;
                            if backPtr > 0, backList(backList(:,1)==i,:) = []; end
                        else
                            backPtr = backPtr + 1;
                            backList(backPtr,:) = [i, f2, trial2];
                        end
                    end
                end
            end
        end
    end

    % back-off attempts
    backList(backList(:,1) == 1e9, :) = [];
    if ~isempty(backList)
        [X, F] = backoff_try(backList, X, F, Xnet, iter, ub, lb, maxIter, fhd, funcId);
    end

    % updates
    deltaX = X - oldX;

    % update archives (top totalElitePool) 
    tempX = [archiveX; X];
    tempF = [archiveF; F];
    tmp = [tempX, tempF];
    tmp = sortrows(tmp, size(tmp,2));
    k = min(size(tmp,1), totalElitePool);
    archiveX = tmp(1:k, 1:end-1);
    archiveF = tmp(1:k, end);

    % refresh bests
    [gBestX, gBestF, globBestX, globBestF, pBestF, pBestX] = ...
        refresh_bests(X, F, iter, gBestX, gBestF, tab, globBestX, globBestF, pBestF, pBestX, nGroups);

    convergence(iter) = globBestF;

    % update group values
    F_eps = F + 1e-200;
    manValue = max(F_eps) - F_eps;
    groupValue = (1-rho)*groupValue;
    for g = 1:nGroups
        groupValue(g) = groupValue(g) + sum(manValue(tab(:,4)==g));
    end

    % refresh table ranks & roles
    tab(:,7) = F;
    [~, ord] = sort(tab(:,7)); tab(ord,8) = (1:popSize).';
    tab = sortrows(tab,1);
    tab(:,8) = tab(:,8)/popSize;

    roleDelta = [0 0];
    for i = 1:popSize
        if tab(i,7) < tab(i,2)
            roleDelta(tab(i,5)) = roleDelta(tab(i,5)) + 1;
        else
            roleDelta(tab(i,5)) = roleDelta(tab(i,5)) - 1;
        end
    end
    roleDelta = roleDelta / popSize / maxIter;
    eliteRatioSwitch = eliteRatioSwitch + roleDelta(1) - roleDelta(2);

    % keep columns: [id newFit newRankFrac group role scale oldFit oldRankFrac transferCnt]
    tab = tab(:, [1 7 8 4 5 6 2 3 9]);
    tab(tab(:,3) <= eliteRatioSwitch, 5) = 1;
    tab(tab(:,3)  > eliteRatioSwitch, 5) = 2;
   % tab(:,6) = 1 - iter/maxIter/2 .* tab(:,3);
   Fi_sum = max(sum(F), eps);
   tab(:,6) = 1 - (iter/(2*maxIter)) * (F/Fi_sum);  

    tab(tab(:,3) > 0.8, 9) = tab(tab(:,3) > 0.8, 9) + 1;
    tab(tab(:,3) <= 0.8, 9) = 0;

    % group transfer
    trIdx = find(tab(:,9) == nTransfer);
    for t = 1:numel(trIdx)
        gList = unique(tab(:,4));
        gScore = [gList, groupValue(gList), zeros(numel(gList),1), zeros(numel(gList),1)];
        gScore(:,3) = gScore(:,2) / sum(gScore(:,2));
        gScore(:,4) = cumsum(gScore(:,3));

        if iter <= 5
            newG = find(gScore(:,4) > rand, 1, 'first');
        else

            choose = [gList, zeros(numel(gList),1)];
countGuard = 0;  
while sum(choose(:,2)) ~= 1
    countGuard = countGuard + 1;
    if countGuard > 500
      
        [~, rndIdx] = max(rand(numel(gList),1));
        choose(:,:) = 0;
        choose(rndIdx,2) = 1;
        break;
    end

    if sum(choose(:,2)) == 0
        z = find(choose(:,2) == 0);
        for k2 = 1:numel(z)
            if rand > quantum(z(k2),1)^2
                choose(z(k2),2) = 1;
            end
        end
    else
        z = find(choose(:,2) == 1);
        for k2 = 1:numel(z)
            if rand <= quantum(z(k2),1)^2
                choose(z(k2),2) = 0;
            end
        end
    end
end

            if rand > 0.5
                newG = find(choose(:,2) == 1);
            else
                newG = find(gScore(:,4) > rand, 1, 'first');
            end
            quantum(gScore(newG,1),3) = quantum(gScore(newG,1),3) + 1;
        end

        % update quantum meta (kept logic)
        quantum(:,4) = round( quantum(:,3) / max(quantum(:,3) + (quantum(:,3)==0)) );
        quantum(:,5) = groupValue;
        quantum(:,6) = 0;
        [~, bestG] = max(groupValue);
        for q = 1:size(quantum,1)
            if      quantum(q,4)==0 && quantum(bestG,4)==1 && q~=bestG
                quantum(q,6) = 0.01*pi * sign(prod(quantum(q,1:2)));
            elseif  quantum(q,4)==0 && quantum(bestG,4)==1 && q==bestG
                quantum(q,6) = -0.01*pi * sign(prod(quantum(q,1:2)));
            elseif  quantum(q,4)==1 && quantum(bestG,4)==0 && q~=bestG
                quantum(q,6) = -0.01*pi * sign(prod(quantum(q,1:2)));
            elseif  quantum(q,4)==1 && quantum(bestG,4)==0 && q==bestG
                quantum(q,6) = 0.01*pi * sign(prod(quantum(q,1:2)));
            end
            R = [cos(quantum(q,6)) sin(quantum(q,6)); sin(quantum(q,6)) cos(quantum(q,6))] * quantum(q,1:2)';
            quantum(q,1:2) = R';
        end

        tab(trIdx(t),4) = gScore(newG,1);
        tab(trIdx(t),9) = 0;
        tab(trIdx(t),5) = 1; % move to elite
    end

    % (optional) progress print
    
end

bestFitness  = globBestF;
bestPosition = globBestX;
convergence  = convergence(1:iter);

end

% ====================== Explorpolis======================
function ok = explorpolis_accept(cand, fCand, EliteX, EliteF, lb, ub, tau, dim)

    if isempty(EliteX)
        ok = true; return;
    end
    range = max(ub - lb, eps);
    dif   = (EliteX - cand) ./ range;       
    dn    = sqrt(sum(dif.^2, 2))/dim;         
    dominated = any( (EliteF <= fCand) & (dn <= tau) );
    ok = ~dominated;
end

function centers = build_guided_centers(popSize, X, maxIter, lb, ub, dim, fhd, funcId)

N = popSize;
halfN = round(0.5*N);
Old = lb + (ub-lb).*rand(N,dim);
New = Old;

Fy = arrayfun(@(i) fhd(New(i,:)', funcId), 1:size(New,1))';
[bestF, bestI] = min(Fy);
bestX = New(bestI,:);

try1 = 0.5*ones(5,1);
try2 = 0.5*ones(5,1);
try3 = 0.5*ones(5,1);
cPtr  = 1;

archiveCap = round(1.4*N);
archX = zeros(0,dim);
archF = zeros(0,1);

counter = 0;
sel11=[];sel12=[];sel21=[];sel22=[];
centers = [];

for k = 1:min(N*20, maxIter)
    counter = counter + 1;
    New = Old;

    [tx2, tx1, sortIdx, rr] = rand_place(Fy, N, try1, try2, try3);
    [tx1, flag1, flag2] = show_place(tx1, 0, maxIter, counter, N, dim, tx2, sel11, sel21, sel12, sel22);

    idx1 = 1:N;
    bag  = [New; archX];
    R1   = randi(N, 1, numel(idx1));           while any(R1==idx1), R1(R1==idx1)=randi(N); end
    R2   = randi(size(bag,1), 1, numel(idx1)); while any(R2==R1|R2==idx1)
        msk = (R2==R1|R2==idx1);
        R2(msk) = randi(size(bag,1),1,nnz(msk));
    end

    rndIndex = max(1, ceil(rand(1,N)*max(round(0.11*N),2)));
    pbest = New(sortIdx(rndIndex),:);
    T1 = New + tx1(:,ones(1,dim)) .* (pbest - New + New(R1,:) - bag(R2,:));
    T1 = bound_mid(New, lb, ub, T1);

    pick = mod(floor(rand(N,1)*dim), dim) + 1;
    pickLin = (pick-1)*N + (1:N)';

    mask = rand(N,dim) < rr(:,ones(1,dim));
    [KX, T1, newF] = call_place(New, sortIdx, halfN, dim, pickLin, mask, fhd, funcId, T1);

    [minF, minI] = min(newF);
    if minF < bestF, bestF = minF; bestX = KX(minI,:); end

    dF = abs(Fy - newF);
    improved = (Fy > newF);

    cx = rr(improved==1);
    cy = tx1(improved==1);
    cb = tx2(improved==1);
    round_d = dF(improved==1);

    if flag1
        sel11 = [sel11 numel(cy)];
        sel21 = [sel21 numel(tx1(improved==0))];
        sel12 = [sel12 1];
        sel22 = [sel22 1];
    end
    if flag2
        sel12 = [sel12 numel(tx1(improved==1))];
        sel22 = [sel22 numel(tx1(improved==0))];
        sel11 = [sel11 1];
        sel21 = [sel21 1];
    end

    addX = Old(improved==1,:);
    addF = Fy(improved==1);
    tmpX = [archX; addX]; tmpF = [archF; addF];
    [~, uq] = unique(tmpX, 'rows');
    tmpX = tmpX(uq,:); tmpF = tmpF(uq,:);
    if size(tmpX,1) <= archiveCap
        archX = tmpX; archF = tmpF;
    else
        r = randperm(size(tmpX,1)); r = r(1:archiveCap);
        archX = tmpX(r,:); archF = tmpF(r,:);
    end

    Fy = min([Fy,newF],[],2);
    Old(improved==1,:) = KX(improved==1,:);
    centers(k,:) = bestX; %#ok<AGROW>

    % adapt tries
    if ~isempty(cx)
        w = round_d / sum(round_d);
        try1(cPtr) = (w'*(cy.^2)) / (w'*cy);
        try2(cPtr) = (w'*(cx.^2)) / (w'*cx);
        try3(cPtr) = (w'*(cb.^2)) / (w'*cb);
        cPtr = cPtr + 1; if cPtr > 5, cPtr = 1; end
    end
end
end

function [KX, T1, newF] = call_place(New, sortIdx, halfN, dim, pickLin, mask, fhd, funcId, T1)

if rand < 0.4
    d = pdist2(New, New(sortIdx(1),:), 'euclidean');
    [~, ord] = sort(d,'ascend');
    nb = New(ord(1:halfN),:);
    mx = mean(nb);
    C = 1/(halfN-1) * (nb - mx(ones(halfN,1),:))' * (nb - mx(ones(halfN,1),:));
    C = triu(C) + triu(C,1)';
    [R, D] = eig(C);
    if max(diag(D)) > 1e20*min(diag(D))
        C = C + (max(diag(D))/1e20 - min(diag(D))) * eye(dim);
        [R, ~] = eig(C);
    end
    Xr  = New*R;
    T1r = T1*R;
    Q   = Xr;
    Q(pickLin)    = T1r(pickLin);
    Q(mask)       = T1r(mask);
    KX = Q*R';
else
    KX = New;
    KX(pickLin) = T1(pickLin);
    KX(mask)    = T1(mask);
end
newF = arrayfun(@(i) fhd(KX(i,:)', funcId), 1:size(KX,1))';
end

function [tx1, flag1, flag2] = show_place(tx1, temp_f, maxIter, counter, N, dim, tx2, s11, s21, s12, s22)

flag1=false; flag2=false;
if temp_f <= maxIter/2
    if counter <= 20
        if rand < 0.5
            tx1 = 0.5.*(sin(2*pi*0.5*counter+pi).*((2745-counter)/2745)+1).*ones(N,dim);
            flag1 = true;
        else
            tx1 = 0.5*(sin(2*pi.*tx2(:,ones(1,dim)).*counter).*(counter/2745)+1).*ones(N,dim);
            flag2 = true;
        end
    else
        n2 = sum(s11(max(counter-20,1):counter-1));
        n3 = sum(s21(max(counter-20,1):counter-1));
        r1 = n2/(n2+n3+eps) + 0.01;

        c1 = sum(s12(max(counter-20,1):counter-1));
        c2 = sum(s22(max(counter-20,1):counter-1));
        r2 = c1/(c1+c2+eps) + 0.01;

        p1 = r1/(r1+r2); p2 = r2/(r1+r2);
        if p1 > p2
            tx1 = 0.5.*(sin(2*pi*0.5*counter+pi).*((2745-counter)/2745)+1).*ones(N,dim);
            flag1 = true;
        else
            tx1 = 0.5*(sin(2*pi.*tx2(:,ones(1,dim)).*counter).*(counter/2745)+1).*ones(N,dim);
            flag2 = true;
        end
    end
end
end

function [tx2, tx1, sortIdx, rr] = rand_place(F, N, try1, try2, try3)

[~, sortIdx] = sort(F, 'ascend');
k = ceil(5*rand(N,1));
x1 = try1(k); x2 = try2(k); x3 = try3(k);

rr = normrnd(x2, 0.1);
rr(x2==-1) = 0; rr = min(max(rr,0),1);

tx1 = x1 + 0.1*tan(pi*(rand(N,1)-0.5));
w = find(tx1<=0);
while ~isempty(w)
    tx1(w) = x1(w) + 0.1*tan(pi*(rand(numel(w),1)-0.5));
    w = find(tx1<=0);
end

tx2 = x3 + 0.1*tan(pi*(rand(N,1)-0.5));
w = find(tx2<=0);
while ~isempty(w)
    tx2(w) = x3(w) + 0.1*tan(pi*(rand(numel(w),1)-0.5));
    w = find(tx2<=0);
end

tx1 = min(tx1,1);
tx2 = min(tx2,1);
end

function T1 = bound_mid(New, lb, ub, T1)

[n, d] = size(New);
for i = 1:n
    for j = 1:d
        if T1(i,j) < lb(j), T1(i,j) = (T1(i,j) + lb(j))/2; end
        if T1(i,j) > ub(j), T1(i,j) = (T1(i,j) + ub(j))/2; end
    end
end
end

function [X, F] = backoff_try(backList, X, F, Xnet, iter, ub, lb, maxIter, fhd, funcId)

pool = [[X F]; [backList(:,3:end) backList(:,2)]];
pool = sortrows(pool, size(pool,2));

[~, worstIdx] = max(F);
if rand <= iter/maxIter*2
   
    idx = min(iter, size(Xnet,1));   
    X(worstIdx,:) = Xnet(idx,:);
    F(worstIdx)   = fhd(X(worstIdx,:)', funcId);
end

newLink = pool(1,:); newIdx = 1; oldLink = [];
p = 1;
while p < size(pool,1)
    p = p + 1;
    for i = 1:size(newLink,1)
        d1 = sqrt(sum(abs(pool(p,1:end-1) - newLink(i,1:end-1))./(ub-lb),2));
        d2 = sqrt(sum(abs(pool(p+1:end,1:end-1) - newLink(i,1:end-1))./(ub-lb),2));
        e  = find(d2 <= d1);
        if ~isempty(e)
            e = e + p;
            oldLink = [oldLink; pool(e,:)]; 
            pool(e,:) = [];
        end
    end
    newLink(end+1,:) = pool(p,:); 
    newIdx(end+1,1)  = p; 
end

for i = size(newLink,1):-1:1
    d = sqrt(sum(abs(newLink(i,1:end-1) - backList(:,3:end)).^2, 2));
    t = find(d==0);

    if ~isempty(t)
    if all(backList(t,1) ~= worstIdx)
        X(backList(t,1),:) = backList(t,3:end);
        F(backList(t,1))   = backList(t,2);
    end
    end

end
end

function [gBestX, gBestF, globBestX, globBestF, pBestF, pBestX] = ...
    refresh_bests(X, F, iter, gBestX, gBestF, tab, globBestX, globBestF, pBestF, pBestX, nGroups)

if iter == 1
    pBestX = X; pBestF = F;
    gBestX = zeros(nGroups, size(X,2));
    gBestF = inf(nGroups,1);
    for g = 1:nGroups
        rows = (tab(:,4) == g);
        [gBestF(g), idx] = min(F(rows));
        idxAbs = find(rows,1,'first') - 1 + idx;
        gBestX(g,:) = X(idxAbs,:);
    end
    [globBestF, idx] = min(F);
    globBestX = X(idx,:);
else
    improv = find(pBestF > F);
    if ~isempty(improv)
        pBestX(improv,:) = X(improv,:);
        pBestF(improv)   = F(improv);
    end

    uGroups = unique(tab(:,4));
    for k = 1:numel(uGroups)
        g = uGroups(k);
        rows = find(tab(:,4) == g);
        [minVal, loc] = min(F(rows));
        if minVal < gBestF(g)
            gBestF(g) = minVal;
            gBestX(g,:) = X(rows(loc),:);
        end
    end

    [minVal, loc] = min(F);
    if minVal < globBestF
        globBestF = minVal;
        globBestX = X(loc,:);
    end
end
end
