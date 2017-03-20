classdef Turbine < handle
    %This class solves for the outlet conditions of a turbine given certain
    %inputs. If any of the constructor inputs are not known, they need to
    %be set to 0. The turbine properties are solved for differently
    %depending on what other properties are given as knowns.
    
    properties
        InletNode
        OutletNode = Node(0);
        Efficiency  %turbine isentropic efficiency
        ho_s  %outlet isentropic enthalpy
        ho_a  %outlet actual enthalpy
        To_s  %outlet isentropic temp
        To_a  %outlet actual temp
        Work  %turbine work
        P_out  %outlet pressure
    end
    
    methods
        function c = Turbine(InletNode, InletFluid, eff, outletpressure, work, outletstation)
            c.Efficiency = eff;
            c.InletNode = InletNode;
            c.OutletNode.Station = outletstation;
            
            if (outletpressure==0) %If outlet pressure is not known, then efficiency and work must be known to solve for outlet conditions.
                c.ho_a = InletFluid.H - work;
                c.To_a = T_h_solver(InletFluid, c.ho_a);
                c.ho_s = InletFluid.H - work/eff;
                c.To_s = T_h_solver(InletFluid, c.ho_s);
                c.P_out = exp((mass_s0mix(InletFluid.MIX,c.To_s)-mass_s0mix(InletFluid.MIX,InletFluid.T))/InletFluid.MIX.R)*InletFluid.P; 
            end
            
            if (work==0) %if work is unknown, then outlet pressure and efficiency must be known to solve for outlet conditions
                c.P_out = outletpressure;
                c.To_s = T_s_Solver(InletFluid, outletpressure);
                c.ho_s = mass_hmix(InletFluid.MIX, c.To_s);
                c.ho_a = InletFluid.H - eff * (InletFluid.H - c.ho_s);
                c.To_a = T_h_solver(InletFluid, c.ho_a);
                c.Work = InletFluid.H - c.ho_a;
            end
            
            if(eff==0) %if efficiency is unkonw, outlet pressure and work must be known to solve for efficiency
                c.Work = work;
                c.P_out = outletpressure;
                c.ho_a = InletFluid.H - c.Work;
                c.To_a = T_h_solver(InletFluid, c.ho_a);
                c.To_s = T_s_Solver(InletFluid, outletpressure);
                c.ho_s = mass_hmix(InletFluid.MIX, c.To_s);
                c.Efficiency = (c.ho_a - c.InletNode.h)/(c.ho_s - c.InletNode.h); 
            end
            
            c.OutletNode.P = c.P_out;
            c.OutletNode.T = c.To_a;
            c.OutletNode.h = c.ho_a;
        end
    end
    
end

