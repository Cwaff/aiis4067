function [ U,S,X_reduce ] = pca(X,n)
%this function implements pca and 
%  returns  U:eigenvectors,S:eigenvalues & X_reduce: dataset with n dimensions
% here X:dataset with each instance as a row , n: reduced dimesions size
% defualt n = 50 ;
if nargin < 2 AND size(X,2)> 50
    n = 50;
elseif size(X,2)<50
    fprintf('very few dimensions.. maybe you dont need pca at all')
end

m = size(X,1);
sigma = (1/m)*(X'*X);
[U S] = svd(sigma);

X_reduce = zeros(size(X, 1), n); 
U_reduce = U(:,1:n);      
for i=1:m
    for j=1:n
        x= X(i,:)';            
        X_reduce(i,j) = x'*U_reduce(:,j);
    end
end


end

