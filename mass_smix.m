function [smix] = mass_smix(obj, Pref)
mix = obj.MIX;
T = obj.T;
P = obj.P;
R = mix.R;
smix = mass_s0mix(mix, T) - R * (mix.Y * log(mix.Y)' + log(P/Pref));
           
end