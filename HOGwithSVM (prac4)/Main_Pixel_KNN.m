clear all; 
close all;

%% Training Model
%Load training images
[pedestrianTrainImages, pedestrianTrainLabels] = loadPedestrianDatabase('pedestrian_train.cdataset', 10);

%Write previous arrays to new training arrays 
trainImages = pedestrianTrainImages;
trainLabels = pedestrianTrainLabels;

%Set training array size
numTrainImages = size(trainImages, 1);

%Train the dataset and record the time 
tic
model = NNtraining(trainImages,trainLabels);
trainingTime = toc;

%% Test Data 
%Load testing images
[pedestrianTestImages, pedestrianTestLabels] = loadPedestrianDatabase('pedestrian_test.cdataset', 10);

%Set testing array sizes
numTestImages = size(pedestrianTestImages)
numTestImages = size(pedestrianTestImages,1)

%Test images, generate prediction and record the time 
tic
for i = 1 :numTestImages
    testnumber= pedestrianTestImages(i, :);
    [prediction(i, 1)] = KNNTesting(testnumber, model,10);
end
testingTime = toc;

%Set values for results tables 
comparison = (pedestrianTestLabels == prediction);
accuracy = sum(comparison)/length(comparison)

tp=0;
tn=0;
fp=0;
fn=0;

% Determine values for Results tables 
for i=1:numTestImages
    if(and(prediction(i,1) == 1,pedestrianTestLabels(i,1) == 1))
        tp = tp +1;
    elseif(and(prediction(i,1) == 1,pedestrianTestLabels(i,1) == -1))
        fp = fp+1;
    elseif(and(prediction(i,1) == -1,pedestrianTestLabels(i,1) == -1))
        tn = tn+1;
    else
        fn = fn+1;
    end
end

%% Testing Outputs
errorRate = (fn+fp)/numTestImages
sensitivity = tp/(tp+fn)
precision = tp/(tp+fp)
specificity = tn/(tn +fp)
falseAlarm = 1 - specificity
f1 = (2*tp)/((2*tp) + fn + fp)
trainingTime
testingTime
