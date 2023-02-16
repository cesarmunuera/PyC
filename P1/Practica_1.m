%% INICIALIZACIÓN DE ROS
% Se definen las variables de entorno ROS_MASTER_URI (ip del Master) y ROS_IP (IP de la máquina donde se ejecuta Matlab). Si se está conectado a la misma red, la variable ROS_IP no es necesario definirla.
setenv('ROS_MASTER_URI','http://172.22.71.5:11311')
setenv('ROS_IP','172.22.33.17')
rosshutdown
rosinit % Inicialización de ROS
%% DECLARACIÓN DE SUBSCRIBERS
odom_sub=rossubscriber('/robot0/odom'); % Subscripción a la odometría
%% Nos aseguramos recibir un mensaje relacionado con el robot "robot0"
odom = receive(odom_sub, 10)
odom

%% Obtenemos la posición actual
pos=odom.Pose.Pose.Position;

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist');
%% GENERACIÓN DE MENSAJE
msg=rosmessage(pub) %% Creamos un mensaje del tipo declarado en "pub"(geometry_msgs/Twist)
% Rellenamos los campos del mensaje para que el robot avance a 0.2 m/s
% Velocidades lineales en x,y y z (velocidades en y o z no se usan enrobots diferenciales y entornos 2D)
msg.Linear.X=0.2;
msg.Linear.Y=0;
msg.Linear.Z=0;
% Velocidades angulares (en robots diferenciales y entornos 2D solo seutilizará el valor Z)
msg.Angular.X=0;
msg.Angular.Y=0;
msg.Angular.Z=0;
%% Definimos la perodicidad del bucle (10 hz)
r = robotics.Rate(10);
%% Bucle de control infinito
while (1)
send(pub,msg);
% Temporización del bucle según el parámetro establecido en r
waitfor(r)
end