function [ features ] = findPatches(features, Icurr, currTime)
    envSize = 65;
    shift   = 20;
    [rows, cols] = size(Icurr);
    for i = 1:21
        feature = features(i);
        if (feature.lastSeen < currTime - 1)
            % Predict location
        else
            % TODO: put in aux function
            xPatch  = feature.pos(1);
            xEnv    = max(1, xPatch - shift);
            yPatch  = feature.pos(2);
            yEnv    = max(1, yPatch - shift);
            width   = min(cols, xEnv + envSize) - xEnv;
            height  = min(rows, yEnv + envSize) - yEnv;
            envRect = [xEnv, yEnv, width, height];
            IcurrEnv = imcrop(Icurr, envRect);
            [tmpPos, isValid] = [0, 0]; %tmp, valid = findPatch(feature.data, [xPatch - xEnv, yPatch - yEnv, width, height], IcurrEnv);
        end
        something = checkConstraints(tmpPos, i); %TODO
    end


end

