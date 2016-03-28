function K = KalmanPredictionSolution (K)

% PREDICTIoN
% State
K.x_pred = K.D * K.x
% Covariance
K.C_pred = K.D*K.C*K.D.'+K.Q
