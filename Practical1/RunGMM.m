function [Foreground, Background, GMM] = RunGMM(currentFrameGray,GMM)

height=size(currentFrameGray,1);
width=size(currentFrameGray,2);

Foreground = zeros(height, width);
Background = zeros(height, width);


  NGauss = size(GMM.mean,3);
    u_diff = zeros(height,width,NGauss); % difference of each pixel from mean
    % calculate difference of pixel values from mean
    for m=1:NGauss
        u_diff(:,:,m) = abs(currentFrameGray - GMM.mean(:,:,m));
    end

    % update gaussian components for each pixel
    for i=1:height
        for j=1:width

            match = 0;
            for k=1:NGauss 
                
                if (belong2Gauss(u_diff(i,j,k), GMM.sd(i,j,k), GMM.param.D)) % pixel matches component

                    match = 1; % variable to signal component match

                  [GMM.w(i,j,k), GMM.mean(i,j,k), GMM.sd(i,j,k)]= UpdateGMM(GMM.w(i,j,k), GMM.mean(i,j,k), GMM.sd(i,j,k), GMM.param.alpha, currentFrameGray(i,j));

                else % pixel doesn't match component
                    [GMM.w(i,j,k), GMM.mean(i,j,k), GMM.sd(i,j,k)]= UpdateGMM(GMM.w(i,j,k), GMM.mean(i,j,k), GMM.sd(i,j,k), GMM.param.alpha);

                end
            end

            GMM.w(i,j,:) = GMM.w(i,j,:)./sum(GMM.w(i,j,:));

            %Use the backgroung gaussians to reconstruct the background
            %image
            Background(i,j)=0;
            for k=1:NGauss
                Background(i,j) = Background(i,j)+ GMM.mean(i,j,k)*GMM.w(i,j,k);
            end

            % if no components match, create new component
            if (match == 0)
                [min_w, min_w_index] = min(GMM.w(i,j,:)); 
                GMM.mean(i,j,min_w_index) = currentFrameGray(i,j);
                GMM.sd(i,j,min_w_index) = GMM.param.sd_init;
            end

            GMM.rank = GMM.w(i,j,:)./GMM.sd(i,j,:); % calculate component rank
            rank_ind = [1:1:NGauss];

            % sort rank values
            for k=2:NGauss 
                for m=1:(k-1)

                    if (GMM.rank(:,:,k) > GMM.rank(:,:,m)) 
                        % swap max values
                        rank_temp = GMM.rank(:,:,m); 
                        GMM.rank(:,:,m) = GMM.rank(:,:,k);
                        GMM.rank(:,:,k) = rank_temp;

                        % swap max index values
                        rank_ind_temp = rank_ind(m); 
                        rank_ind(m) = rank_ind(k);
                        rank_ind(k) = rank_ind_temp; 

                    end
                end
            end

            % calculate foreground
            match = 0;
            k=1;

            Foreground(i,j) = 0;
            while ((match == 0)&&(k<=GMM.param.M))

                if (GMM.w(i,j,rank_ind(k)) >= GMM.param.thresh)
                    if (belong2Gauss(u_diff(i,j,rank_ind(k)), GMM.sd(i,j,rank_ind(k)), GMM.param.D))
                        Foreground(i,j) = 0;
                        match = 1;
                    else
                        Foreground(i,j) = currentFrameGray(i,j); 
                    end
                end
                k = k+1;
            end
        end
    end


end