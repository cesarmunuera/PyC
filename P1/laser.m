%% INICIALIZACIÓN DE ROS
% Se definen las variables de entorno ROS_MASTER_URI (ip del Master) y ROS_IP (IP de la máquina donde se ejecuta Matlab). Si se está conectado a la misma red, la variable ROS_IP no es necesario definirla.
setenv('ROS_MASTER_URI','http://192.168.1.23:11311')
setenv('ROS_IP','192.168.1.5')
rosshutdown
rosinit % Inicialización de ROS

%% DECLARACIÓN DE SUBSCRIBERS
laser_sub=rossubscriber('/robot0/laser_0'); % Subscripción a la odometría

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist');

%% GENERACIÓN DE MENSAJE
msg=rosmessage(pub) %% Creamos un mensaje del tipo declarado en "pub"(geometry_msgs/Twist)
% Velocidades lineales en x,y y z (velocidades en y o z no se usan enrobots diferenciales y entornos 2D)
msg.Linear.X=0;
msg.Linear.Y=0;
msg.Linear.Z=0;
% Velocidades angulares (en robots diferenciales y entornos 2D solo seutilizará el valor Z)
msg.Angular.X=0;
msg.Angular.Y=0;
msg.Angular.Z=0;

send(pub,msg);

%% Definimos la perodicidad del bucle (10 hz)
r = robotics.Rate(10);

%% Variables
array_izq = [];
array_cent = [];
array_der = [];
mix = [];
ci = 0;
cd = 0;
cc = 0;
dist = 4;

%% Comienza el programa
for i=1:100

    % Primero valoramos la fiabilidad de los sensores ++++++++++++++++++++++
    li = true;
    ld = true;
    lc = true;

    % Dividimos el array de haces entre 3
    laser0 = receive(laser_sub, 10);
    num_haces = size(laser0.Ranges, 1);
    tam_array = int32(num_haces / 3);

    array_izq = reshape(laser0.Ranges(1:tam_array), 1, tam_array);
    array_cent = reshape(laser0.Ranges(tam_array+1:(tam_array*2)+1), 1, tam_array + 1);
    array_der = reshape(laser0.Ranges((tam_array*2)+2:num_haces), 1, tam_array);
    %Ahora tenemos 3 zonas de trabajo, como 3 laser independientes

    for j = length(array_izq) %Recorremos array izq y der
        if (array_izq(j) < dist)
            ci = ci + 1;
        end
        if (array_der(j) < dist)
            cd = cd + 1;
        end

        if (j == length(array_izq))

    end
    for k = length(array_cent) %Recorremos array central
        if (array_cent(k) < dist)
            cc = cc + 1;
        end
    end


    %Ahora toca realizar la codificaión
    if(array_izq > dist && array_cent < dist && array_der > dist)
        disp("Codificación 1")
    end

end

disp("La fiabilidad del laser por la izquierda es del " + ci + " %.");
disp("La fiabilidad del laser por la derecha es del " + cd + " %.");
disp("La fiabilidad del laser por el centro es del " + cc + " %.")
