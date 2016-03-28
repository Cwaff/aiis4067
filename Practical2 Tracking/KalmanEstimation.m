function K = KalmanEstimationSolution (K,measurement)

% ESTIMATION
% Gain
K.G = K.C_pred*K.H.'/(K.H*K.C_pred*K.H.'+ K.R)
% State update
if nargin<2
   K.x = K.x_pred;
   K.C = K.C_pred;
else
   K.x = K.x_pred + K.G*(measurement - K.H*K.x_pred)
   % Covariance
	K.C = K.C_pred*(eye(4) - K.G*K.H)
end

