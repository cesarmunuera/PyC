function girar(giros, odom_sub, pub, msg_vel)
    %% Variables    
    dist = 0;
    vel = 0.8;
    
    %% Recogemos primeros valores
    odom = receive(odom_sub,10);
    quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
    euler=quat2eul(quaternion,'ZYX');
    theta_original = abs(euler(1));
    
    %% Cuerpo
    msg_vel.Angular.Z = vel;
    send(pub,msg_vel);
    
    for i = 1:giros
        while(1.55> dist)
            odom = receive(odom_sub,10);
            quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
            euler=quat2eul(quaternion,'ZYX');
            theta_actual=abs(euler(1));
    
            dist = abs(theta_actual - theta_original);
            
            if(dist >= 1.4)
                msg_vel.Angular.Z = 0.1;
                send(pub,msg_vel);
            end
            if(dist < 0.2)
                msg_vel.Angular.Z = vel;
                send(pub,msg_vel);
            end

        end
        
        theta_original = theta_actual;
        dist = 0;
    end

    msg_vel.Angular.Z = 0;
    send(pub,msg_vel);
end