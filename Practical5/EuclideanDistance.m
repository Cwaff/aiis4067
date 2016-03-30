function dEuc = EuclideanDistance(sample1, sample2)
    size(sample1)
    size(sample2)
    temp = sample1 - sample2;
    temp = temp.^2;
    dEuc = sqrt(sum(temp(:)));
end