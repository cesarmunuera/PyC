%% INICIALIZACIÓN DE ROS (COMPLETAR ESPACIOS CON LAS DIRECCIONES IP)
setenv('ROS_MASTER_URI',' ');
setenv('ROS_IP',' ');
rosinit() % Inicialización de ROS en la IP correspondiente
%% DECLARACIÓN DE VARIABLES NECESARIAS PARA EL CONTROL
Xp = 10;
Yp = 10;
v_max = 1;
w_max = 0.5;
%% DECLARACIÓN DE SUBSCRIBERS
odom = rossubscriber('/robot0/odom'); % Subscripción a la odometría
%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist'); %
msg_vel=rosmessage(pub); %% Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)
%% Definimos la perodicidad del bucle (10 hz)
r = robotics.Rate(10);
waitfor(r);
%% Nos aseguramos recibir un mensaje relacionado con el robot
while (strcmp(odom.LatestMessage.ChildFrameId,'robot0')~=1)
    odom.LatestMessage
end
%% Instanciacion de los objetos de la clase PID
pid_v = PID(1, 1, 1, 1, 1);
pid_w = PID(1, 1, 1, 1, 0.5);
%% Umbrales para condiciones de parada del robot
umbral_distancia = 0.2;
umbral_angulo = 0.2;
%% Bucle de control infinito
while (1)

    %% Obtenemos la posición y orientación actuales
    pos=odom.LatestMessage.Pose.Pose.Position;
    X = pos.X;
    Y = pos.Y;
    ori=odom.LatestMessage.Pose.Pose.Orientation;
    yaw=quat2eul([ori.W ori.X ori.Y ori.Z]);
    yaw=yaw(1);
    %% Calculamos el error de distancia
    error_lineal = sqrt(((X-Xp)^2)+((Y-Yp)^2));
    %% Calculamos el error de orientación
    error_angular = atan2((Yp-Y),(Xp-X))-yaw;
    %% Calculamos las consignas de velocidades
    consigna_vel_linear = 
    consigna_vel_ang =
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