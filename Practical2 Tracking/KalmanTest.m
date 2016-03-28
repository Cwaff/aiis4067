clear all, close all

pathname=['./Fernando/'];

%Load Background image
Bkg=imread([pathname 'fondo.bmp']);

%Loop to go through the sequence
frame_ini=5;
frame_fin=88;
frames=frame_ini:frame_fin;
for t=frame_ini:frame_fin
    
    %Current frame is loaded
    filename=['fer' num2str(t) '.bmp'];
    currentFrame= imread([pathname filename]);
    
    %we display the Current frame is a figure
    figure(1)
    subplot(1,3,1), imshow(currentFrame), title(['Frame: ', num2str(t)]), hold on
    
    %Background substraction
    Blobs=abs(double(rgb2gray(currentFrame))-double(rgb2gray(Bkg)))>30;
    
    %Postprocessing using morphological operator
    BlobsCorrect=imdilate(Blobs,ones(3));
    BlobsCorrect=imerode(BlobsCorrect,ones(3));
    
    %Labelling using connectedcomponent algorithm
    BlobsLabel=bwlabel(BlobsCorrect,8);
    
    %we display the results from motion detection is a figure
    subplot(1,3,2), imshow(BlobsLabel), title('Detections+Tracker'), hold on
    
    %We count the number of motion blobs detected
    NumCandidates= max(max(BlobsLabel));
    
    %For each detected blob, we extract its bounding box
    Candidates = [];
    for b = 1: NumCandidates

        [ys xs]=find(BlobsLabel == b);

        xmax=max(xs);
        ymax=max(ys);
        xmin=min(xs);
        ymin=min(ys);

        BB = [xmin ymin xmax ymax];
        Candidates = [Candidates; BB];
        %Bounding boxes are drawn in green on teh top of the motion
        %detection figure
        h = rectangle('Position', [Candidates(b,1) Candidates(b,2) Candidates(b,3)-Candidates(b,1)+1 Candidates(b,4)-Candidates(b,2)+1])
        set(h, 'EdgeColor','g','LineWidth',2);
    end 
    

    
    %At the first frame, the Kalman filter is initialised
    if t==frame_ini
        
       % Initialise Kalman filter parameters using the largest available
       % blob in the first image
       
       
       %///////// TO BE COMPLETED (STEP 4) \\\\\\\\\\\%
       
       %calculate area of each candidate and store largest value and id for
       %later
       maxValue = 0;
       id = 0;
       
       for i =1:NumCandidates
           x = Candidates(i,3) - Candidates(i,1);
           y = Candidates(i,4) - Candidates(i,2);
           area = x*y;
            if(area > maxValue)
                maxValue = area;
                id = i;
            end
       end
         
        middlePointX= (Candidates(id,1) + Candidates(id,3))/2;
        middlePointY= (Candidates(id,2) + Candidates(id,4))/2;
        width= Candidates(i,3) - Candidates(i,1);
        height= Candidates(i,4) - Candidates(i,2);

       
        %%% Kalman parameters%%%
        % state vector 4x1
        
        x1_ini = [middlePointX;middlePointY;0;0]    %///////// TO BE COMPLETED (STEP 5) \\\\\\\\\\\%
        
        % measurement noise covariance
        R_ini=[100 0;...
               0 100];
        dt=1; % speed measure in pixels per frame
        % Prediction matrix (dynamics) 4x4
        
        %///////// TO BE COMPLETED (STEP 6) \\\\\\\\\\\%
        D=eye(4)
        D(1,3) = dt;
        D(2,4) = dt;
        
        % initial state vovariance (initially always a high value)
        C_ini=[100 0 0 0;...
               0 100 0 0;...
               0 0 100 0;...
               0 0 0 100];
        % Process noise covariance (linear acceleration noise)
        Q_ini=[dt^4/4    0     dt^3/2    0  ;...
                 0     dt^4/4     0   dt^3/2;...
               dt^3/2    0      dt^2     0  ;...
                 0     dt^3/2     0    dt^2];
        % Observation matrix
        H_ini=[1 0 0 0;...
               0 1 0 0];
       
        
        
        % Kalman filter initialization using previous parameters
        K1 = GeneraKalman(x1_ini,C_ini,Q_ini,R_ini,D,H_ini);
    else
        %if it is not the first frame, we will perform the cicle
        %predition/correction
        
        %We display the final estimation from the previous frame in red
        h = rectangle('Position', [K1.x(1)-width/2 K1.x(2)-height/2 width height])
        set(h, 'EdgeColor','r','LineWidth',3);
        
        %%% Kalman Prediction %%%
        
        %///////// TO BE COMPLETED (STEP 8) \\\\\\\\\\\%
        K1 = KalmanPrediction(K1)
        
        %We display the prediction in yellow
        
        %///////// TO BE COMPLETED (STEP 8) \\\\\\\\\\\%
        h = rectangle('Position', [K1.x(1)-width/2 K1.x(2)-height/2 width height])
        set(h, 'EdgeColor','y','LineWidth',3);                
        
        %%% Assotiation Between the Prediction and the possible candidates %%%        
        if NumCandidates>0
           
            %Select the measurement as closest blob to the filter's prediction and put it in a vector in the suitable form 
            
            
            %///////// TO BE COMPLETED (STEP 9) \\\\\\\\\\\%
            minDist = 1000000;
            measurement = [0;0];
            for i = 1:NumCandidates
                centroid = [(Candidates(i,1)+Candidates(i,3))/2;(Candidates(i,2)+Candidates(i,4))/2]
                distance = sqrt((centroid(1) - K1.x_pred(1))^2 + (centroid(2) - K1.x_pred(2))^2)
                if distance < minDist
                    minDist = distance;
                    measurement = centroid;
                end
            end
            
            
            %%% Kalman Estimation %%%
            %///////// TO BE COMPLETED (STEP 10) \\\\\\\\\\\%
            K1 = KalmanEstimation(K1,measurement);
        else
            %%% Kalman Estimation %%%
            %///////// TO BE COMPLETED (STEP 10) \\\\\\\\\\\%
            K1 = KalmanEstimation(K1);
        end
    end
    
    %We display the final estimation in this frame in red in a new figure
    subplot(1,3,3), imshow(currentFrame), title('\Final Estimation'), hold on
    
    h = rectangle('Position', [K1.x(1)-width/2 K1.x(2)-height/2 width height])
    set(h, 'EdgeColor','r','LineWidth',3); hold off
    
    subplot(1,3,1), hold off
    subplot(1,3,2), hold off
    
    pause
    
end
