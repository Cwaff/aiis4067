clear all 
close all 
load Yale_64x64
[nSamples, nDimensions] = size(fea); 

h=64;
w=64;
% draw the first 9 images 
% //////////STEP 4 \\\\\\\\\\\\\\\\\\\\\\
figure
    for i=1:9
        im = reshape(fea(i,:),[h,w]);
        subplot(3,3,i), imshow(uint8(im));
    end

% Apply PCA
% //////////STEP 5 \\\\\\\\\\\\\\\\\\\\\\
[eigenVectors, eigenvalues, meanX, Xpca] = PrincipalComponentAnalysis(fea, 15);

%% show 0th through 15th principal eigenvectors 
eig0 = reshape(meanX, [h,w]); 
figure,subplot(4,4,1) 
imagesc(eig0) 
colormap gray 
for i = 1:15 
subplot(4,4,i+1) 
imagesc(reshape(eigenVectors(:,i),h,w)) 
end

%%
%animation for observing the variation of the first eigenvector
%////////////////////// STEP 7 \\\\\\\\\\\\\\\\\\\\\\\\\\
eigVector_index = 1;
weights = [-3*sqrt(eigenvalues(eigVector_index)): 6*sqrt(eigenvalues(eigVector_index))/200: 3*sqrt(eigenvalues(eigVector_index))];
figure

for b=weights
    faceReconstruct = meanX + b*eigenVectors(:,eigVector_index)';
    faceReconstructImage = reshape(faceReconstruct,[h w]);
    imagesc(faceReconstructImage), colormap(gray), axis equal, axis off,
    drawnow
end
