function [u] = mass_u(obj, T)
    Tref = obj.TREF;    %var for TREF
    uref = obj.UREF;    %var for UREF
    if (obj.ABCD == 0)  %perfect gas?
        u = T * (3 / 2) * obj.R;   %def of u for perfect gas w/ uref = 0
    else
        T_vec = [T; T.^2 / 2; T.^3 / 3; T.^4 / 4];              %Temperature vector for polynomial for all Temperatures in T
        Tref_vec = [Tref; Tref^2 / 2; Tref^3 / 3; Tref^4 / 4];  %Tref vector for polynomial
        u = ((obj.ABCD * T_vec) - (obj.ABCD * Tref_vec)) / obj.M - obj.R * (T - Tref) + uref;   %def of u(T) for all Temperatures in T
    end
end