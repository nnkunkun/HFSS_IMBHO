function bwGHz = compute_s11_bandwidth(freqGHz, s11dB, thresholddB)
% 中文说明：
% 计算满足 S11 <= thresholddB 的最长连续频段宽度（GHz）。

if nargin < 3
    thresholddB = -10;
end

freqGHz = freqGHz(:);
s11dB = s11dB(:);
[freqGHz, order] = sort(freqGHz, 'ascend');
s11dB = s11dB(order);

passMask = s11dB <= thresholddB;
if ~any(passMask)
    bwGHz = 0;
    return;
end

step = median(diff(freqGHz));
if isempty(step) || step <= 0
    bwGHz = 0;
    return;
end

idx = find(passMask);
splitPos = [0; find(diff(idx) > 1); numel(idx)];
bwGHz = 0;
for i = 1:numel(splitPos) - 1
    seg = idx(splitPos(i) + 1:splitPos(i + 1));
    currentBW = freqGHz(seg(end)) - freqGHz(seg(1));
    if numel(seg) == 1
        currentBW = step;
    else
        currentBW = currentBW + step;
    end
    bwGHz = max(bwGHz, currentBW);
end
end

