%% DESCONEXIÓN DE ROS
rosshutdown;

%% INICIALIZACIÓN DE ROS (COMPLETAR ESPACIOS CON LAS DIRECCIONES IP)
setenv('ROS_MASTER_URI','http://192.168.1.28:11311');
setenv('ROS_IP','192.168.1.7');
rosinit(); 

%% DECLARACIÓN DE SUBSCRIBERS
odom_sub = rossubscriber('/robot0/odom'); 
laser_sub = rossubscriber('/robot0/laser_1');
sonar_sub0=rossubscriber('/robot0/sonar_0');
sonar_sub5=rossubscriber('/robot0/sonar_5');
r = robotics.Rate(10);
waitfor(r);

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist');
msg_vel=rosmessage(pub); 

%% Ejecucion principal del programa
[grafo, nodo_inicio, nodo_fin, mapa_nodos] = Script1(odom_sub, laser_sub, sonar_sub0, sonar_sub5, pub, msg_vel);
Script2(odom_sub, pub, msg_vel, grafo, nodo_inicio, nodo_fin, mapa_nodos);


%% DESCONEXIÓN DE ROS
rosshutdown;