classdef PID
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Kp
        ti
        td
        inc_t
        ek
        ek_1
        ek_2
    end

    methods
        function obj = untitled(Kp, ti, td, inc_t,)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.Kp = Kp;
            obj.ti = ti;
            obj.td = td;
            obj.inc_t = inc_t;

        end

        function vel = getVel(error,k)
            if k == 0 

            vel = 1;
        end
    end
end

