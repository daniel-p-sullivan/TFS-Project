function [s0] = mass_s0(obj, T)
    Tref = obj.TREF;    %var for TREF
    s0ref = obj.S0REF;  %var for S0REF
    if (obj.ABCD == 0)  %perfect gas?
        s0 = (5 / 2) * obj.R * log(T / Tref) + s0ref; %def of s0 for perfect gas w/ s0ref
    else
        T_vec = [log(T); T; T.^2 / 2; T.^3 / 3];                %Temperature vector for polynomial
        Tref_vec = [log(Tref); Tref; Tref.^2 / 2; Tref.^3 / 3]; %Tref vector for polynomial
        s0 = ((obj.ABCD * T_vec) - (obj.ABCD * Tref_vec)) / obj.M + s0ref;  %def of s0
    end 
end