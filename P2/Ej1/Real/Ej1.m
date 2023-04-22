%% DESCONEXIÓN DE ROS
rosshutdown;

%% INICIALIZACIÓN DE ROS (COMPLETAR ESPACIOS CON LAS DIRECCIONES IP)
setenv('ROS_MASTER_URI','http://172.29.30.172:11311');
setenv('ROS_IP','172.29.29.55');
rosinit() % Inicialización de ROS en la IP correspondiente

%% DECLARACIÓN DE VARIABLES NECESARIAS PARA EL CONTROL
Xp = 0.5;
Yp = 0.5;
v_max = 1;
w_max = 0.5;
kp = 0.3;
td = 0.5;
ti = 0.1;
rate = 10;
array_lineal = [];
array_ang = [];
error_lin = [];
error_angu = [];

%% activamos los motores
pub_motor = rospublisher('/cmd_motor_state', 'std_msgs/Int32');
msg_motor = rosmessage(pub_motor);
msg_motor.Data = 1;
send(pub_motor,msg_motor);

%% DECLARACIÓN DE SUBSCRIBERS
odom_sub = rossubscriber('/pose'); % Subscripción a la odometría
odom = receive(odom_sub, 10)

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist');
msg_vel=rosmessage(pub); %% Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)

%% Definimos la perodicidad del bucle (10 hz)
r = robotics.Rate(rate);
waitfor(r);

%% Instanciacion de los objetos de la clase PID
pid_v = tpm(kp, td, ti, rate, 1);
pid_w = tpm(kp, td, ti, rate, 0.5);

%% Umbrales para condiciones de parada del robot
umbral_distancia = 0.05;
umbral_angulo = 0.01;

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
    error_angular = atan2((Yp-Y),(Xp-X))-yaw;

    error_lin = [error_lin, error_lineal];
    error_angu = [error_angu, error_angular];

    %% Calculamos las consignas de velocidades
    consigna_vel_linear = pid_v.getSpeed(error_lineal);
    consigna_vel_ang = pid_w.getSpeed(error_angular);

    array_lineal = [array_lineal, consigna_vel_linear];
    array_ang = [array_ang, consigna_vel_ang];


    %% Comienza el control
    % El robot tiene bien la posicion y orientacion
    if (error_lineal<umbral_distancia) && (abs(error_angular)<umbral_angulo) 
        msg_vel.Angular.Z = 0;
        msg_vel.Linear.X = 0;
        send(pub,msg_vel);
        break;
    % El robot tiene bien solamente la posicion
    elseif (error_lineal<umbral_distancia)
        msg_vel.Linear.X = 0;
        msg_vel.Angular.Z= consigna_vel_ang;
    %El robot tiene bien solamente la orientacion
    elseif (abs(error_angular)<umbral_angulo)
        msg_vel.Angular.Z = 0;
        msg_vel.Linear.X= consigna_vel_linear;
    % El robot no tiene bien ninguna de las dos
    else
        msg_vel.Linear.X= consigna_vel_linear;
        msg_vel.Linear.Y=0;
        msg_vel.Linear.Z=0;
        msg_vel.Angular.X=0;
        msg_vel.Angular.Y=0;
        msg_vel.Angular.Z= consigna_vel_ang;
    end

    % Comando de velocidad
    send(pub,msg_vel);

    % Temporización del bucle según el parámetro establecido en r
    waitfor(r);
end

subplot(2, 1, 1);
plot(array_lineal, "r")
hold on;
plot(array_ang, "b")
xlabel("Tiempo")
ylabel("Velocidad")
legend('Velocidad lineal', 'Velocidad angular');

subplot(2, 1, 2);
plot(error_lin, "r")
hold on;
plot(error_angu, "b")
xlabel("Tiempo")
ylabel("Error")
legend('Error lineal', 'Error angular');

%% DESCONEXIÓN DE ROS
rosshutdown;