function [Iss] = subcolor(I, p)
%
% function [Iss] = subcolor(I, p)
%
% obtiene una imagen submuestreada de la imagen I
%
% -----------------------------------------------------------------------------------
% I3A Universidad de Zaragoza
% Carlos Orrite
% 10/1/2003
% Versión: 1.0
% -----------------------------------------------------------------------------------

Is =zeros(size(I));

[a,b,c]=size(I);

Is = ones(a,b,c);
if p==1 % el mas significativo
   Is = uint8(Is*128);
elseif p==2 % los dos mas significativos
   Is = uint8(Is*(128+64));
elseif p==3
   Is = uint8(Is*(128+64+32));
elseif p==4
   Is = uint8(Is*(128+64+32+16));
elseif p==5
   Is = uint8(Is*(128+64+32+16+8));
elseif p==6
   Is = uint8(Is*(128+64+32+16+8+4));
elseif p==7
   Is = uint8(Is*(128+64+32+16+8+4+2));
else
   Is = uint8(Is*(128+64+32+16+8+4+2+1));
end
 

Iss = bitand(I,Is);

