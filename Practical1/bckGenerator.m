function [Bkg] = bckGenerator(videoStream, sampling)

buffer=[];
counter = 0;

for t = 1:sampling:size(videoStream,4)
    counter = counter+1;
    buffer(:,:,counter) = double(rgb2gray(videoStream(:,:,:,t)));
    Bkg = median(buffer,3);
end
end