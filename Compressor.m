classdef Compressor 
    %The inlet and design parameters of the compressor are arguments of the
    %constructor. The outlet parameters are then calculated in the
    %constructor. The compression ratio, efficiency, Inlet pressure, and
    %Inlet temperature must be known to solve for outlet conditions.
    
    properties
        InletNode
        OutletNode = Node(0);
        Efficiency  %compressor effieicny
        ho_s %Isentropic outlet enthalpy
        ho_a %actual outlet enthalpy
        To_s %isentropic outlet temp
        To_a %actual outlet temp
        Compression_Ratio
        Work
    end
    
    methods
        function c = Compressor(InletNode, InletFluid, Eff, Comp_ratio, outletstation)
            c.Efficiency = Eff; %setting compressor efficiency
            c.InletNode = InletNode; %setting the compressor inlet node
            c.Compression_Ratio = Comp_ratio; %setting compressor ratio
            c.OutletNode.Station = outletstation;  %associating compressor with outlet station number
            c.OutletNode.P = InletNode.P*Comp_ratio; %Solving for outlet pressure
            c.To_s = T_s_Solver(InletFluid, InletFluid.P*Comp_ratio); %solving for isentropic outlet temperature
            c.ho_s = mass_hmix(InletFluid.MIX,c.To_s); %solving for isentropic outlet enthalpy
            c.ho_a = (c.ho_s - InletFluid.H)/Eff + InletFluid.H;  %solving for actual outlet enthalpy
            c.To_a = T_h_solver(InletFluid, c.ho_a);  %iteratively solving for outlet temperature given outlet enthalpy
            c.OutletNode.T = c.To_a;
            c.OutletNode.h = c.ho_a;
            c.Work = c.OutletNode.h - c.InletNode.h; %calculating compressor work
            
        end
    end
    
       
                
    
end

