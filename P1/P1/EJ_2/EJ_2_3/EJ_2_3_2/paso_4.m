%% INICIALIZACIÓN DE ROS
% Se definen las variables de entorno ROS_MASTER_URI (ip del Master) y ROS_IP (IP de la máquina donde se ejecuta Matlab). Si se está conectado a la misma red, la variable ROS_IP no es necesario definirla.
setenv('ROS_MASTER_URI','http://192.168.1.23:11311')
setenv('ROS_IP','192.168.1.5')
rosshutdown
rosinit % Inicialización de ROS

%% DECLARACIÓN DE SUBSCRIBERS
laser_sub=rossubscriber('/robot0/laser_0'); % Subscripción a la odometría

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist');

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
laser0 = receive(laser_sub, 10);
contador = 1;
aux1 = [];
arrayFilrado = [];

%% Comienza el programa
for i = 1:1001
    aux1(i) = laser0.Ranges(1);
end

arrayFiltrado = movmean(aux1,5); % aplicamos un filtro de media móvil con ventana de longitud 5

plot(aux1,'r'); 
hold on; 
plot(arrayFiltrado,'b');
title('Ejercicio 5.2, apartado 4')
xlabel('Numero de muestras')
ylabel('Distancia')
legend('Datos sin filtrar', 'Datos filtrados')