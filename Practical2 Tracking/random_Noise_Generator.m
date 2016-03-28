function w = random_Noise_Generator(N, dt)
%
% Aceleration noise model
%

% mecánica de movimiento aleatoria
% ruido de estado
%q=9;	%Aceleracion (pixels/t^2) al cuadrado
% covarianza ruido de estado (ec. de libro que está en los apuntes)
%Q=[dt^4/4 0 dt^3/2 0;0 dt^4/4 0 dt^3/2;dt^3/2 0 dt^2 0;0 dt^3/2 0 dt^2]*q; 
qx = 9;	%Aceleracion (pixels/t^2) al cuadrado
qy = 9;	%Aceleracion (pixels/t^2) al cuadrado
qr = 9;	%Aceleracion (pixels/t^2) al cuadrado
Qx = [dt^4/4 dt^3/2;dt^3/2 dt^2]*qx; 
Qy = [dt^4/4 dt^3/2;dt^3/2 dt^2]*qy; 
Qr = [dt^4/4 dt^3/2;dt^3/2 dt^2]*qr; 

% estado
%x = [x y xp yp r rp]; % posición en x, posición en y, veloc. en x, veloc. en y, radio, veloc. radio

w = zeros(8, N);
sigma = qx*dt^4/4;
w(1,:) = rsample(N, sigma)';
sigma = qy*dt^4/4;
w(2,:) = rsample(N, sigma)';
sigma = qx*dt^2;
w(3,:) = rsample(N, sigma)';
sigma = qy*dt^2;
w(4,:) = rsample(N, sigma)';
sigma = qr*dt^4/4;
w(5,:) = rsample(N, sigma)';
w(6,:) = rsample(N, sigma)';
sigma = qr*dt^2;
w(7,:) = rsample(N, sigma)';
w(8,:) = rsample(N, sigma)';


