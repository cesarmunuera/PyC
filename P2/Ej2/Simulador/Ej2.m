%% DESCONEXIÓN DE ROS
rosshutdown;

%% INICIALIZACIÓN DE ROS (COMPLETAR ESPACIOS CON LAS DIRECCIONES IP)
setenv('ROS_MASTER_URI','http://192.168.1.16:11311');
setenv('ROS_IP','192.168.1.7');
rosinit() % Inicialización de ROS en la IP correspondiente

%% DECLARACIÓN DE VARIABLES NECESARIAS PARA EL CONTROL
MAX_TIME = 1000 %% Numero máximo de iteraciones
medidas = zeros(5,1000);

%% DECLARACIÓN DE SUBSCRIBERS
odom_sub = rossubscriber('/robot0/odom'); % Subscripción a la odometría
sonar0 = rossubscriber('/robot0/sonar_0', rostype.sensor_msgs_Range)

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist'); %
msg_vel=rosmessage(pub); %% Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)
msg_sonar0=rosmessage(sonar0)

%% Definimos la periodicidad del bucle (10 hz)
r = robotics.Rate(10);
waitfor(r);

%% Inicializamos variables para el control
i = 0;
D = 0.1;

%% Bucle de control
while (1)
    i = i + 1;

    %% Obtenemos la posición y medidas de sonar
    odom = receive(odom_sub, 10);
    msg_sonar0 = receive(sonar0);

    %% Calculamos la distancia avanzada y medimos la distancia a la pared
    dist = odom.Pose.Pose.Position.X;
    dist_avanzada = dist - last_dist;

    dist_laser = msg_sonar0.Range_;
    if dist_laser>5
        dist_laser = 5;
    end

    %% Calculamos el error de distancia y orientación
    Eori = atan2((dist_laser - last_dist_laser) / dist_avanzada);
    Edist = ((dist_laser + 0.105) * cos(Eori)) - D;

    %Esto pa que cojones es
%     medidas(1,i)= dist;
%     medidas(2,i)= lastdist; %% valor anterior de distancia
%     medidas(3,i)= distav;
%     medidas(4,i)= Eori;
%     medidas(5,i)= Edist;

    %% Calculamos las consignas de velocidades
    consigna_vel_linear = 0.3;
    consigna_vel_ang =

    %% Condición de parada ????????? Cuando tenemos que parar
    if (Edist<0.01) && (Eori<0.01)
        break;
    end

    %% Aplicamos consignas de control
    msg_vel.Linear.X= consigna_vel_linear;
    msg_vel.Linear.Y=0;
    msg_vel.Linear.Z=0;
    msg_vel.Angular.X=0;
    msg_vel.Angular.Y=0;
    msg_vel.Angular.Z= consigna_vel_ang;

    % Comando de velocidad
    send(pub,msg_vel);
    last_dist_laser = dist_laser;
    last_dist = dist;
    %Estas de abajo no se pa que son
    lastvAng = vAng;
    last_dist_av = dist_avanzada;

    % Temporización del bucle según el parámetro establecido en r
    waitfor(r);
    if (i==MAX_TIME)
        break;
    end
end

%Esto pa q cojones es
save('medidas.mat','medidas');


%% DESCONEXIÓN DE ROS
rosshutdown;