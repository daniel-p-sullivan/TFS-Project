classdef Node
    %Thermodynamic station where two or more devices meet. This class is
    %used as an easy way to store temperature and pressure at all the
    %stations in the cycle.
    
    properties
        T
        P
        h
        Station %Station Number
        
    end
    
    methods
        function c = Node(station)
            c.Station = station;
        end
    end
            
            
    
end

