function newmeans = kmclust(x,no_clust)
tic;
sizevar = size(x);
no_rows = sizevar(1);
dimension = sizevar(2);
randpts = floor(1+(no_rows-1)*rand(no_clust,1));
newmeans = x(randpts,:);
%newmeans
indexcol = zeros(no_rows,1);
for currow = 1:no_rows
    threshold = 10^10;
    for curmean = 1:no_clust
        sqdist = 0;
        for curdim = 1:dimension
            sqdist = sqdist + ((x(currow,curdim)-newmeans(curmean,curdim))^2);
        end
        if (sqdist<=threshold)
            indexcol(currow,1) = curmean;
            threshold = sqdist;
        end
    end
end            
D_old = 10^30;
D_new = 10^25;
iteration = 0;
flag = 10^(-6);
while (((D_old - D_new)>flag || iteration<25 ) && iteration<=250)
    D_old = D_new;
    for curmean = 1:no_clust
        counter = 0;
        tempvec = zeros(1,dimension);
        for currow = 1:no_rows
            if(indexcol(currow,1)==curmean)
                tempvec = tempvec + x(currow,:);
                counter = counter + 1;
            end
         end
          if(counter~=0)
             newmeans(curmean,:) = tempvec./counter;
          else
              error('too few data to work with')
          end
    end
    for currow = 1:no_rows
        threshold = 10^10;
        for curmean = 1:no_clust
            sqdist = 0;
            for curdim = 1:dimension
                sqdist = sqdist + ((x(currow,curdim)-newmeans(curmean,curdim))^2);
            end
            if (sqdist<=threshold)
                indexcol(currow,1) = curmean;
                threshold = sqdist;
            end
        end
    end
    dist = 0;
    for curmean = 1:no_clust
        for currow = 1:no_rows
            if (indexcol(currow,1) == curmean)
                for curdim = 1:dimension
                    dist = dist + ((x(currow,curdim)-newmeans(curmean,curdim))^2);
                end
            end
        end
    end
    iteration = iteration+1
    D_new = dist;
    if(iteration==4)
        flag = dist*(10^(-6));
    end
    D_old - D_new;
end
if (no_clust==8 && dimension==2)
    for j = 1:no_rows
                if (indexcol(j,1)==1)
                    hold on, plot(x(j,1),x(j,2),'r.');
                    hold on, plot(newmeans(1,1),newmeans(1,2),'wX');
                elseif (indexcol(j,1)==2)
                    hold on, plot(x(j,1),x(j,2),'g.');
                    hold on, plot(newmeans(2,1),newmeans(2,2),'kX');
                elseif (indexcol(j,1)==3)
                    hold on, plot(x(j,1),x(j,2),'c.');
                    hold on, plot(newmeans(3,1),newmeans(3,2),'kX');
                elseif (indexcol(j,1)==4)
                    hold on, plot(x(j,1),x(j,2),'b.');
                    hold on, plot(newmeans(4,1),newmeans(4,2),'wX');
                elseif (indexcol(j,1)==5)
                    hold on, plot(x(j,1),x(j,2),'m.');
                    hold on, plot(newmeans(5,1),newmeans(5,2),'wX');
                elseif (indexcol(j,1)==6)
                    hold on, plot(x(j,1),x(j,2),'w.');
                    hold on, plot(newmeans(6,1),newmeans(6,2),'kX');
                elseif (indexcol(j,1)==7)
                    hold on, plot(x(j,1),x(j,2),'k.');
                    hold on, plot(newmeans(7,1),newmeans(7,2),'wX');
                elseif (indexcol(j,1)==8) 
                    hold on, plot(x(j,1),x(j,2),'y.');
                    hold on, plot(newmeans(8,1),newmeans(8,2),'kX');
                end
    end
end
time = toc
soun = wavread('ting.wav');
wavplay(soun);
        

    
    
    