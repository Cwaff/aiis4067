function []=showHog(feature,rsize)


blocksPerColumn=rsize(1)/8-1;
blocksPerRow=rsize(2)/8-1;

% construct a "glyph" for each orientaion
bs=20;
bim1 = zeros(bs, bs);
bim1(:,round(bs/2):round(bs/2)+1) = 255;
bim = zeros([size(bim1) 9]);
bim(:,:,1) = bim1;
for i = 2:9,
    bim(:,:,i) = imrotate(bim1, -(i-1)*20, 'crop');
end

totalIm=zeros(2*bs*blocksPerColumn,2*bs*blocksPerRow);
counter=0;
for i=1:36:length(feature)
    
    histBlock= feature(i:i+35);
    
    imBlock=zeros(2*bs,2*bs);
    % a block is composed of 4 cells
    for j=1:4
        % for each cell, we can caluclate the composed "glyph" according to teh hitogram of orientations
        w=histBlock(j:j+8);
        
        w(w < 0) = 0;
        im = zeros(bs, bs);
        for k = 1:9,
            im = im + bim(:,:,k) * w(k);
        end
        
        %compose the image of the block
        row=floor((j-1)/2)+1;
        column=mod(j-1,2)+1;
        
        imBlock((row-1)*bs+1: row*bs, (column-1)*bs+1: column*bs) = im;
    end
    counter=counter+1;
    %compose the full image
    row=floor((counter-1)/blocksPerRow)+1;
    column=mod(counter-1,blocksPerRow)+1;
    totalim((row-1)*2*bs+1: row*2*bs, (column-1)*2*bs+1: column*2*bs) = imBlock;
    
    
    
end

scale = max(feature);
totalim = totalim / scale;

imagesc(totalim), colormap(gray)


end