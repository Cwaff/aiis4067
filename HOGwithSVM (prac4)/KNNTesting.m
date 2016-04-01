function prediction = KNNTesting(testImage, modelNN, K)
    minValues = zeros(K,1)+10000;
    minIndexes = ones(K,1);
    for i=1:size(modelNN.neighbours,1)
       dEuc = EuclideanDistance(testImage,modelNN.neighbours(i,:)); 
       for j=1:K 
           if dEuc < minValues(j)
                minValues(j) = dEuc;
                minIndexes(j) = i;
           end
       end
    end
    prediction = modelNN.labels(mode(minIndexes));
end