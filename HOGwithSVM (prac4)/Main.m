

%Load pedestrian db 
[testimages, testlabels] = loadPedestrianDatabase('pedestrian_train.cdataset');

%Calculate all Hogs for test images 
hogMatrix = calcAllHogs(testimages);




