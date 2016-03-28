function [Sn, weights] = condensation(N, S, weights, I, dt, histogramModel, D, colour_channels)

[nrows, ncolumns, colours] = size(I);

dist = zeros(N,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Particle Filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (1) Selection: we apply resampling to know which particles survive and
% whihc ones die
[Sn, weights] = resampleN(N, S, weights);

num = 20; % 
randomSeq = random_Noise_Generator(num+1, dt);
noise = zeros(size(S,2),1);

% for each particle
for n=1 : N
   % we isolate the particle
   s = Sn(n,:);  % s = [x,y,xp,yp,rx,ry,rxp,ryp];
   
   % (2) Prediction (propagation): s(n,t) = D*s(n,t-1) + noise(n,t-1)
   for j=1 : length(s) % loop to calculate random noise (as random as possible)
      indice = 1+round(num*rand(1));
      noise(j) = randomSeq(j, indice);
   end

   s_pred = prediction(s, noise, D);
   
  % (3) Observation: If the particle is inside the image: 
   if (s_pred(1)>s_pred(5)+1) & (s_pred(2)>s_pred(6)+1) & (s_pred(1)<ncolumns-s_pred(5)-1) & (s_pred(2)<nrows-s_pred(6)-1)
       
		% (3a) calculate the colour distribution (histogram) of the
		% particle position
            histogram=    %///////////To be Completed as Step 8 \\\\\\\\\\\\\\\\\\\\
            
        % (3b) Bhattacharyya distance to measure the similarity bettwen the
        % particle and our reference model
        dist(n) = 0;
        for c=1:colour_channels
            dBhattacharyya = %///////////To be Completed as Step 8 \\\\\\\\\\\\\\\\\\\\ ;
            dist(n) = dist(n) + dBhattacharyya; 
        end
        
   else
      dist(n) = 1;
   end
   
   Sn(n,:)=s_pred;

end

% Weight normalisation so they are a probability distribution and their sum is 1
weights = exp(-dist.^2); 

if sum(weights)>0
    weights = weights./sum(weights);
end

end
