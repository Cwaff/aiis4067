function [w,mean,sd] = UpdateGMM(w, mean, sd, alpha, pixval)
    if nargin < 5
        w = (1-alpha)*w;
        mean = mean;
        sd = sd;
    else
        w = (1-alpha) * w + alpha;
        mean = (1-(alpha/w))*mean + (alpha/w) * pixval
        sd = sqrt((1-(alpha/w))*power(sd,2)+(alpha/w)*power((pixval-mean),2))
    end
end