function [umix] = mass_umix(obj, T)
    u = zeros(obj.NUM_GASSES, length(T));   %allocate array for u
    for i = 1:obj.NUM_GASSES                %iterate through the gasses
       u(i, :) = mass_u(obj(i), T);  %calculate u for gas #i for all T
    end
    umix = obj.X * u;                       %X dot u
end