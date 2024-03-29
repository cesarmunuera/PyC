%% INICIALIZACIÓN DE ROS
% Se definen las variables de entorno ROS_MASTER_URI (ip del Master) y ROS_IP (IP de la máquina donde se ejecuta Matlab). Si se está conectado a la misma red, la variable ROS_IP no es necesario definirla.
setenv('ROS_MASTER_URI','http://172.29.30.175:11311')
setenv('ROS_IP','172.29.29.65')
rosshutdown
rosinit % Inicialización de ROS

%% DECLARACIÓN DE SUBSCRIBERS
laser_sub=rossubscriber("/scan"); % Subscripción a la odometría
laser0 = receive(laser_sub, 10);

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist');

%% GENERACIÓN DE MENSAJE
msg=rosmessage(pub); %% Creamos un mensaje del tipo declarado en "pub"(geometry_msgs/Twist)
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
array_atras = [];
cti = 0;
ctd = 0;
ctc = 0;
cta = 0;
dist = 7.9;
sum = 0;
mi = 0;
md = 0;
mc = 0;
ma = 0;
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
    ca = 0;

    % Primero valoramos la fiabilidad de los sensores ---------------------
    % Dividimos el array de haces entre 3
    laser0 = receive(laser_sub, 10);
    num_haces = length(laser0.Ranges);
    tam_array = int32(num_haces / 4);

    array_atras = reshape(laser0.Ranges(1:45), 1, 45);
    array_der = reshape(laser0.Ranges(46:135), 1, 90);
    array_cent = reshape(laser0.Ranges(136:225), 1, 90);
    array_izq = reshape(laser0.Ranges(226:315), 1, 90);
    array_aux = reshape(laser0.Ranges(316:360), 1, 45);

    array_atras = horzcat(array_atras, array_aux);

    %Ahora tenemos 3 zonas de trabajo, como 3 laser independientes

    for j = 1:length(array_izq) %Recorremos array izq y der -------------------
        if (array_izq(j) < dist)
            ci = ci + 1;
        end
        if (array_der(j) < dist)
            cd = cd + 1;
        end
        if (array_cent(j) < dist)
            cc = cc + 1;
        end
        if (array_atras(j) < dist)
            ca = ca + 1;
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
        if (j == length(array_cent))
            sum = 0;
            sum = (cc * 100)/length(array_cent);
            ctc = ctc + sum;
        end
        if (j == length(array_atras))
            sum = 0;
            sum = (ca * 100)/length(array_atras);
            cta = cta + sum;
        end
    end

end


%% Ahora hacemos la media de las probabilidades --------------------------
mi = cti / 100;
md = ctd / 100;
mc = ctc / 100;
mc = ctc / 100;
ma = cta / 100;

disp("La probabilidad de pared por la izquierda es del " + mi + " %.");
disp("La probabilidad de pared por la derecha es del " + md + " %.");
disp("La probabilidad de pared por el centro es del " + mc + " %.");
disp("La probabilidad de pared por detras es del " + ma + " %.");


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