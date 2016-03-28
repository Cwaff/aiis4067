function w = rsample(N, sigma)
%
% function w = rsample(N, sigma)
%
% Selecciona N muestras aleatorias de una distribución gausiana de media zero y matriz 
% de covarianza sigma.
%

w = zeros(N,1);

if sigma > 0
   
M = 5*N;
g = ones(M+1,1);

paso = (3*sigma)/M;

j=1;
for i=0 : paso : 3*sigma
   g(j) = exp(-0.5*i*i/sigma^2);
   j = j+1;
end

c = ones(M+1,1);
for i=2 : M+1
   c(i) = c(i-1) + g(i);
end

paso = c(M+1)/(N/2);
sample = ones(round(N/2), 1);

i = 2;
for j=1 : (floor(N/2));
   while c(i) < paso*j
      i = i+1;
   end
	sample(j) = i;
end

paso = (3*sigma)/M;


w(1:floor(N/2),1) = -sample(1:floor(N/2))*paso;
w(1+ceil(N/2):N,1) = sample(1:floor(N/2))*paso;
w(round(N/2))=0;

end

