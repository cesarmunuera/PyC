
%% Variables
array_izq = [];
array_cent = [];
array_der = [];
cti = 0;
ctd = 0;
ctc = 0;
dist = 3.9;
sum = 0;
mi = 0;
md = 0;
mc = 0;
mayoria = 51;

%% Comienza el programa
for i=1:100

    %Variables para resetear
    li = true;
    ld = true;
    lc = true;
    ci = 0;
    cc = 0;
    cd = 0;

    % Primero valoramos la fiabilidad de los sensores ---------------------
    % Dividimos el array de haces entre 3
    laser0 = receive(laser_sub, 10);
    num_haces = length(laser0.Ranges);
    tam_array = int32(num_haces / 3);

    array_der = reshape(laser0.Ranges(1:tam_array), 1, tam_array);
    array_cent = reshape(laser0.Ranges(tam_array+1:(tam_array*2)+1), 1, tam_array + 1);
    array_izq = reshape(laser0.Ranges((tam_array*2)+2:num_haces), 1, tam_array);
    %Ahora tenemos 3 zonas de trabajo, como 3 laser independientes

    for j = 1:length(array_izq) %Recorremos array izq y der -------------------
        if (array_izq(j) < dist)
            ci = ci + 1;
        end
        if (array_der(j) < dist)
            cd = cd + 1;
        end
        %Arriba sumamos 1 si detecta pared
        %Abajo obtenemos la probabilidad de pared con ese contador.
        %Esa probabilidad la almacenamos para hacer una media.
        if (j == length(array_izq))
            sum = 0;
            sum = (ci * 100)/length(array_izq);
            cti = cti + sum;
        end
        if (j == length(array_der))
            sum = 0;
            sum = (cd * 100)/length(array_der);
            ctd = ctd + sum;
        end
    end


    for k = 1:length(array_cent)%Recorremos el array central ----------------
        if (array_cent(k) < dist)
            cc = cc + 1;
        end
        %Arriba sumamos 1 si detecta pared
        %Abajo obtenemos la probabilidad de pared con ese contador.
        %Esa probabilidad la almacenamos para hacer una media.
        if (k == length(array_cent))
            sum = 0;
            sum = (cc * 100)/length(array_cent);
            ctc = ctc + sum;
        end
    end
end


%% Ahora hacemos la media de las probabilidades --------------------------
mi = cti / 100;
md = ctd / 100;
mc = ctc / 100;

disp("La probabilidad de pared por la izquierda es del " + mi + " %.");
disp("La probabilidad de pared por la derecha es del " + md + " %.");
disp("La probabilidad de pared por el centro es del " + mc + " %.");


%Ahora procedemos a realizar la codificación -----------------------------
if(mi < mayoria && mc > mayoria && md < mayoria)
    disp("Codificación 1")
elseif(mi < mayoria && mc < mayoria && md > mayoria)
    disp("Codificación 2")
elseif(mi > mayoria && mc < mayoria && md < mayoria)
    disp("Codificación 4")
elseif(mi < mayoria && mc > mayoria && md > mayoria)
    disp("Codificación 5")
elseif(mi > mayoria && mc > mayoria && md < mayoria)
    disp("Codificación 7")
elseif(mi > mayoria && mc < mayoria && md > mayoria)
    disp("Codificación 9")
elseif(mi > mayoria && mc > mayoria && md > mayoria)
    disp("Codificación 14")
elseif(mi < mayoria && mc < mayoria && md < mayoria)
    disp("Codificación 0")
end
