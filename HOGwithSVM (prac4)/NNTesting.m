function prediction = NNTesting(testImage, modelNN)
    minValue = 10000;
    minIndex = 1;
    for i=1:size(modelNN.neighbours,1)
       dEuc = EuclideanDistance(testImage,modelNN.neighbours(i,:)); 
        if dEuc < minValue
            minValue = dEuc;
            minIndex = i;
        end
    end
    prediction = modelNN.labels(minIndex);
end