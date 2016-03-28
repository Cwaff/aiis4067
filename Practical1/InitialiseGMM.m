function GMM = InitialiseGMM(height, width)

% --------------------- mog variables -----------------------------------

C = 3; % number of gaussian components (typically 3-5)
M = 3; % number of background components
D = 2.5; % positive deviation threshold
alpha = 0.01; % learning rate (between 0 and 1) (from paper 0.01)
thresh = 0.25; % foreground threshold (0.25 or 0.75 in paper)
sd_init = 6; % initial standard deviation (for new components) var = 36 in paper

w = zeros(height,width,C); % initialize weights array
mean = zeros(height,width,C); % pixel means
sd = zeros(height,width,C); % pixel standard deviations

rank = zeros(1,C); % rank of components (w/sd)

GMM.param.C = C;
GMM.param.M = M;
GMM.param.D = D;
GMM.param.alpha = alpha;
GMM.param.thresh = thresh;

GMM.param.sd_init = sd_init;


% --------------------- initialize component means and weights -----------

pixel_depth = 8; % 8-bit resolution
pixel_range = 2^pixel_depth -1; % pixel range (# of possible values)

for i=1:height
    for j=1:width
        for k=1:C

            mean(i,j,k) = rand*pixel_range; % means random (0-255)
            w(i,j,k) = 1/C; % weights uniformly dist
            sd(i,j,k) = sd_init; % initialize to sd_init

        end
    end
end

GMM.mean = mean;
GMM.w = w;
GMM.sd = sd;

GMM.rank = rank;

end