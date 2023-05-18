function girar(angulo,odom_sub,pub,msg_vel)
pi_valor = round(pi, 4);
while (1)
    odom = receive(odom_sub,10);
    odom.Pose.Pose.Orientation
    quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
    euler=quat2eul(quaternion,'ZYX');
    % Guardamos en Theta el primer campo devuelto por la función de Euler
    Theta=euler(1);

    if(Theta > 0)
        msg_vel.Angular.Z = 0.5;
        send(pub,msg_vel);
        destino = Theta + angulo;
        while(destino > Theta)
            odom = receive(odom_sub,10);
            odom.Pose.Pose.Orientation
            quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
            euler=quat2eul(quaternion,'ZYX');
            % Guardamos en Theta el primer campo devuelto por la función de Euler
            Theta=euler(1);
            if(Theta < 0 )
                Theta = Theta + pi_valor * 2;
            end
        end
        msg_vel.Angular.Z = 0;
        send(pub,msg_vel);
    else
        Theta = Theta + pi_valor * 2;
        msg_vel.Angular.Z = 0.5;
        send(pub,msg_vel);
        destino = Theta + angulo;
        while(destino > Theta)
            odom = receive(odom_sub,10);
            odom.Pose.Pose.Orientation
            quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
            euler=quat2eul(quaternion,'ZYX');
            % Guardamos en Theta el primer campo devuelto por la función de Euler
            Theta=euler(1);
            if(Theta > 0 )
                Theta = Theta + pi_valor * 2;
            end
        end
    end
end





end

