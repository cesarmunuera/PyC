 classdef PID
    properties
        Kp
        Ki
        Kd
        inc_t
        u
        v_max
    end

    methods
        function obj = untitled(Kp, ti, td, inc_t, v_max)
            obj.Kp = Kp;
            obj.inc_t = inc_t;
            obj.u = [];
            obj.v_max = v_max;
            obj.Kd = Kp * td;
            obj.Ki = Kp / ti;
        end

        function vel = getVel(error,k)

            if k == 0  
                %que valor poner a k-1 y k-2 u(k-1)
            end

            if k == 1
                %que valor poner a k-2
            end 

            %Calculo de kp*e´(t) ------------------------------------------
            p = (kp * (error(k) - error(k-1))/inc_t);

            % Calculo de ki * e(t) ----------------------------------------
            %Como se hace??

            %Calculo de kd * e´´(t)----------------------------------------
            d = (kd * (error(k) - 2 * error(k-1) + error(k-2))/pow2(inc_t));

            % U´(t) = kp*e´(t) + ki * e(t) + kd * e´´(t)-------------------
            u_prima = p + d;

            % Calculo de u(k)----------------------------------------------
            if k == 0  
                u(k) = (inc_t * u_prima) + v_max;
            else
                u(k) = (inc_t * u_prima) + u(k-1);
            end
            vel = u(k);
        end
    end
end

