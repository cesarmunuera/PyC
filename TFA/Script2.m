function  Script2(odom_sub, pub, msg_vel, grafo, nodo_inicio, nodo_fin, mapa_nodos)
    %% Descripcion
    % Esta funcion implementa el funcionamiento por el que el robot llega a
    % la salida, desde la posición en la que ha terminado en el Script1,
    % usando la ruta mas corta.

    %% Calculamos la ruta mas corta entre los dos nodos
    ruta = shortestpath(grafo, nodo_inicio, nodo_fin);

    % Recorremos los nodos de la ruta anterior, y sacamos las coordenadas
    % del mapa. Con esa coordenada, mandamos al robot moverse a esa
    % posicion.
    for i=3:length(ruta)
        id_nodo = ruta(i);
        array_posiciones = mapa_nodos(id_nodo);
        mover_PID(array_posiciones, odom_sub, pub, msg_vel);
    end
end