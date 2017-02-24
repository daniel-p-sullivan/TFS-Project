function [cp] = mass_cp(obj, T)
    if (obj.ABCD == 0)          %perfect gas?
        cp = (5 / 2) * obj.R;   %def of cp for perfect gas 
    else
        T_vec = [ones(1, length(T)); T; T.^2; T.^3];    %temperature vector, allocated for all Temperatures in T
        cp = (obj.ABCD * T_vec) / obj.M;                %ABCD dot T_vec / molecular mass
    end
end