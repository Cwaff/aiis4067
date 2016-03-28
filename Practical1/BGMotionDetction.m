clear all
close all

file_name = 'viptraffic.avi';
videoObj = VideoReader(file_name);

vidFrames = read(videoObj);

% (x,y,colour channels,frames)
bkg = vidFrames(:,:,:,120);
%figure, imshow(bkg)

% using rgb2gray
BkgGray = rgb2gray(bkg);
%figure, imshow(BkgGray)

% using maths
BkgGray2 = bkg(:,:,1)/3 + bkg(:,:,2)/3 + bkg(:,:,3)/3 ;

%figure
%subplot(1,3,1), imshow(bkg), title('colour')
%subplot(1,3,2), imshow(BkgGray), title('gray bkg')
%subplot(1,3,3), imshow(BkgGray2), title('gray approx bkg')

%figure
for t = 1:120
    currentFrame = vidFrames(:,:,:,t);
end



vidObj2 = VideoWriter('resultTraffic.avi');
open(vidObj2);
MAP = colormap(gray(256));

BkgGrayD = bckGenerator(vidFrames, 1);%double(BkgGray);

th = 54;
figure
for t = 1:120
    currentFrame = vidFrames(:,:,:,t);
    currentFrameGray = rgb2gray(currentFrame);
    Blobs = abs(currentFrameGray - BkgGray) > th;
    subplot(3,3,1), imshow(currentFrameGray), title(['Frame: ', num2str(t)])
    subplot(3,3,2), imshow(BkgGray), title('Background')
    subplot(3,3,3), imshow(Blobs), title('Blobs'), colormap(gray)
   
    currentFrameGrayD = double(currentFrameGray);
    BlobsD = abs(currentFrameGrayD - BkgGrayD) > th;
    subplot(3,3,4), imshow(BlobsD), title('Blobs Doubled')
   
    correctedBlobs = BlobsD;
    correctedBlobs = imclose(correctedBlobs,ones(9,9));
    correctedBlobs = imopen(correctedBlobs,ones(5,5));
    subplot(3,3,5), imshow(correctedBlobs), title('correctBlobs'), colormap(gray)
    
    blobslabel = bwlabel(correctedBlobs);
    subplot(3,3,6), imshow(blobslabel), title('labelling'), colormap(gray)
    
    numVehicles = max(max(blobslabel));
    
    
    BBs = [];
    for b = 1: numVehicles
        [ys xs] = find(blobslabel == b);
        xmax = max(xs);
        ymax = max(ys);
        xmin = min(xs);
        ymin = min(ys);

        BB = [xmin, ymin, xmax, ymax];
        BBs = [BBs; BB];
    end
    
    subplot(3,3,7), imshow(currentFrame), title('Detections'), hold on
    for b = 1: numVehicles
        rectangle('Position', [BBs(b,1) BBs(b,2) BBs(b,3)-BBs(b,1) BBs(b,4)-BBs(b,2)])
    end
    hold off
    
    pause(0.1)
    
    frame = im2frame(uint8(BlobsD)*255,MAP);
    writeVideo(vidObj2, frame);
end

close(vidObj2);


