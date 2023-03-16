%% INICIALIZACIÓN DE ROS
% Se definen las variables de entorno ROS_MASTER_URI (ip del Master) y ROS_IP (IP de la máquina donde se ejecuta Matlab). Si se está conectado a la misma red, la variable ROS_IP no es necesario definirla.
setenv('ROS_MASTER_URI','http://172.29.30.175:11311')
setenv('ROS_IP','172.29.29.51')
rosshutdown
rosinit % Inicialización de ROS

%% Activamos los motores
pub_motor = rospublisher('/cmd_motor_state', 'std_msgs/Int32');
msg_motor = rosmessage(pub_motor);
msg_motor.Data = 1;
send(pub_motor,msg_motor)

%% DECLARACIÓN DE SUBSCRIBERS
sonar0_sub=rossubscriber('/sonar_0');
sonar1_sub=rossubscriber('/sonar_1');
sonar2_sub=rossubscriber('/sonar_2');
sonar3_sub=rossubscriber('/sonar_3');
sonar4_sub=rossubscriber('/sonar_4');
sonar5_sub=rossubscriber('/sonar_5');
sonar6_sub=rossubscriber('/sonar_6');
sonar7_sub=rossubscriber('/sonar_7');

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist');

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
contador = 1;
continuar = true;
array = [];
arrayFiltrado = [];


%% Bucle de control infinito
while (continuar)
    sonar0 = receive(sonar0_sub, 10);
    s0 = sonar0.Range_

    sonar1 = receive(sonar1_sub, 10);
    s1 = sonar1.Range_;

    sonar2 = receive(sonar2_sub, 10);
    s2 = sonar2.Range_;

    sonar3 = receive(sonar3_sub, 10);
    s3 = sonar3.Range_;

    sonar4 = receive(sonar4_sub, 10);
    s4 = sonar4.Range_;

    sonar5 = receive(sonar5_sub, 10);
    s5 = sonar5.Range_;

    sonar6 = receive(sonar6_sub, 10);
    s6 = sonar6.Range_;

    sonar7 = receive(sonar7_sub, 10);
    s7 = sonar7.Range_;


    pause(5);

    waitfor(r);

end
