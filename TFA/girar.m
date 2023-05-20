function error = girar(error_anterior, giros, odom_sub, pub, msg_vel)
    %% Variables    
    angulo_acumulado = 0;
    vel_max = 0.8;
    vel_min = 0.05;
    angulo_a_recorrer = 1.5707;
    
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

    %% Si tenemos que hacer un giro 180, cambiamos el angulo a recorrer a pi
    if (giros == 2)
        angulo_a_recorrer = round(pi, 4);
    end

    %% Cuerpo
    msg_vel.Angular.Z = vel_max;
    send(pub,msg_vel);
    
    theta_anterior = theta_original;

    angulo_a_recorrer = angulo_a_recorrer - error_anterior

    while(angulo_a_recorrer > angulo_acumulado)
        % Obtenemos el theta actual
        odom = receive(odom_sub,10);
        quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
        euler=quat2eul(quaternion,'ZYX');
        theta_actual=abs(euler(1));

        % Calculamos cuanto se ha girado y se lo sumamos al giro
        % acumulado
        dist_dif = abs(theta_actual - theta_anterior);
        angulo_acumulado = angulo_acumulado + dist_dif

        if(angulo_acumulado >= angulo_a_recorrer - 0.15)
            msg_vel.Angular.Z = vel_min;
            send(pub,msg_vel);
        end
        theta_anterior = theta_actual;
    end

    msg_vel.Angular.Z = 0;
    send(pub,msg_vel);

    error = angulo_acumulado - angulo_a_recorrer;
end