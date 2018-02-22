function [ features ] = findPatches(features, Icurr, currTime)
    [rows, cols] = size(Icurr);
    [~, numOfFeatures] = size(features);
    tmpPosition = zeros(4, 21);
    for i = numOfFeatures:-1:1
        shift   = 20;
        envSize = 65;
        feature = features(i);
        if (feature.lastSeen < currTime - 1)
            [ prediction, valid ] = predictLocation(features, i);
            if (valid)
                envSize = 89;
                shift   = 31;
                feature.pos(1:2) = prediction;
            else
                continue;
            end
        end
        xPatch = feature.pos(1);
        yPatch = feature.pos(2);
        envRect = setEnvironment(xPatch - shift, yPatch - shift, ...
                                 envSize, cols, rows);
        IcurrEnv = imcrop(Icurr, envRect);
        [tmpPosition(:,i), valid] = findPatch(feature.data, ...
                                            [xPatch - envRect(1), ...
                                            yPatch - envRect(2), ...
                                            envRect(3), envRect(4)], ...
                                            IcurrEnv);
    end
    
    %% TODO: this is good if all are valid!
    for i = 1:numOfFeatures
        features(i).data        = imcrop(Icurr, tmpPosition(:,i)');
        features(i).pos         = tmpPosition(:,i)';
        features(i).lastSeen    = currTime;
    end
%     something = checkConstraints(tmpPos, i); % TODO: implement
end
