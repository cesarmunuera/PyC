function girar(giros, odom_sub, pub, msg_vel)
    %% Variables    
    dist = 0;
    vel_max = 0.8;
    vel_min = 0.05;
    
    %% Recogemos primeros valores
    odom = receive(odom_sub,10);
    quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
    euler=quat2eul(quaternion,'ZYX');
    theta_original = abs(euler(1));


    %% Si tenemos que hacer un giro de 270 lo cambiamos a uno de 90 en sentido contrario
    if(giros == 3)
        vel_max = -vel_max;
        vel_min = -vel_min;
        giros = 1;
    end

    %% Cuerpo
    msg_vel.Angular.Z = vel_max;
    send(pub,msg_vel);
    
    for i = 1:giros
        theta_anterior = theta_original;
        while(1.55 > dist)
            % Obtenemos el theta actual
            odom = receive(odom_sub,10);
            quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
            euler=quat2eul(quaternion,'ZYX');
            theta_actual=abs(euler(1));

            % Calculamos cuanto se ha girado y se lo sumamos al giro
            % acumulado
            dist_dif = abs(theta_actual - theta_anterior);
            dist = dist + dist_dif;

            if(dist >= 1.45)
                msg_vel.Angular.Z = vel_min;
                send(pub,msg_vel);
            end
            if(dist < 0.25)
                msg_vel.Angular.Z = vel_max;
                send(pub,msg_vel);
            end
            theta_anterior = theta_actual;

        end
        theta_original = theta_actual;
        dist = 0;

    end

    msg_vel.Angular.Z = 0;
    send(pub,msg_vel);
end