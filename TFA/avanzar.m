function avanzar(dist, odom_sub, pub, msg)
    % Esta funcion simplemente mueve el robot 2 metros hacia delante, hacia la
    % siguiente casilla

    odom = receive(odom_sub,10);
    pos_actual = odom.Pose.Pose.Position.X;

    msg.Linear.X = 0.8;
    send(pub,msg);

    while(pos_actual <= dist)
         odom = receive(odom_sub,10);
         pos_actual = odom.Pose.Pose.Position.X;
    end

    msg.Linear.X = 0;
    send(pub,msgg);
end