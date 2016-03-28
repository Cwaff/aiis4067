function [Sn, weights] = resampleN(N, S, weights)
%
% function [Sn, pesos] = resampleN(N, S, pesos)


Sn = S;

% 1. Select N samples
% SIR (Sampling Importance Resampling)
% (a) calculate the normalised cummulative probabilities c

%///////////To be Completed as Step 6 \\\\\\\\\\\\\\\\\\\\



c = c./c(N); % we need to normalised teh cummulative weights

% (b) Random initial point
r = rand(1)/N;
% (c) Resample from the smalles t value j so that c(j)>=r
i=1;
for j=1 : N
   aux=r+(j-1)/N;
   while aux > c(i)
      i = i+1;
   end
   Sn(j,:) = S(i,:);
   pesos(j)=1/N;
end

%after resampling all the particles are identical (same weight)
weights = ones(N,1)/N;

end