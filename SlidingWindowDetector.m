function SlidingWindowDetector(im,model,wSize)
%{
% Source - http://thebrainiac1.blogspot.co.uk/2012/07/v-behaviorurldefaultvmlo.html
this function will take three parameters
    1.  im      --> Test Image
    2.  model   --> trained model
    3.  wStize  --> Size of the window, i.e. [24,32]
and draw rectangle on best estimated window
%}

topLeftRow = 1;
topLeftCol = 1;

%Used for setting the rate in which the box traverses the picture
xStep = 30;
yStep = 60;

[bottomRightCol, bottomRightRow, d] = size(im);

fcount = 1;

% this for loop scan the entire image and extract features for each sliding window
for y = topLeftCol:yStep:bottomRightCol-wSize(2)   
    for x = topLeftRow:xStep:bottomRightRow-wSize(1)
        p1 = [x,y];
        p2 = [x+(wSize(1)-1), y+(wSize(2)-1)];
        po = [p1; p2];
        img = imcut(po,im);     
        featureVector{fcount} = HOG(double(img));
        boxPoint{fcount} = [x,y];
        fcount = fcount+1;
        %x = x+1; Doesnt do anything
    end
end

lebel = ones(length(featureVector),1);
P = cell2mat(featureVector);
% each row of P' correspond to a window
[~, predictions] = svmclassify(P',lebel,model); % classifying each window

[a, indx]= max(predictions);
bBox = cell2mat(boxPoint(indx));
rectangle('Position',[bBox(1),bBox(2),24,32],'LineWidth',1, 'EdgeColor','r');
end
