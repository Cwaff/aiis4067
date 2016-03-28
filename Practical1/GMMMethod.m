clear all
close all

file_name = 'viptraffic.avi';
videoObj = VideoReader(file_name);

vidFrames = read(videoObj);

vidSize = size(vidFrames, 4); %length of video
height = size(vidFrames, 1); % height of image
width = size(vidFrames, 2); % width of image

counter = 0;
GMM = InitialiseGMM(height, width);
for t = 1:vidSize
    counter = counter+1;
    frame = double(rgb2gray(vidFrames(:,:,:,t)));
    [fg, bg, GMM] = RunGMM(frame,GMM);
    figure
    subplot(2,3,1), imshow(uint8(frame)), title(['Frame ', num2str(t)])
    subplot(2,3,2), imshow(uint8(bg)), title('BG')
    subplot(2,3,3), imshow(uint8(fg)), title('FG')
end

