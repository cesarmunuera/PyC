%% DESCONEXIÓN DE ROS
rosshutdown;

%% INICIALIZACIÓN DE ROS (COMPLETAR ESPACIOS CON LAS DIRECCIONES IP)
setenv('ROS_MASTER_URI','http://192.168.1.140:11311');
setenv('ROS_IP','192.168.1.15');
rosinit(); % Inicialización de ROS en la IP correspondiente

%% DECLARACIÓN DE SUBSCRIBERS
odom_sub = rossubscriber('/robot0/odom'); % Subscripción a la odometría
laser_sub = rossubscriber('/robot0/laser_1');
r = robotics.Rate(10);
waitfor(r);

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist'); %
msg_vel=rosmessage(pub); %% Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)
msg_vel.Angular.Z=0.1;
send(pub,msg_vel);
laser1 = receive(laser_sub, 10);
while (1)
    odom = receive(odom_sub,10);
    odom.Pose.Pose.Orientation
    quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
    euler=quat2eul(quaternion,'ZYX');
    % Guardamos en Theta el primer campo devuelto por la función de Euler
    Theta=euler(1)
end

%% DESCONEXIÓN DE ROS
rosshutdown;