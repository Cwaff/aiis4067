clear all; 
close all;

[pedestrianTrainImages, pedestrianTrainLabels] = loadPedestrianDatabase('pedestrian_train.cdataset', 10);
%{
%showHog rsize = [160,96] !!!!

%Declare variables for storing image locations

filepath = 'images\pos\';
filepathneg = 'images\neg\';
imagefilespos = dir('images\pos');
imagefilesneg = dir('images\neg');
nfiles = length(imagefilespos);    % Number of files found

%Image Array declarations 
pedestrianTrainImages = [];
pedestrianTrainLabels = [];
pedestrianTrainImagesneg = [];
pedestrianTrainLabelsneg = [];

%Assign positive images to correct row of images matrix array
%First row positive images
%sceond row positive labels 
for i=3:nfiles
    currentfilename = imagefilespos(i).name;
    currentimage = imread(currentfilename);
    if size(currentimage,3)>1
        currentimage = rgb2gray(currentimage);
    end
    currentimage = currentimage(:)';
    pedestrianTrainImages(i-2,:) = currentimage(1,:);
    pedestrianTrainLabels(i-2,1) = 1;
end

%Assign negative images to correct row of images matrix array
%First row negative images
%sceond row negative labels 
nfiles = length(imagefilesneg);
for i=3:nfiles
    currentfilename = imagefilesneg(i).name;
    currentimage = imread(currentfilename);
    if size(currentimage,3)>1
        currentimage = rgb2gray(currentimage);
    end
    currentimage = currentimage(:)';
    pedestrianTrainImagesneg(i-2,:) = currentimage(1,:);
    pedestrianTrainLabelsneg(i-2,1) = -1;
end

%Concatenate positive and negatives into 1 array 
pedestrianTrainImages = cat(1,pedestrianTrainImages,pedestrianTrainImagesneg);
pedestrianTrainLabels = cat(1,pedestrianTrainLabels,pedestrianTrainLabelsneg);
%}
%Write previous arrays to new training arrays 
trainImages = pedestrianTrainImages;
trainLabels = pedestrianTrainLabels;

%Set training array size
numTrainImages = size(trainImages, 1);


%i=1;
%{
for i = 1 :numTrainImages
    featureImage = reshape(trainImages(i, :), [160, 96]);
    hogFeatures(i, :) = hog_feature_vector(featureImage);
end

showHog(hogFeatures(i, :), [160, 96]);
%}
%model = SVMtraining_1(hogFeatures, trainLabels);
%model = NNtraining(trainImages,trainLabels);

[eigenVectors,eigenvalues,meanX,x_pca] = PrincipalComponentAnalysis(trainImages);
model = NNtraining(x_pca,trainLabels);

[pedestrianTestImages, pedestrianTestLabels] = loadPedestrianDatabase('pedestrian_test.cdataset', 10);


numTestImages = size(pedestrianTestImages)
numTestImages = size(pedestrianTestImages,1)

%prediction = zeros(pedestrianTestImages,1);

for i = 1 :numTestImages
    testnumber= pedestrianTestImages(i, :);
    test_xpca = (testnumber - meanX) * eigenVectors;
    [prediction(i, 1)] = KNNTesting(test_xpca, model,3);
end

comparison = (pedestrianTestLabels == prediction);

accuracy = sum(comparison)/length(comparison)

% %Load pedestrian db 
% %[testimages, testlabels] = loadPedestrianDatabase('pedestrian_train.cdataset');
% 
% %Calculate all Hogs for test images 
% %hogMatrix = calcAllHogs(trainImages);
% 
% %DisplayHog
% % for i = 1 :numTrainImages
% %    showHog(hogMatrix(i, :), [160, 96]);
% % end
% 
% 
% %Create training model 
% svmModel = SVMTraining(hogMatrix, testlabels);
% 
% %Load Pedestrian Testing dataset 
% [pedestrianTestImages, pedestrianTestLabels] = loadPedestrianDatabase('pedestrian_test.cdataset', 10);
% 
% %Set test array size
% numTestImages = size(pedestrianTestImages, 1);
% 
% 
% for i = 1 :numTestImages
%     featureImage = reshape(pedestrianTestImages(i, :), [160, 96]);
%     hogMatrix(i, :) = hog_feature_vector(featureImage);
%     [prediction(i, 1) maxi] = SVMTesting(hogFeatures, model);
% end
% 
% comparison = (pedestrianTestLabels == prediction);
% 
% accuracy = sum(comparison)/length(comparison);
%}
