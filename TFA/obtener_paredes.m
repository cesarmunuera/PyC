function codificacion_paredes = obtener_paredes(array_laser, distancia_sonar_derecho, distancia_sonar_izquierdo)
  %% Variables
  dist = 1.2;
  contador_trasero = 0;
  contador_delantero = 0;
  pared_delantera = false;
  pared_trasera = false;
  pared_derecha = false;
  pared_izquierda = false;
  

  %% Primero obtenemos las paredes delanteras y traseras a partir del laser
  % Valores auxiliares
  num_pared_izquierdatad_haces = length(array_laser) / 2;
  num_haces = length(array_laser);
  tam_array = int32(num_haces / 24);
  
  %Obtenemos el array trasero
  array_trasero = reshape(array_laser(1:tam_array), 1, tam_array);
  array_atras_aux = reshape(array_laser(num_haces - tam_array:num_pared_izquierdatad_haces), 1, tam_array);
  array_trasero = horzcat(array_trasero, array_atras_aux);
  
  %Obtenemos el array delantero
  array_delantero = reshape(array_laser(num_pared_izquierdatad_haces - num_haces:num_pared_izquierdatad_haces + num_haces), 1, tam_array*2);
  
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
  
  %% Calculamos la probabilidad de haber detectado pared con el laser
  prob_trasera = (contador_trasero * 100)/tam_array;
  prob_delantera = (contador_delantero * 100)/tam_array;

  %% Asignamos un valor logico a la deteccion sonar y laser
  if (prob_delantera > 55)
    pared_delantera = true;
  end

  if (prob_trasera > 55)
    pared_trasera = true;
  end

  if (distancia_sonar_derecho < dist)
    pared_derecha = true;
  end

  if (distancia_sonar_izquierdo < dist)
    pared_izquierda = true;
  end

  %% Ahora procedemos a realizar la codificación -----------------------------
  if(~pared_izquierda && pared_delantera && ~pared_derecha && ~pared_trasera)
    codificacion_paredes = 1;
  elseif(~pared_izquierda && ~pared_delantera && pared_derecha && ~pared_trasera)
    codificacion_paredes = 2;
  elseif(~pared_izquierda && ~pared_delantera && ~pared_derecha && pared_trasera)
    codificacion_paredes = 3;
  elseif(pared_izquierda && ~pared_delantera && ~pared_derecha && ~pared_trasera)
    codificacion_paredes = 4;
  elseif(~pared_izquierda && pared_delantera && pared_derecha && ~pared_trasera)
    codificacion_paredes = 5;
  elseif(~pared_izquierda && pared_delantera && ~pared_derecha && pared_trasera)
    codificacion_paredes = 6;
  elseif(pared_izquierda && pared_delantera && ~pared_derecha && ~pared_trasera)
    codificacion_paredes = 7;
  elseif(~pared_izquierda && ~pared_delantera && pared_derecha && pared_trasera)
    codificacion_paredes = 8;
  elseif(pared_izquierda && ~pared_delantera && pared_derecha && ~pared_trasera)
    codificacion_paredes = 9;
  elseif(pared_izquierda && ~pared_delantera && ~pared_derecha && pared_trasera)
    codificacion_paredes = 10;
  elseif(~pared_izquierda && pared_delantera && pared_derecha && pared_trasera)
    codificacion_paredes = 11;
  elseif(pared_izquierda && ~pared_delantera && pared_derecha && pared_trasera)
    codificacion_paredes = 12;
  elseif(pared_izquierda && pared_delantera && ~pared_derecha && pared_trasera)
    codificacion_paredes = 13;
  elseif(pared_izquierda && pared_delantera && pared_derecha && ~pared_trasera)
    codificacion_paredes = 14;
  elseif(pared_izquierda && pared_delantera && pared_derecha && pared_trasera)
    codificacion_paredes = 15;
  elseif(~pared_izquierda && ~pared_delantera && ~pared_derecha && ~pared_trasera)
    codificacion_paredes = 0;
  end
  
end