
function objectsOP = simpleNMS(objects,threshold)

if isempty(objects)
  objectsOP = objects;
  return;
end

%get the corners of the bounding boxes and their confidence values
x1 = objects(:,1)
y1 = objects(:,2)
x2 = x1 + objects(:,3)
y2 = y1 + objects(:,4)
confidence = objects(:,5)

%calculate the area of the bounding boxes
bBoxArea = (objects(:,3)+1) .* (objects(:,4)+1);

%sort the confidence values
[~, orderedConf] = sort(confidence);

%create variable to store the indices of the choosen boxes
maxObjectIndices = zeros(size(confidence));

i = 1;
% for each confidence
while ~isempty(orderedConf)
  
  % take index of highest confidence assign to max object
  last = length(orderedConf);
  highestConf = orderedConf(last);  
  maxObjectIndices(i) = highestConf;
  i = i + 1;
  
  % create box with max corner values of current highest and next highest confidence
  % boxes
  xx1 = max(x1(highestConf), x1(orderedConf(1:last-1)));
  yy1 = max(y1(highestConf), y1(orderedConf(1:last-1)));
  xx2 = min(x2(highestConf), x2(orderedConf(1:last-1)));
  yy2 = min(y2(highestConf), y2(orderedConf(1:last-1)));
  
  w = max(0.0, xx2-xx1+1);
  h = max(0.0, yy2-yy1+1);
  
  % calculate the overlap between the created box and the max confidence box
  overlap = w.*h ./ bBoxArea(orderedConf(1:last-1))
  
  % if objects overlap by more than threshold, remove one with lowest
  % confidence
  orderedConf([last; find(overlap>threshold)]) = [];
end

% return maximum objects (Non-maxima suppression)
maxObjectIndices = maxObjectIndices(1:(i-1));
objectsOP = objects(maxObjectIndices,:);

end