function error_lineal = mover(error_lineal_anterior, codificacion_paredes, odom_sub, pub, msg_vel, laser_sub)
    %% Descripcion
    % Esta funcion usa la codificacion de paredes, e implementa el
    % algoritmo de la mano izquierda. Por lo que separamos las distintas
    % posibilidades, para girar los correspondientes radianes.

    %% Cuerpo del programa
    % Izquierda
    if (...
            codificacion_paredes == 1 || ...
            codificacion_paredes == 2 || ...
            codificacion_paredes == 3 || ...
            codificacion_paredes == 5 || ...
            codificacion_paredes == 6 || ...
            codificacion_paredes == 8 || ...
            codificacion_paredes == 11)
        % Giramos a la izquierda -> pi/2
        girar(1, odom_sub, pub, msg_vel);
        % Avanzamos 2 metros
        error_lineal = avanzar(error_lineal_anterior, odom_sub, pub, msg_vel, laser_sub);
    
    % Recto
    elseif ( ...
            codificacion_paredes == 4 || ...
            codificacion_paredes == 9 || ...
            codificacion_paredes == 10 || ...
            codificacion_paredes == 12)
        % Avanzamos 2 metros
        error_lineal = avanzar(error_lineal_anterior, odom_sub, pub, msg_vel, laser_sub);
    
    % Derecha
    elseif ( ...
            codificacion_paredes == 7 || ...
            codificacion_paredes == 13)
        % Vamos para abajo = derecha -> 3pi/2
         girar(3, odom_sub, pub, msg_vel);
        % Avanzamos 2 metros
        error_lineal = avanzar(error_lineal_anterior, odom_sub, pub, msg_vel, laser_sub);

    % Para atras
    elseif ( ...
            codificacion_paredes == 0 || ...
            codificacion_paredes == 14)
        % Vamos para atras -> pi
         girar(2, odom_sub, pub, msg_vel);
        % Avanzamos 2 metros
        error_lineal = avanzar(error_lineal_anterior, odom_sub, pub, msg_vel, laser_sub);
    
    else
        % Estas en el caso 15 y no deberias estarlo
        disp(" +++++ ¡ Estamos encerrados ! +++++ ")
    end
end

