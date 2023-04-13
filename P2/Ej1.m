rosshutdown;
%% INICIALIZACIÓN DE ROS (COMPLETAR ESPACIOS CON LAS DIRECCIONES IP)
setenv('ROS_MASTER_URI','http://172.22.18.180:11311');
setenv('ROS_IP','172.22.5.50');
rosinit() % Inicialización de ROS en la IP correspondiente

%% DECLARACIÓN DE VARIABLES NECESARIAS PARA EL CONTROL
Xp = 10;
Yp = 10;
v_max = 1;
w_max = 0.5;
kp = 0.2;
td = 0;
rate = 10;
v_error = 0;
w_error = 0;

%% DECLARACIÓN DE SUBSCRIBERS
odom_sub = rossubscriber('/robot0/odom'); % Subscripción a la odometría

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist'); %
msg_vel=rosmessage(pub); %% Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)

%% Definimos la perodicidad del bucle (10 hz)
r = robotics.Rate(rate);
waitfor(r);

%% Instanciacion de los objetos de la clase PID
pid_v = tpm(kp, td, rate, 1);
pid_w = tpm(kp, td, rate, 0.5);

%% Umbrales para condiciones de parada del robot
umbral_distancia = 0.2;
umbral_angulo = 0.2;

%% Bucle de control infinito
while (1)
    %% Obtenemos la posición y orientación actuales
    odom = receive(odom_sub, 10)
    pos=odom.Pose.Pose.Position;
    X = pos.X;
    Y = pos.Y;
    ori=odom.Pose.Pose.Orientation;
    yaw=quat2eul([ori.W ori.X ori.Y ori.Z]);
    yaw=yaw(1);

    %% Calculamos el error de distancia
    error_lineal = sqrt(((X-Xp)^2)+((Y-Yp)^2));

    %% Calculamos el error de orientación
    error_angular = atan2((Yp-Y),(Xp-X))-yaw;

    %% Calculamos las consignas de velocidades
    consigna_vel_linear = pid_v.getSpeed(error_lineal);
    consigna_vel_ang = pid_w.getSpeed(error_angular);

    %% Condición de parada
    Edist = error_lineal;
    Eori = error_angular;
    if (Edist<umbral_distancia) && (abs(Eori)<umbral_angulo)
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

    % Temporización del bucle según el parámetro establecido en r
    waitfor(r);
end

%% DESCONEXIÓN DE ROS
rosshutdown;