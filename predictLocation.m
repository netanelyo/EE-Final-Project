function [ prediction, valid ] = predictLocation(features, i)
    valid = 1;
    if (i > 2)
        p1 = features(i - 1).pos(1:2);
        p2 = features(i - 2).pos(1:2);
    end
    if (i == 8 || i == 12 || i == 16)
        prediction = p1 + round(20*(p1 - p2)/norm(p1 - p2));
    elseif ((i == 9 || i == 13 || i == 17) && ...
            features(i - 1).lastSeen >= currTime - 1)
        prediction = p1 + round(30*(p1 - p2)/norm(p1 - p2));
    else
        valid = 0;
    end
end
