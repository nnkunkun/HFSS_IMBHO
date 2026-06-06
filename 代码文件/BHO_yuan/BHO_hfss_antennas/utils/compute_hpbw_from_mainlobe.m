function hpbwDeg = compute_hpbw_from_mainlobe(thetaDeg, gainDB)
% 中文说明：
% 根据主瓣方向图重算半功率波束宽度（HPBW）。
% 若主瓣出现在 0 度附近，则使用首个 -3 dB 交点并按对称主瓣近似为 2*theta3dB。

thetaDeg = thetaDeg(:);
gainDB = gainDB(:);
[thetaDeg, order] = sort(thetaDeg, 'ascend');
gainDB = gainDB(order);

[peakGain, peakIdx] = max(gainDB);
targetGain = peakGain - 3;

if peakIdx == 1 || thetaDeg(peakIdx) <= 5
    rightIdx = find(thetaDeg >= thetaDeg(peakIdx) & gainDB <= targetGain, 1, 'first');
    if isempty(rightIdx)
        hpbwDeg = nan;
        return;
    end
    if rightIdx == 1
        theta3dB = thetaDeg(1);
    else
        theta3dB = interp_cross(thetaDeg(rightIdx - 1:rightIdx), gainDB(rightIdx - 1:rightIdx), targetGain);
    end
    hpbwDeg = 2 * abs(theta3dB - thetaDeg(peakIdx));
    return;
end

leftIdx = find(thetaDeg <= thetaDeg(peakIdx) & gainDB <= targetGain, 1, 'last');
rightIdx = peakIdx - 1 + find(thetaDeg(peakIdx:end) >= thetaDeg(peakIdx) & gainDB(peakIdx:end) <= targetGain, 1, 'first');
if isempty(leftIdx) || isempty(rightIdx)
    hpbwDeg = nan;
    return;
end

thetaLeft = interp_cross(thetaDeg(leftIdx:leftIdx + 1), gainDB(leftIdx:leftIdx + 1), targetGain);
thetaRight = interp_cross(thetaDeg(rightIdx - 1:rightIdx), gainDB(rightIdx - 1:rightIdx), targetGain);
hpbwDeg = abs(thetaRight - thetaLeft);
end

function thetaCross = interp_cross(thetaPair, gainPair, targetGain)
if numel(thetaPair) ~= 2 || numel(gainPair) ~= 2 || abs(diff(gainPair)) <= 1e-12
    thetaCross = thetaPair(end);
    return;
end
t = (targetGain - gainPair(1)) / (gainPair(2) - gainPair(1));
thetaCross = thetaPair(1) + t * (thetaPair(2) - thetaPair(1));
end

