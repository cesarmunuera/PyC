%% DESCONEXIÓN DE ROS
rosshutdown;

%% INICIALIZACIÓN DE ROS (COMPLETAR ESPACIOS CON LAS DIRECCIONES IP)
setenv('ROS_MASTER_URI','http://172.29.29.62:11311');
setenv('ROS_IP','172.29.29.47');
rosinit(); % Inicialización de ROS en la IP correspondiente

%% DECLARACIÓN DE SUBSCRIBERS
odom_sub = rossubscriber('/robot0/odom') % Subscripción a la odometría
r = robotics.Rate(10);
waitfor(r);
x = 0;

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist'); %
msg_vel=rosmessage(pub); %% Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)

odom = receive(odom_sub, 10)

odom.showdetails

 msg_vel.Angular.Z = 0.3;
 send(pub,msg_vel);

 odom.showdetails

 while(x<150)
     x = x +1;
    odom.Pose.Pose.Orientation.W
    odom.showdetails
    waitfor(r);
 end

%% DESCONEXIÓN DE ROS
rosshutdown;