function [feature] = calcAllHogs(images)
%calcAllHogs Summary of this function goes here
%   
%   Process every image in the training set 
%   using HOG and store all the resulting features 
%   vectors into a matrix.


temp = [];
for x = 1:size(images,1)
   
    theImage = images(x,:);
    theImageR = reshape(theImage,[160,96]);
    theHogTest = hog_feature_vector(theImageR);
    temp(x,:) = theHogTest;
end
  feature = temp;
end

