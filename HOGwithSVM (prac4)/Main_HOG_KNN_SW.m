clear all; 
close all;

[pedestrianTrainImages, pedestrianTrainLabels] = loadPedestrianDatabase('pedestrian_train.cdataset', 5);
%[pedestrianTestImages, pedestrianTestLabels] = loadPedestrianDatabase('pedestrian_test.cdataset', 10);

%trainImages = cat(1,pedestrianTrainImages,pedestrianTestImages);
%trainLabels = cat(1,pedestrianTrainLabels,pedestrianTestLabels);
%}
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

for i = 1 :numTrainImages
    featureImage = reshape(trainImages(i, :), [160, 96]);
    hogFeatures(i, :) = hog_feature_vector(featureImage);
end

showHog(hogFeatures(i, :), [160, 96]);

%model = SVMtraining_1(hogFeatures, trainLabels);
tic
model = SVMTraining(hogFeatures,trainLabels);
trainingTime = toc;

%{
[pedestrianTestImages, pedestrianTestLabels] = loadPedestrianDatabase('pedestrian_test.cdataset', 10);

numTestImages = size(pedestrianTestImages)
numTestImages = size(pedestrianTestImages,1)
%}

imgPath = 'pedestrian/';
imgType = '*.jpg'; % change based on image type
images  = dir([imgPath imgType]);
figure
for idx = 1:length(images)
    Images{idx} = imread([imgPath images(idx).name]);
    buffer(:,:,:,idx) = Images{idx};
end

%frame = imread('pedestrian/image_00000429.jpg');


im_width = 640;
im_height = 480;

widths = [144,96,48];
heights = [240,160,80];

heightcount = 0;
widthcount = 0;

finalVideo = VideoWriter('resultTracking');
open(finalVideo);
for m=1:length(images)

    testImage = rgb2gray(buffer(:,:,:,m));
    testImage = double(testImage);
    
predictions = [];
boxes = [];
confidences = [];
b_conf = [];
imshow(buffer(:,:,:,m)) 
count = 0;
boxcount = 0;
hold on
for b = 1:3
    
    sw_width = widths(b);
    sw_height = heights(b);
    sw_increment = 4;
    stepX = round(sw_width/sw_increment);
    stepY = round(sw_height/sw_increment);
    
    for i = 1:stepY:size(testImage,1)
        for j = 1:stepX:size(testImage,2)

            if (i+sw_height-1 <= size(testImage,1)) && (j+sw_width-1 <= size(testImage,2))
               count = count+1; 
                crop = testImage(i:i+sw_height-1, j:j+sw_width-1); 
               % digitIm = reshape(digitIm,1,sw_width*sw_height);
                digitIm = imresize(crop,[160 96]);
                 hogFeatures = hog_feature_vector(digitIm);
                [predictions(count, 1), confidences(count,1)] = SVMTesting_v2(hogFeatures, model);

                if (predictions(count, 1) == 1)
                    if(confidences(count,1) > 1)
                        boxcount = boxcount+1;
                        boxes(boxcount,:) = [j i sw_width sw_height confidences(count,1)]; 
                        %rectangle('Position', [j i sw_width sw_height]);
                        %b_conf(boxcount,1) = confidences(count,1);
                        %set(boxes, 'EdgeColor','r','LineWidth',1);
                    end
                end
            end
        end
    end
end

%newboxes=boxes;
newboxes = simpleNMS(boxes,.1);

for b = 1:size(newboxes,1)
    h = rectangle('Position', newboxes(b,1:4));
    set(h, 'EdgeColor','r','LineWidth',1);
end
hold off 

f = getframe(gca);
writeVideo(finalVideo, f);
%buffer(:,:,:,m) = frame2im(f);
end
close(finalVideo);
%{
figure
for n = 1:5%length(images)
    imshow(buffer(:,:,:,n)), title('PLAYBACK')
    
    pause(1)
end
%}


%predictions = cat(1,predictions,predictionRow);
%}
    %{
tic
for i = 1 :numTestImages
    featureImage = reshape(pedestrianTestImages(i, :), [160, 96]);
    hogFeatures(i, :) = hog_feature_vector(featureImage);
    [prediction(i, 1)] = KNNTesting(hogFeatures(i,:), model,3);
    %[prediction(i, 1)] = NNTesting(pedestrianTestImages(i, :), model);
end
testingTime = toc;
%}


%{
comparison = (pedestrianTestLabels == prediction)

accuracy = sum(comparison)/length(comparison)

tp=0;
tn=0;
fp=0;
fn=0;
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

errorRate = (fn+fp)/numTestImages
sensitivity = tp/(tp+fn)
precision = tp/(tp+fp)
specificity = tn/(tn +fp)
falseAlarm = 1 - specificity
f1 = (2*tp)/((2*tp) + fn + fp)
trainingTime
testingTime
%}