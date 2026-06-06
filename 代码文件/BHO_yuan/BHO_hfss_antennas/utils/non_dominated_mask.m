function mask = non_dominated_mask(obj)
% 中文说明：
% 返回最小化意义下的非支配解布尔掩码。

if isempty(obj)
    mask = false(0, 1);
    return;
end

n = size(obj, 1);
mask = true(n, 1);
for i = 1:n
    if ~mask(i)
        continue;
    end
    for j = 1:n
        if i == j
            continue;
        end
        if all(obj(j, :) <= obj(i, :)) && any(obj(j, :) < obj(i, :))
            mask(i) = false;
            break;
        end
    end
end
end

