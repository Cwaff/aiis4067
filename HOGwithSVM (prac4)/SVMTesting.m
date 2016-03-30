function [prediction maxi]= SVMTesting(image,model)

if strcmp(model.type,'binary')
   
    %pred = svmclassify(model, image)
    kerneloption.matrix=svmkernel(image,'gaussian',model.param.sigmakernel,model.xsup);
    pred = svmval(image,model.xsup,model.w,model.w0,model.param.kernel,kerneloption);
    if pred>0
        prediction = 1;
    else
        prediction = 0;
    end
    maxi= 0;
else
    
   [pred,NegLoss,Pb] = predict(model.classifier,image);
    
    maxi=max(Pb);

     prediction = round(pred)-1;
    
end
    
end