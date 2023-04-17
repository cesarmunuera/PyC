classdef tpm
    properties
        kp
        kd
        inc_t
        u
        a_error
        v_max
    end

    methods
        function obj = tpm(kp, td, inc_t, v_max)
            obj.kp = kp;
            obj.inc_t = inc_t;
            obj.u = [0, v_max];
            obj.a_error = zeros(1, 3);
            obj.kd = kp * td;
            obj.v_max = v_max;
        end

        function vel = getSpeed(obj, polla)

            obj.a_error(3) = obj.a_error(2);
            obj.a_error(2) = obj.a_error(1);
            obj.a_error(1) = polla;

            %Calculo de kp*e´(t)
            p = (obj.kp * (obj.a_error(1) - obj.a_error(2))/obj.inc_t);

            %Calculo de kd * e´´(t)-
            d = (obj.kd * (obj.a_error(1) - 2 * obj.a_error(2) + obj.a_error(3))/pow2(obj.inc_t));

            % U´(t) = kp*e´(t) + ki * e(t) + kd * e´´(t)
            u_prima = p + d;

            % Calculo de u(k) y actualizacion del array u
            obj.u(1) = (obj.inc_t * u_prima) + obj.u(2);
            obj.u(2) = obj.u(1);

            %Limitamos la velocidad
            if (obj.u(1) > obj.v_max)
                vel = obj.v_max;
            else
                vel = obj.u(1);
            end

        end
    end
end

