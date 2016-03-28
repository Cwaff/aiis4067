function [p]=obtaining_histogram(II,state, colour_channels)

for c=1:colour_channels
    p(1,:,c)=zeros(1,256);
end

if nargin==2
[c1 f1]=ginput(1)
[c2 f2]=ginput(1)
else
    c1=state(1)-state(5);
    c2=state(1)+state(5);
    f1=state(2)-state(6);
    f2=state(2)+state(6);
end

for i=round(c1):round(c2)
    for j=round(f1):round(f2)

        if (i>0)&(i<=(size(II,2)))&(j>0)&(j<=(size(II,1)))
            
            for c=1:colour_channels
                u=II(j,i,c);
                p(1,u+1,c) = p(1,u+1,c)+1;
            end
       
        end
    end
end


for c=1:colour_channels
    if sum(p(1,:,c))>0
        p(1,:,c)=p(1,:,c)/sum(p(1,:,c));
    end
end

end
