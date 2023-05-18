function codificacion_paredes = obtener_paredes(array_laser, sonar_derecho, sonar_izquierdo)
    %% Variables
    dist = 1.2;
    contador_trasero = 0;
    contador_delantero = 0;

    %% Primero obtenemos las paredes delanteras y traseras a partir del laser
    % Valores auxiliares
    num_mitad_haces = length(array_laser) / 2;
    num_haces = length(array_laser);
    tam_array = int32(num_haces / 24);
    
    %Obtenemos el array trasero
    array_trasero = reshape(array_laser(1:tam_array), 1, tam_array);
    array_atras_aux = reshape(array_laser(num_haces - tam_array:num_mitad_haces), 1, tam_array);
    array_trasero = horzcat(array_trasero, array_atras_aux);
    
    %Obtenemos el array delantero
    array_delantero = reshape(array_laser(num_mitad_haces - num_haces:num_mitad_haces + num_haces), 1, tam_array*2);
    
    %% Vemos si el laser detecta pared
    tam_array = length(array_trasero);

    for j = 1:tam_array
        if (array_trasero(j) < dist)
            contador_trasero = contador_trasero + 1;
        end
        if (array_delantero(j) < dist)
            contador_delantero = contador_delantero + 1;
        end
    end
    
    prob_trasera = (contador_trasero * 100)/tam_array;
    prob_delanter = (contador_delantero * 100)/tam_array;
    
    %Ahora procedemos a realizar la codificación -----------------------------
    if(mi < mayoria && mc > mayoria && md < mayoria && ma < mayoria)
        disp("Codificación 1")
    elseif(mi < mayoria && mc < mayoria && md > mayoria && ma < mayoria)
        disp("Codificación 2")
    elseif(mi < mayoria && mc < mayoria && md < mayoria && ma > mayoria)
        disp("Codificación 3")
    elseif(mi > mayoria && mc < mayoria && md < mayoria && ma < mayoria)
        disp("Codificación 4")
    elseif(mi < mayoria && mc > mayoria && md > mayoria && ma < mayoria)
        disp("Codificación 5")
    elseif(mi < mayoria && mc > mayoria && md < mayoria && ma > mayoria)
        disp("Codificación 6")
    elseif(mi > mayoria && mc > mayoria && md < mayoria && ma < mayoria)
        disp("Codificación 7")
    elseif(mi < mayoria && mc < mayoria && md > mayoria && ma > mayoria)
        disp("Codificación 8")
    elseif(mi > mayoria && mc < mayoria && md > mayoria && ma < mayoria)
        disp("Codificación 9")
    elseif(mi > mayoria && mc < mayoria && md < mayoria && ma > mayoria)
        disp("Codificación 10")
    elseif(mi < mayoria && mc > mayoria && md > mayoria && ma > mayoria)
        disp("Codificación 11")
    elseif(mi > mayoria && mc < mayoria && md > mayoria && ma > mayoria)
        disp("Codificación 12")
    elseif(mi > mayoria && mc > mayoria && md < mayoria && ma > mayoria)
        disp("Codificación 13")
    elseif(mi > mayoria && mc > mayoria && md > mayoria && ma < mayoria)
        disp("Codificación 14")
    elseif(mi > mayoria && mc > mayoria && md > mayoria && ma > mayoria)
        disp("Codificación 15")
    elseif(mi < mayoria && mc < mayoria && md < mayoria && ma < mayoria)
        disp("Codificación 0")
    end

end