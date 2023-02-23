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
%%odom
%%showdetails(odom)

%% Obtenemos la posición actual
pos=odom.Pose.Pose.Position;

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist');
%% GENERACIÓN DE MENSAJE
msg=rosmessage(pub) %% Creamos un mensaje del tipo declarado en "pub"(geometry_msgs/Twist)
% Rellenamos los campos del mensaje para que el robot avance a 0.2 m/s
% Velocidades lineales en x,y y z (velocidades en y o z no se usan enrobots diferenciales y entornos 2D)
msg.Linear.X=0.1;
msg.Linear.Y=0;
msg.Linear.Z=0;
% Velocidades angulares (en robots diferenciales y entornos 2D solo seutilizará el valor Z)
msg.Angular.X=0;
msg.Angular.Y=0;
msg.Angular.Z=0;



%% Definimos la perodicidad del bucle (10 hz)
r = robotics.Rate(10);
%%Inicializacion del contador y la poscion
contador = 1;
metros_a_recorrer = 3;
metros_recorridos = 0;
array_pos = [];

%% Bucle de control infinito
while (metros_recorridos < metros_a_recorrer)
send(pub,msg);

odom = receive(odom_sub, 10)
pos_X=odom.Pose.Pose.Position.X

array_pos(contador) = pos_X;
metros_recorridos = pos_X;
contador= contador + 1;
% Temporización del bucle según el parámetro establecido en r
waitfor(r);
end

%%Calculo de q
q_max = 0;
length(array_pos);
for i=2:length(array_pos)
    q= array_pos(i) - array_pos(i-1)
    if q > q_max    
        q_max = q;
    end
end
q_max

