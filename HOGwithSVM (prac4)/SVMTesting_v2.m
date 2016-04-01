function [prediction maxi]= SVMTesting(image,model)

if strcmp(model.type,'binary')
   
    pred = svmclassify(model, image);
   %{
    if pred>0
        prediction = 1;
    else
        prediction = 0;
    end
    %}
   [pred,NegLoss,Pb] = predict(model.classifier,image);
    
    maxi=max(Pb);

     prediction = round(pred);
    
end
    
end