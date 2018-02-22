function [ envRect ] = setEnvironment(shiftedXPatch, shiftedYPatch, ...
                                      envSize, cols, rows)
    xEnv    = max(1, shiftedXPatch);
    yEnv    = max(1, shiftedYPatch);
    width   = min(cols, xEnv + envSize) - xEnv;
    height  = min(rows, yEnv + envSize) - yEnv;
    envRect = [xEnv, yEnv, width, height];
end

