function [grafo, id_nodo_actual, nodo_salida, mapa_nodos] = Script1(odom_sub, laser_sub, sonar_sub0, sonar_sub5, pub, msg_vel)
    %% Variables    
    num_nodos = 26;
    id_nodo_anterior = 0;
    nodos_recorridos = 0;
    error_lineal = 0;
    error_angular = 0;
    grafo = graph;
    mapa_nodos = containers.Map("KeyType", "int32", "ValueType", "any");

    %% Cuerpo del programa
    while(nodos_recorridos < num_nodos)
        % Recibimos datos de las subscripciones
        laser1 = receive(laser_sub, 10);
        odom = receive(odom_sub, 10);
        sonar0 = receive(sonar_sub0, 10);
        sonar5 = receive(sonar_sub5, 10);

        % Sacamos los datos del robot
        array_laser = laser1.Ranges;
        distancia_sonar_derecho = sonar5.Range_;
        distancia_sonar_izquierdo = sonar0.Range_;
        X_pos = odom.Pose.Pose.Position.X;
        Y_pos = odom.Pose.Pose.Position.Y;

        %% Comprobamos si ya hemos visitado el nodo
        % Obtenemos la posicion de x e y, sin decimales
        X_pos = floor(X_pos + 0.5);
        Y_pos= floor(Y_pos + 0.5);
        
        % Comprobamos que no se haya visitado el nodo previamente
        nodo_visitado = false;
        tam_mapa = mapa_nodos.Count;
        if (tam_mapa > 0)
            for i = 1:tam_mapa
                valor = mapa_nodos(i);
                if (valor(1) == X_pos && valor(2) == Y_pos)
                    nodo_visitado = true;
                    id_nodo_actual = i;
                end
            end
        end

        % Si no se ha visitado, lo añadimos al mapa
        if (~nodo_visitado)
            valor = [X_pos, Y_pos];
            id_nodo_actual = mapa_nodos.Count + 1;

            mapa_nodos(id_nodo_actual) = valor;
            nodos_recorridos = nodos_recorridos + 1;
        end
        
        % Añadimos un vecino a un nodo existente, si no tenia a ese vecino
        if(nodos_recorridos > 1)
            vecinos = nearest(grafo, id_nodo_anterior, 1);
            vecino_registrado = ismember(id_nodo_actual, vecinos);
            if (~vecino_registrado)
                grafo = addedge(grafo, id_nodo_actual, id_nodo_anterior);
                %plot(grafo);
            end
        else
             grafo = addnode(grafo, id_nodo_actual);
        end

        %% Movemos al robot
        % Miramos paredes que rodean al robot
        paredes = obtener_paredes(array_laser, distancia_sonar_derecho, distancia_sonar_izquierdo);

        % Almacenamos la id del nodo salida
        if (paredes == 0)
            nodo_salida = id_nodo_actual
        end

        % Movemos al robot a la siguiente celda
        error_lineal = mover(error_lineal, paredes, odom_sub, pub, msg_vel, laser_sub);

        %% Actualizamos el ultimo nodo visitado
        id_nodo_anterior = id_nodo_actual;
        % En la ultima iteracion, el nodo actual es el nodo donde ha
        % quedado el robot

    end
    msg_vel.Linear.X = 0;
    send(pub, msg_vel);
end

