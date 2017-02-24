function [s0mix] = mass_s0mix(obj, T)
    s0 = zeros(obj.NUM_GASSES, length(T));  %allocate array for s0
    for i = 1:obj.NUM_GASSES                %iterate through the gasses
       s0(i, :) = mass_s0(obj(i), T);    %calculate s0 for gas #i for all T 
    end
    s0mix = obj.X * s0;                     %X dot s0
end