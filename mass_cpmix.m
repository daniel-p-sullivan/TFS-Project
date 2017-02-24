function [cpmix] = mass_cpmix(obj, T)
    cp = zeros(obj.NUM_GASSES, length(T));  %allocate array for cp
    for i = 1:obj.NUM_GASSES                %iterate through the gasses
       cp(i, :) = mass_cp(obj(i), T); %calculate cp for gas #i for all T
    end
    cpmix = obj.X * cp;                     %X dot cp
end