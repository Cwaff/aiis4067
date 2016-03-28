function [newState] = new_State(S, weigths)

% (4) Estimate position (weighted average)
[numTargets,b,c]=size(S);
for i=1 : numTargets
	aux=S(i,:,:);
	aux=reshape(aux,[b,c]);
    
    % calculate the new state as the weighted average of all the particles
    % by their weight
	newState= %///////////To be Completed as Step 9 \\\\\\\\\\\\\\\\\\\\
    
end

