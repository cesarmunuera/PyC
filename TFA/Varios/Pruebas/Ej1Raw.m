%% DESCONEXIÓN DE ROS
rosshutdown;

%% INICIALIZACIÓN DE ROS (COMPLETAR ESPACIOS CON LAS DIRECCIONES IP)
setenv('ROS_MASTER_URI','http://192.168.1.28:11311');
setenv('ROS_IP','192.168.1.7');
rosinit() % Inicialización de ROS en la IP correspondiente

%% DECLARACIÓN DE VARIABLES NECESARIAS PARA EL CONTROL
Xp = 11;
Yp = 3;
v_max = 1;
w_max = 1;
kp = 10;
td = 0.3;
ti = 6;
rate = 10;
array_lineal = [];
array_ang = [];
error_lin = [];
error_angu = [];
control_giro = true;

%% DECLARACIÓN DE SUBSCRIBERS
odom_sub = rossubscriber('/robot0/odom'); % Subscripción a la odometría

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist'); %
msg_vel=rosmessage(pub); %% Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)

%% Definimos la perodicidad del bucle (10 hz)
r = robotics.Rate(rate);
waitfor(r);

%% Instanciacion de los objetos de la clase PID
pid_v = tpm(kp, td, ti, rate, v_max);
pid_w = tpm(kp, td, ti, rate, w_max);

%% Umbrales para condiciones de parada del robot
umbral_distancia = 0.1;
umbral_angulo = 0.02;

%% Bucle de control infinito
while (1)
    %% Obtenemos la posición y orientación actuales
    odom = receive(odom_sub, 10);
    pos=odom.Pose.Pose.Position;
    X = pos.X;
    Y = pos.Y;
    ori=odom.Pose.Pose.Orientation;
    yaw=quat2eul([ori.W ori.X ori.Y ori.Z]);
    yaw=yaw(1);

    %% Calculamos el error de distancia
    error_lineal = sqrt(((X-Xp)^2)+((Y-Yp)^2));

    %% Calculamos el error de orientación
    error_angular = atan2((Yp-Y),(Xp-X))-yaw
    if (abs(error_angular) >= 6.2)
        error_angular = 0;
    end

    %% Calculamos las consignas de velocidades
    consigna_vel_linear = pid_v.getSpeed(error_lineal);
    consigna_vel_ang = pid_w.getSpeed(error_angular);

    %% Comienza el control
    % El robot tiene bien la posicion y orientacion
    if (abs(error_lineal)<umbral_distancia) 
        msg_vel.Angular.Z = 0;
        msg_vel.Linear.X = 0;
        send(pub,msg_vel);
        break;
    else
        if (abs(error_angular) > umbral_angulo && control_giro)
            msg_vel.Angular.Z= consigna_vel_ang;
            msg_vel.Linear.X= 0;
        else
            control_giro = false;
            msg_vel.Angular.Z=0;
            msg_vel.Linear.X= consigna_vel_linear;
        end
    end

    % Comando de velocidad
    send(pub,msg_vel);

    % Temporización del bucle según el parámetro establecido en r
    waitfor(r);
end


% subplot(2, 1, 1);
% plot(array_lineal, "r")
% hold on;
% plot(array_ang, "b")
% xlabel("Tiempo")
% ylabel("Velocidad")
% legend('Velocidad lineal', 'Velocidad angular');
% 
% subplot(2, 1, 2);
% plot(error_lin, "r")
% hold on;
% plot(error_angu, "b")
% xlabel("Tiempo")
% ylabel("Error")
% legend('Error lineal', 'Error angular');

%% DESCONEXIÓN DE ROS
rosshutdown;