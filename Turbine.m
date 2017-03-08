classdef Turbine < handle
    %TURBINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        InletNode
        OutletNode = Node(0);
        Efficiency
        ho_s
        ho_a
        To_s
        To_a
        Work
        P_out
    end
    
    methods
        function c = Turbine(InletNode,InletFluid, eff, outletpressure, work, outletstation)
            c.Efficiency = eff;
            c.InletNode = InletNode;
            %c.P_out = outletpressure;
            c.OutletNode.Station = outletstation;
            %c.OutletNode.P = outletpressure;
            
            if (outletpressure==0)
                c.ho_a = InletFluid.H - work;
                c.To_a = T_h_solver(InletFluid, c.ho_a);
                c.ho_s = work/eff + InletFluid.H;
                c.To_s = T_h_solver(InletFluid, c.ho_s);
                c.P_out = exp((mass_s0mix(InletFluid.MIX,c.To_s)-mass_s0mix(InletFluid.MIX,InletFluid.T)/InletFluid.MIX.R))*InletFluid.P;
                
            end
            
            if (work==0)
                c.P_out = outletpressure;
                c.To_s = T_s_Solver(InletFluid, outletpressure);
                c.ho_s = mass_hmix(InletFluid.MIX, c.To_s);
                c.ho_a = eff * (InletFluid.H - c.ho_s) + InletFluid.H;
                c.To_a = T_h_solver(InletFluid, c.ho_a);
                c.Work = InletFluid.H - c.ho_a;
               
            end
            
            if(eff==0)
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

