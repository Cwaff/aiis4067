function [topBoxes] = simpleNMS(boxes,threshold)
%Simple NMS 
%for every detected_bounding_box:
%    calculate the intersection_area with any other detected_bounding_box
%   if (intersection_area / bounding_box_area ) is > threshold
%   remove one of the intersecting bounding box (the one with smaller confidence)
%    end
%end

topBoxesTemp = [];

for i = 1:size(boxes)
    
    %Grab position vector data for first vector
    aX = boxes(i,1);
    aY = boxes(i,2);
    aH = boxes(i,3);
    aW = boxes(i,4);
    
    A = [aX,aY,aH,aW];
    
    for j = i+1:size(boxes)
        %Grab position vector data for second vector
        bX = boxes(j,1);
        bY = boxes(j,2);
        bH = boxes(j,3);
        bW = boxes(j,4);
    
        B = [bX,bY,bH,bW];
        
        %Calculate intersection
        area = rectInt(A,B);
        
        
    
    
    
    end



end

