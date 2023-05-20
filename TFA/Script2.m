function  Script2(odom_sub, pub, msg_vel, grafo, nodo_inicio, nodo_fin, mapa_nodos)
    %% Calculamos la ruta mas corta entre los dos nodos
    ruta = shortestpath(grafo, nodo_inicio, 1);

    % Recorremos los nodos de la ruta anterior
    for i=3:length(ruta)
        id_nodo = ruta(i);
        array_posiciones = mapa_nodos(id_nodo);
        mover_PID(array_posiciones, odom_sub, pub, msg_vel);
    end
end