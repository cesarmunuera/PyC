function mover(codificacion_paredes, odom_sub, pub, msg_vel, id_nodo_anterior)
%     if(id_nodo_anterior > 0)
%         switch codificacion_paredes
%             case 0
%                 codificacion_paredes = 14;
%             case 1
%                 codificacion_paredes = 6;
%             case 2
%                 codificacion_paredes = 8;
%             case 4
%                 codificacion_paredes = 10;
%             case 5
%                 codificacion_paredes = 11;
%             case 7
%                 codificacion_paredes = 13;
%             case 9
%                 codificacion_paredes = 12;
%         end
%     
%     end
%     

    codificacion_paredes
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
        avanzar(odom_sub, pub, msg_vel);
    
    elseif ( ...
            codificacion_paredes == 4 || ...
            codificacion_paredes == 9 || ...
            codificacion_paredes == 10 || ...
            codificacion_paredes == 12)
        % Avanzamos 2 metros
        avanzar(odom_sub, pub, msg_vel);
    
    elseif ( ...
            codificacion_paredes == 7 || ...
            codificacion_paredes == 13)
        % Vamos para abajo = derecha -> 3pi/2
        girar(3, odom_sub, pub, msg_vel);
        % Avanzamos 2 metros
        avanzar(odom_sub, pub, msg_vel);
    
    elseif ( ...
            codificacion_paredes == 0 || ...
            codificacion_paredes == 14)
        % Vamos para atras -> pi
        girar(2, odom_sub, pub, msg_vel);
        % Avanzamos 2 metros
        avanzar(odom_sub, pub, msg_vel);
    
    else
        % Estas en el caso 15 y no deberias estarlo
        disp(" +++++ ¡ Estamos encerrados ! +++++ ")
    end
end

