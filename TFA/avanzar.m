function error = avanzar(error_anterior, odom_sub, pub, msg_vel, laser_sub)
    %% Variables
    dist = 2;
    dist_acumulada = 0;
    contador_delantero = 0;
    rate = 10;

    %% Definimos la perodicidad del bucle (10 hz)
    r = robotics.Rate(rate);
    waitfor(r);

    %% Cuerpo del programa
    odom = receive(odom_sub,10);
    pos_X = odom.Pose.Pose.Position.X;
    pos_Y = odom.Pose.Pose.Position.Y;
    last_dist_X = pos_X;
    last_dist_Y = pos_Y;
    dist_actual = sqrt((pos_X - last_dist_X)^2 + (pos_Y - last_dist_Y)^2);
    dist_a_recorrer = dist_actual + dist - error_anterior;

    msg_vel.Linear.X = 0.9;
    send(pub, msg_vel);

    while(dist_acumulada < dist_a_recorrer)
         odom = receive(odom_sub,10);
         pos_X = odom.Pose.Pose.Position.X;
         pos_Y = odom.Pose.Pose.Position.Y;
         dist_actual = sqrt((pos_X - last_dist_X)^2 + (pos_Y - last_dist_Y)^2);
         dist_acumulada = dist_acumulada + dist_actual;

         %% Obtenemos la distancia a la pared delantera, con el laser
         laser1 = receive(laser_sub, 10);
         array_laser = laser1.Ranges;

         mitad_haces = length(array_laser) / 2;
         num_haces = length(array_laser);
         tam_array = int32(num_haces / 24);

         inicio = mitad_haces - tam_array;
         fin = mitad_haces + tam_array;
         array_delantero = reshape(array_laser(inicio:fin), 1, (tam_array*2)+1);

         for j = 1:tam_array
             if (array_delantero(j) <= 1)
                 contador_delantero = contador_delantero + 1;
             end
         end

         prob_delantera = (contador_delantero * 100)/tam_array;

         if (prob_delantera >= 75)
             break
         end

         %% Frenamos al robot cuando se acerque a la distancia deseada
         if(dist_acumulada >= 1.91)
             msg_vel.Linear.X = 0.05;
             send(pub,msg_vel);
         end
         
         last_dist_X = pos_X;
         last_dist_Y = pos_Y;

         % Temporización del bucle según el parámetro establecido en r
         waitfor(r);
    end

    msg_vel.Linear.X = 0;
    send(pub, msg_vel);

    error = dist_acumulada - dist;
end