function [ allFeatures ] = findPatches(allFeatures, Icurr, currTime)
    [rows, cols] = size(Icurr);
    backTrack = size(allFeatures, 2);
    numOfFeatures = size(allFeatures, 1);
    tmpPosition = zeros(numOfFeatures, 4);
    allBBS = zeros(backTrack,1);
    argmin = zeros(numOfFeatures,1);
    for i = numOfFeatures:-1:1
        tmpRect = zeros(4, backTrack);
        validVec = ones(backTrack, 1);
        shift   = 20;
        envSize = 65; 
        patchSize = 26;
        for k = 1:backTrack
            features    = allFeatures(:,k);
            feature     = features(i);
            if (all([allFeatures(i,:).valid]) == 0) % invalid
                prediction = predictLocation(features, i); % TODO: Need to be fixed
                envSize = 89;
                shift   = 31;
                feature.pos(1:2) = prediction;
            end
            xPatch = feature.pos(1);
            yPatch = feature.pos(2);
            envRect = setEnvironment(xPatch - shift, yPatch - shift, ...
                                     envSize, cols, rows);
            IcurrEnv = imcrop(Icurr, envRect);
            [tmp, valid, bbs] = findPatch(feature.data, ...
                                          [...
                                           xPatch - envRect(1), ...
                                           yPatch - envRect(2), ...
                                           patchSize, patchSize ...
                                          ], IcurrEnv);            
            tmpRect(:,k) = tmp;
            allBBS(k) = bbs;
            validVec(k) = valid;
        end
        [~, amax]   = max(allBBS);
        [~, amin]   = min(allBBS);
        argmin(i)   = amin;
        tmp = tmpRect(:,amax);
        tmpPosition(i,:) = [tmp(1:2)' + [envRect(1), envRect(2)], ...
                            patchSize, patchSize];
                        
        fprintf('Current time = %d. Feature #%d: closest is time %d\n', currTime, i, allFeatures(i, amax).lastSeen);
        %% Check it %%
        if (any(validVec) == 0)
            allFeatures(i,validVec == 0).valid      = 0;
            allFeatures(i,validVec == 0).data       = zeros(27,27,3);
        end
        %%%%%%%%%%%%%%
        if (any(validVec) == 1)
            valid = 1;
        end
    end
    %% TODO: this is good if all are valid!
    for i = 1:numOfFeatures
        amin = argmin(i);
        if valid
            allFeatures(i,amin).data        = imcrop(Icurr, tmpPosition(i,:));
            allFeatures(i,amin).pos         = tmpPosition(i,:);
            allFeatures(i,amin).lastSeen    = currTime;
            allFeatures(i,amin).valid       = 1;
        else
            
        end
    end
%     something = checkConstraints(tmpPos, i); % TODO: implement
end
