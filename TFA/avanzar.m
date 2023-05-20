function avanzar(odom_sub, pub, msg_vel)
    % Esta funcion simplemente mueve el robot 2 metros hacia delante, hacia la
    % siguiente casilla

    %% Variables
    dist = 2;
    dist_acumulada = 0;

    %% Cuerpo del programa
    odom = receive(odom_sub,10);
    pos_X = odom.Pose.Pose.Position.X;
    pos_Y = odom.Pose.Pose.Position.Y;
    last_dist_X = pos_X;
    last_dist_Y = pos_Y;
    dist_actual = sqrt((pos_X - last_dist_X)^2 + (pos_Y - last_dist_Y)^2);
    dist_a_recorrer = dist_actual + dist;

    msg_vel.Linear.X = 0.9;
    send(pub, msg_vel);

    while(dist_acumulada < dist_a_recorrer)
         odom = receive(odom_sub,10);
         pos_X = odom.Pose.Pose.Position.X;
         pos_Y = odom.Pose.Pose.Position.Y;
         dist_actual = sqrt((pos_X - last_dist_X)^2 + (pos_Y - last_dist_Y)^2);
         dist_acumulada = dist_acumulada + dist_actual;

%          if(dist_a_recorrer -  dist_actual < 0.2)
%              msg_vel.Linear.X = 0.05;
%              send(pub,msg_vel);
%          end

         if(dist_acumulada >= 1.9)
             msg_vel.Linear.X = 0.05;
             send(pub,msg_vel);
         end
         
         last_dist_X = pos_X;
         last_dist_Y = pos_Y;
    end

    msg_vel.Linear.X = 0;
    send(pub, msg_vel);
end