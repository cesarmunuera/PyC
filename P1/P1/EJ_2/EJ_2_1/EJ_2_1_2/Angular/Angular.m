%% INICIALIZACIÓN DE ROS
% Se definen las variables de entorno ROS_MASTER_URI (ip del Master) y ROS_IP (IP de la máquina donde se ejecuta Matlab). Si se está conectado a la misma red, la variable ROS_IP no es necesario definirla.
setenv('ROS_MASTER_URI','http://192.168.1.4:11311')
setenv('ROS_IP','192.168.1.5')
rosshutdown
rosinit % Inicialización de ROS

%% Variables globales
giro = 0.3;

%% DECLARACIÓN DE SUBSCRIBERS
odom_sub=rossubscriber('/robot0/odom'); % Subscripción a la odometría

%% Nos aseguramos recibir un mensaje relacionado con el robot "robot0"
odom = receive(odom_sub, 10);
%%odom
%%showdetails(odom)

%% Obtenemos la posición actual
pos=odom.Pose.Pose.Position;

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
msg.Angular.Z=giro;

%% Definimos la perodicidad del bucle (10 hz)
r = robotics.Rate(10);

%% Variables
vAnt = 0;
vMax = 0;
vAux = 0;
vNuevo = 0;
contador = 0;
continuar = true;

%% Bucle de control infinito
while (continuar)
send(pub,msg);
odom = receive(odom_sub, 10);

pos_Z = odom.Pose.Pose.Orientation.Z

if ((0.95 < pos_Z) && (pos_Z < 1))
    msg.Angular.Z = - giro;
elseif ((0.05 > pos_Z) && (pos_Z > 0))
    msg.Angular.Z = giro;
else
    vAnt = vNuevo;
    vNuevo = pos_Z;
    vAux = vNuevo - vAnt;

    if (vAux < 0)
        vMax = vAux * -1;
    end

    if (vAux > vMax)
        vMax = vAux;
    end

    contador = contador + 1;
    if (contador == 200)
        continuar = false;
    end
end
% Temporización del bucle según el parámetro establecido en r
waitfor(r);
end

vMax