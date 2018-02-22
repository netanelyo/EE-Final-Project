function [ rectOut, isValid ] = findPatch( originalPatch,originalPatchRect,newPatchEnv)
%   This function get a path from frame_t
%   an environmant from frame_t+1 we susspetcs to contain the patch
%   and find the patch in frame_t+1
%   Input:
%   1. originalPatch.
%   2. patch's rect position and size
%   3. the patch location in frame_t+1
threshold = 0.2;
gamma = 2;
pz = 3;
[newPatchEnv,originalPatch,originalPatchRect] =...
    adjustImageSize(newPatchEnv,originalPatch,originalPatchRect,pz);
szT = size(originalPatch);
BBS = computeBBS(newPatchEnv,originalPatch,gamma, pz);
BBS = BBinterp(BBS, szT(1:2), pz, NaN);
if (max(BBS(:)) >= threshold)
    rectOut = round(findTargetLocation(BBS,'max',originalPatchRect(3:4)));
    isValid = true;
else
    rectOut = originalPatchRect;
    isValid = false;
end



