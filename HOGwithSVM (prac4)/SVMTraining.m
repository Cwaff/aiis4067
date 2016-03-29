function model = SVMTraining(images, labels)


% first we check if the problem is binary classification or multiclass
if max(labels)<2
    %binary classification
    
    %SVM software requires labels -1 or 1 for the binary problem
    labels(labels==0)=-1;

    %Initilaise and setup SVM parameters
    lambda = 1e-20;  
    C = Inf;
    sigmakernel=10;
	kernel='rbf';
        
   % Calculate the support vectors
    model = svmtrain(images, labels, 'kernel_function',kernel,'rbf_sigma',sigmakernel,'boxconstraint',C, 'autoscale',0)

    % create a structure encapsulating all teh variables composing the model
    model.xsup = model.SupportVectors;

    model.param.sigmakernel=sigmakernel;
    model.param.kernel=kernel;
   
    model.type='binary';
    
else
    %multiple class classification
    
    %SVM software requires labels from 1 to N for the multi-class problem
    labels = labels+1;
    nbclass=max(labels);
    
    %Initilaise and setup SVM parameters
    lambda = 1e-20;  
    C = Inf;
    kernel='rbf';
    
    T=templateSVM('Standardize',1,'Boxconstraint',C) ;
    % Calculate the support vectors
    classifier = fitcecoc(images,labels,'Learners', T);
    
    model.classifier = classifier;
    model.type='multiclass';
    
end

    
    
end