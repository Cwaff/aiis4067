%
% GrayWorldFun.m
%
% Function to implement GrayWorld color balance algorithm
%
% Hui Li
% 3/7/2000
%	

function II = GrayWorldFun_mio(I)


I = double(I)./256;
% Read into RGB
inR = I(:,:,1);
inG = I(:,:,2);
inB = I(:,:,3);


% Monitor Inverse Gamma correction already done for input images

avgR = mean(mean(inR));
avgG = mean(mean(inG));
avgB = mean(mean(inB));
avgGray = (avgR + avgG + avgB)/3;

% Average R, G, B value
if avgR == 0
	outR = inR;
else
	outR = (avgGray/avgR).*inR;
end

if avgG == 0
	outG = inG;
else
	outG = (avgGray/avgG).*inG;
end

if avgB == 0
	outB = inB;
else
	outB = (avgGray/avgB).*inB;
end


% Scale output
maxRGB = [max(max(outR)) max(max(outG)) max(max(outG))];

factor = max(maxRGB);
if  factor > 1
	outR = outR./factor;
	outG = outG./factor;
	outB = outB./factor;
end


% Camera Gamma Correction


II(:,:,1) = outR;
II(:,:,2) = outG;
II(:,:,3) = outB;

II=uint8(II*256);