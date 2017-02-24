function [p0] = p0mix(obj, s0mix)
    s0ref = zeros(obj.NUM_GASSES, 1);   %construct s0 array
    for i = 1:obj.NUM_GASSES
        s0ref(i) = obj.GASSES(i).S0REF;     %get S0REF from all gasses
    end
    s0ref = obj.X * s0ref / obj.R;      %X dot s0ref / mixture gas constant
    p0 = obj.P0REF * exp(s0mix / obj.R) / exp(s0ref); %definition of p0mix
end