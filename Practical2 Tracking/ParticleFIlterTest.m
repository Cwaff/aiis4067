clear all
close all

%Load video
file_name = 'juanjo.avi';
videoObj=VideoReader(file_name);
vidFrames = read(videoObj);

%load first image to initialise the PF
imageIni = vidFrames(:,:,:,1);

figure(1)
bits = 8; % Image subsampling to reduce the graylevel quantisation to fewer bits per channel (8 default value-> not doing subsampling)
I=subcolor(imageIni,bits);

imagesc(I), colormap('default'), axis('image'),  str = ['Selecct bounding box to track']; title(str);
hold

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INICIALIZATION: initial state vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Littel piece of code that allow you to select the are to follow by
% clicking the upper-left and lower-right corners of a bounding-box

%upper-left corner
[x,y,BUTTON]=ginput(1);
%lower-right corner
[xx,yy,BUTTON]=ginput(1);

if BUTTON==1
        %BB Corners in pixels
        x1 = round(x); y1=round(y);, 	x2 = round(xx); y2=round(yy);
        %centroid of BB
        centroid_x1=(x1+x2)/2;,  centroid_y1=(y1+y2)/2;
        %BB width and height (halfs)
        width_radious=abs(x2-x1)/2;,  height_radious=abs(y2-y1)/2;
        %plot the BB
        rectan=rectangle('Curvature', [0 0], 'position', [centroid_x1-width_radious centroid_y1-height_radious 2*width_radious 2*height_radious]);
        set(rectan, 'edgecolor','c');

        stateIni = [centroid_x1, centroid_y1, 0, 0, width_radious,height_radious, 0,0];
end

%Dynamic model to apply (Prediction matrix)
dt = 1;

D=[1 0 dt 0 0 0 0 0;...
   0 1 0 dt 0 0 0 0;...
   0 0 1 0 0 0 0 0;...
   0 0 0 1 0 0 0 0;...
   0 0 0 0 1 0 0 0;...
   0 0 0 0 0 1 0 0;...
   0 0 0 0 0 0 1 0;...
   0 0 0 0 0 0 0 1];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INICIALIZATION: initial colour model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose colour space
colour_space='HSV';
%colour_space='RGB';
colour_channels=3;
if colour_space=='HSV'
    I=rgb2hsv(imageIni);
    I=round(I*255);
elseif colour_space=='YBR'
    I=rgb2ycbcr(imagen);
end

I=subcolor(uint8(I),bits);

%Extract colour histogram of the selected BB
colourHistogram(1,:,:)=obtaining_histogram(I,stateIni, colour_channels);

% Open a new figure and visualise the 3 channels of the colour histogram

%///////////To be Completed as Step 4\\\\\\\\\\\\\\\\\\\\







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INICIALIZATION: initialise particles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Number of particles to be used
N = 200;

% S will be the matrix conatining the particles, one in each row
S = zeros(N,size(stateIni,2));
% weights is an array conatining the weight for each particle. 
%Initially all teh particles have the same weight: 1/N
weights = ones(N,1)/N;

%Particles are distributed randomly around the initial state, and withinh a
%maximum spread area
spreadArea=20;
x1 = stateIni(1, 1);,   y1 = stateIni(1, 2);
rx = stateIni(1, 5);,   ry = stateIni(1, 6);

%Generates a random deviation from the initial state for each particle
randomValues = rand(2,N);
% we calculate the position of eahc particle applying teh random deviation
% and the maximum spread area
X1 = round(x1-spreadArea/2 + randomValues(1,:)* spreadArea);
Y1 = round(y1-spreadArea/2 + randomValues(2,:)* spreadArea);
for i=1 : N
    % All poarticles are concatenated into the matrix S. Please note that
    % each particle has in fact teh sme format that the state vector
     S(i,:) = [X1(i), Y1(i), 0, 0, rx,ry, 0,0];
     % Draw the particle position
     plot(X1(i), Y1(i), 'b+');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END    INICIALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure,imagesc(I), colormap('default'), hold on
hold

for t=2: dt: size(vidFrames,4)
    
    %Read current frame
    currentFrame = vidFrames(:,:,:,t);

    imagesc(currentFrame), colormap('default'), axis('image'), axis('ij'); str = ['Frame ', num2str(t)]; title(str);
    hold on
    
    if colour_space=='HSV'
        I=rgb2hsv(currentFrame);
        I=round(I*255);
    elseif colour_space=='YBR'
        I=rgb2ycbcr(currentFrame);
    end

   I=subcolor(uint8(I),bits); 
   
    %Particle Filter function: It will predict and evolve the particles
    %according to the observation in frame I
    [S, weights] = condensation(N, S, weights, I,1, colourHistogram(1,:,:),D, colour_channels);
    SS(1,:,:)=S';
    
    %calculate the new state
    state = new_State(SS, weights);
    statesSequence(t,:)=state;
   
    % Draw the particles: blue are very good, cyan are good, magenta are not bad, yello are bad
    maxWeight=max(weights);
    for n=1 : N
       if weights(n)<0.1*maxWeight
            plot(SS(1,1,n), SS(1,2,n), 'y*');
       elseif weights(n)<0.5*maxWeight
            plot(SS(1,1,n), SS(1,2,n), 'm*');
       elseif weights(n)<0.9*maxWeight
            plot(SS(1,1,n), SS(1,2,n), 'c*');
       else
            plot(SS(1,1,n), SS(1,2,n), 'b*');
       end
    end
    
    %Draw new estimated average position (state vector)
    x = state(1,1); y = state(1,2); rx = state(1,5);,ry = state(1,6);
    rectan=rectangle('Curvature', [0 0], 'position', [x-rx y-ry 2*rx 2*ry]);
    set(rectan, 'edgecolor','r','LineWidth',3);
       
    title(['x=',num2str(x),'y=',num2str(y),'vx=',num2str(state(1,3)),'vy=',num2str(state(1,4)),])
    
   
    
    
    drawnow
    %pause
    hold off
end