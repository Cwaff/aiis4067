clear all;

%[pedestrianTrainImages, pedestrianTrainLabels] = loadPedestrianDatabase('pedestrian_train.cdataset', 10);
filepath = 'images\pos\';
filepathneg = 'images\neg\';
imagefilespos = dir('images\pos');
imagefilesneg = dir('images\neg');
nfiles = length(imagefilespos);    % Number of files found
pedestrianTrainImages = [];
pedestrianTrainLabels = [];
pedestrianTrainImagesneg = [];
pedestrianTrainLabelsneg = [];
for i=3:nfiles
    currentfilename = imagefilespos(i).name;
    currentimage = imread(currentfilename);
    if size(I,3)>1
        currentimage = rgb2gray(currentimage);
    end
    currentimage = currentimage(:)';
    pedestrianTrainImages(i-2,:) = currentimage(1,:);
    pedestrianTrainLabels(i-2) = 1;
end
nfiles = length(imagefilesneg);
for i=3:nfiles
    currentfilename = imagefilesneg(i).name;
    currentimage = imread(currentfilename);
    if size(I,3)>1
        currentimage = rgb2gray(currentimage);
    end
    currentimage = currentimage(:)';
    pedestrianTrainImagesneg(i-2,:) = currentimage(1,:);
    pedestrianTrainLabelsneg(i-2) = -1;
end
pedestrianTrainImages = cat(1,pedestrianTrainImages,pedestrianTrainImagesneg);
pedestrianTrainLabels = cat(2,pedestrianTrainLabels,pedestrianTrainLabelsneg);

imwrite(pedestrianTrainImages, trainImages);
imwrite(pedestrianTrainLabels, trainLabels);


numTrainImages = size(pedestrianTrainImages, 1);

for i = 1 :numTrainImages
    featureImage = reshape(pedestrianTrainImages(i, :), [160, 96]);
    hogFeatures(i, :) = hog_feature_vector(featureImage);
end

showHog(hogFeatures(i, :), [160, 96]);

model = SVMtraining_v2(hogFeatures, pedestrianTrainLabels);

[pedestrianTestImages, pedestrianTestLabels] = loadPedestrianDatabase('pedestrian_test.cdataset', 10);

numTestImages = size(pedestrianTestImages, 1);

for i = 1 :numTestImages
    featureImage = reshape(pedestrianTestImages(i, :), [160, 96]);
    hogFeatures(i, :) = hog_feature_vector(featureImage);
    [prediction(i, 1) maxi] = SVMTesting_v2(hogFeatures, model);
end

comparison = (pedestrianTestLabels == prediction);

accuracy = sum(comparison)/length(comparison);
