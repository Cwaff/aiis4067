function belonging = belong2Guass(distance , sd, threshold)
    value = distance / sd;
    if value < threshold
        belonging = true;
    else
        belonging = false;
    end
end