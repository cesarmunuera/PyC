classdef tpm
    properties
        kd
        ko
        v_max
    end

    methods
        function obj = tpm(kd, ko, v_max)
            obj.ko = ko;
            obj.kd = kd;
            obj.v_max = v_max;
        end

        function vel = getSpeed(obj, ed, eo)
            %Calculculamos velocidad angular
            vel = (obj.kd * ed) + (obj.ko * eo);

            %Limitamos la velocidad
            if (vel > obj.v_max)
                vel = obj.v_max;
            end

        end
    end
end