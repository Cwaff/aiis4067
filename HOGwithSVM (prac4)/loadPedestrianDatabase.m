function [images, labels] = loadPedestrianDatabase(filename, sampling)

if nargin<2
    sampling =1;
end


fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);


line1=fgetl(fp);
line2=fgetl(fp);

numberOfImages = fscanf(fp,'%d',1);

images=[];
labels =[];
for im=1:sampling:numberOfImages
    
    label = fscanf(fp,'%d',1);
    
    labels= [labels; label];
    
    imfile = fscanf(fp,'%s',1);
    I=imread(imfile);
    if size(I,3)>1
        I=rgb2gray(I);
   end
    vector = reshape(I,1, size(I, 1) * size(I, 2));
    vector = double(vector); % / 255;
    
    images= [images; vector];
    
end

fclose(fp);

end