function []=ShowHaarCasade(HaarCasade,stage)

if nargin==1
    %If there is only one parameter, the user wishes to watch all the masks
    %for all the stages
    stages=1:length(HaarCasade.stages);
else
    %If there is only a second parameter, the user wishes to watch all the masks
    %for only that given stage
    stages=stage;
end

% for every stage to visualise
for s=stages
    figure
    colormap(gray)
    
    %array containing all the masks for that stage
    Trees=HaarCasade.stages(s).trees;
    %knowing how many masks in that stage (length(Trees)), we can organise
    %them into several rows for better visualisation
    cols=floor(sqrt(length(Trees)));
    rows =ceil(length(Trees)/cols);

    % for every mask
    for t=1:length(Trees)
        
        Leaf=Trees(t).value;
        %empty image where we will plot the mask
        LeafImage=zeros(1);
        % a mask is composed by a maximum of 3 rectangles
        for i_Rectangle = 1:3
            %each rectangle (balck or white) has 5 elements (x and y position,
            %width, height and if its positive (white) or negative (black))
            Rectangle = Leaf(:,(1:5)+i_Rectangle*5);
            %x position of the upper right corner
            RectX = 1+floor(Rectangle(:,1));
            %y position of the upper right corner
            RectY = 1+floor(Rectangle(:,2));
            %width
            RectWidth = floor(Rectangle(:,3));
            %height
            RectHeight = floor(Rectangle(:,4));
            %weight: if its positive (white) or negative (black)
            RectWeight = Rectangle(:,5);
            
            %with all these parameters we can compose the mask over the
            %empty image LeafImage
            %////////// To be completed at step 1\\\\\\\\\\\
            if(RectWeight == 1)
               
            else
                
            end

            
            
            
            
            
            
        end
        % plot the mask
        subplot(rows,cols,t), imagesc(LeafImage), axis off
    end
end

end



