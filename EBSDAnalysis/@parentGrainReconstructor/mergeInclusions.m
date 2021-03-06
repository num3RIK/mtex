function job = mergeInclusions(job, varargin)
% merge inclusions into grains 
%
% Syntax
%   job.mergeInclusions
%
% Input
%  job - @parentGrainReconstructor
%
% Output
%  job.grains - reconstructed parent grains
%  job.mergeId - 
%
% Options
%  maxSize - maximum pixel size of an inclusion to be merged
%

[job.grains, mergeId] = merge(job.grains, 'inclusions', varargin{:});
job.mergeId = mergeId(job.mergeId); %#ok<*PROPLC>
job.ebsd('indexed').grainId = mergeId(job.ebsd('indexed').grainId);

end