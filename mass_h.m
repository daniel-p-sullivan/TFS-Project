function [h] = mass_h(obj, T)
    Tref = obj.TREF;    %var for TREF
    href = obj.HREF;    %var for HREF
    if (obj.ABCD == 0)  %perfect gas?
        h = T * (5 / 2) * obj.R;    %def of h for perfect gas w/ href = 0;
    else
        T_vec = [T; T.^2 / 2; T.^3 / 3; T.^4 / 4];              %Temperature vector for polynomial for all Temperatures in T
        Tref_vec = [Tref; Tref^2 / 2; Tref^3 / 3; Tref^4 / 4];  %Tref vector for polynomial
        h = ((obj.ABCD * T_vec) - (obj.ABCD * Tref_vec)) / obj.M + href;    %def of h(T) for all T, (ABCD dot T_vec) for all Temperatures in T
    end
end