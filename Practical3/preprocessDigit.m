function outIm =preprocessDigit(inputIm)


binary= inputIm>0.5;

[r c] =find(binary);

middlex=round(mean(c));
middley=round(mean(r));

outIm =zeros(size(inputIm));

diffx=size(inputIm,2)/2-middlex;
diffy=size(inputIm,1)/2-middley;

if diffx>0

    outIm(:,1:28)=[zeros(size(inputIm,1),abs(diffx)) inputIm(:,1:end-abs(diffx))];
else
    outIm(:,1:28)=[inputIm(:,abs(diffx)+1:end) zeros(size(inputIm,1),abs(diffx)) ];
end

if diffy>0
    outIm(1:28,:)=[zeros(abs(diffy),size(outIm,2));  outIm(1:end-abs(diffy),:)];
else
    outIm(1:28,:)=[outIm(abs(diffy)+1:end,:); zeros(abs(diffy),size(outIm,2)) ];
end

end