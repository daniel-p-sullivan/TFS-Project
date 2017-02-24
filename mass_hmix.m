function [hmix] = mass_hmix(obj, T)
    h = zeros(obj.NUM_GASSES, length(T));   %array for storing h values
    for i = 1:obj.NUM_GASSES                %iterate through the gasses
       h(i, :) = mass_h(obj(i), T);  %calculate h for all T for gas #i in mixture
    end
    hmix = obj.X * h;                       %X dot h for all T
end