classdef tpm
    properties
        kd
        ko
    end

    methods
        function obj = tpm(kd, ko)
            obj.ko = ko;
            obj.kd = kd;
        end

        function vel = getSpeed(obj, ed, eo)
            %Calculculamos velocidad angular
            vel = (obj.kd * ed) + (obj.ko * eo);
        end
    end
end