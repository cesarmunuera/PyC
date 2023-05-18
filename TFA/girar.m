function girar(giros, odom_sub, pub, msg)
    %% Variables    
    pi_valor = round(pi, 4);
    dist = 0;
    
    %% Recogemos primeros valores
    odom = receive(odom_sub,10);
    quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
    euler=quat2eul(quaternion,'ZYX');
    % Guardamos en Theta el primer campo devuelto por la función de Euler
    theta_original = abs(euler(1));
    
    %% Cuerpo
    for i = giros
        msg.Angular.Z = 0.5;
        send(pub,msg);
    
        while(pi_valor/2 >= dist)
            odom = receive(odom_sub,10);
            quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
            euler=quat2eul(quaternion,'ZYX');
            % Guardamos en Theta el primer campo devuelto por la función de Euler
            theta_actual=abs(euler(1));
    
            dist = abs(theta_actual - theta_original);
        end
        
        theta_original = theta_actual;
        dist = 0;
    end

    msg.Angular.Z = 0;
    send(pub,msg);
end