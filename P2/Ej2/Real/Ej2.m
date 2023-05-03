%% DESCONEXIÓN DE ROS
rosshutdown;

%% INICIALIZACIÓN DE ROS (COMPLETAR ESPACIOS CON LAS DIRECCIONES IP)
setenv('ROS_MASTER_URI','http://172.29.30.172:11311');
setenv('ROS_IP','172.29.29.62');
rosinit(); % Inicialización de ROS en la IP correspondiente

%% DECLARACIÓN DE VARIABLES NECESARIAS PARA EL CONTROL
MAX_TIME = 1000; %% Numero máximo de iteraciones
medidas = zeros(5,1000);

%% Declaracion de nuestras variables
rate =10;
kp = 0.1;
ko = 0.8;

%% Activamos los motores
pub_motor = rospublisher('/cmd_motor_state', 'std_msgs/Int32');
msg_motor = rosmessage(pub_motor);
msg_motor.Data = 1;
send(pub_motor,msg_motor);

%% DECLARACIÓN DE SUBSCRIBERS
odom_sub = rossubscriber('/pose'); % Subscripción a la odometría
sonar0 = rossubscriber('/sonar_0', rostype.sensor_msgs_Range);

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist'); 
msg_vel=rosmessage(pub); %% Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)
msg_sonar0=rosmessage(sonar0);

%% Definimos la periodicidad del bucle (10 hz)
r = robotics.Rate(rate);
waitfor(r);

%% Instanciacion de los objetos de la clase PID
pid_w = tpm(kp, ko, v_max);

%% Inicializamos variables para el control
i = 0;
D = 0.5;
last_dist_laser = 0;
last_dist_Y = 0;
last_dist_X = 0;

%% Bucle de control
while (1)
    i = i + 1;

    %% Obtenemos la posición y medidas de sonar
    odom = receive(odom_sub, 10);
    msg_sonar0 = receive(sonar0);
    pos_X = odom.Pose.Pose.Position.X;
    pos_Y = odom.Pose.Pose.Position.Y;

    %% Calculamos la distancia avanzada y medimos la distancia a la pared
    dist_avanzada = sqrt((pos_X - last_dist_X)^2 + (pos_Y - last_dist_Y)^2);
    dist_laser = msg_sonar0.Range_;

    if dist_laser>5
        dist_laser = 5;
    end

    %% Calculamos el error de distancia y orientación
    Eori = atan2((dist_laser - last_dist_laser), dist_avanzada);
    Edist = ((dist_laser + 0.105) * cos(Eori)) - D;

    
    medidas(1,i)= dist_laser;
    medidas(2,i)= last_dist_laser; %% valor anterior de distancia
    medidas(3,i)= dist_avanzada;
    medidas(4,i)= Eori;
    medidas(5,i)= Edist;

    %% Calculamos las consignas de velocidades
    consigna_vel_linear = 0.3;
    consigna_vel_ang = pid_w.getSpeed(Edist,Eori);

    %% Aplicamos consignas de control
    msg_vel.Linear.X= consigna_vel_linear;
    msg_vel.Linear.Y=0;
    msg_vel.Linear.Z=0;
    msg_vel.Angular.X=0;
    msg_vel.Angular.Y=0;
    msg_vel.Angular.Z= consigna_vel_ang;

    % Comando de velocidad
    send(pub,msg_vel);

    %% Actualizamos posiciones y distancias
    last_dist_laser = dist_laser;
    last_dist_X = pos_X;
    last_dist_Y = pos_Y;

    %% Temporización del bucle según el parámetro establecido en r
    waitfor(r);
    if (i==MAX_TIME)
        break;
    end
end

%% Paramos ejecucion
msg_vel.Linear.X = 0;
msg_vel.Angular.Z = 0;
send(pub,msg_vel);

save('medidas.mat','medidas');


%% DESCONEXIÓN DE ROS
rosshutdown;