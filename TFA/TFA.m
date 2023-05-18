%% DESCONEXIÓN DE ROS
rosshutdown;

%% INICIALIZACIÓN DE ROS (COMPLETAR ESPACIOS CON LAS DIRECCIONES IP)
setenv('ROS_MASTER_URI','http://192.168.1.19:11311');
setenv('ROS_IP','192.168.1.7');
rosinit(); % Inicialización de ROS en la IP correspondiente

%% DECLARACIÓN DE SUBSCRIBERS
odom_sub = rossubscriber('/robot0/odom'); % Subscripción a la odometría
laser_sub = rossubscriber('/robot0/laser_1');
r = robotics.Rate(10);
waitfor(r);

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist'); %
msg_vel=rosmessage(pub); %% Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)

disp("dgerge")
laser1 = receive(laser_sub, 10)
showdetails(laser1)


%% DESCONEXIÓN DE ROS
rosshutdown;