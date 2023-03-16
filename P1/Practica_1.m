%% INICIALIZACIÓN DE ROS
% Se definen las variables de entorno ROS_MASTER_URI (ip del Master) y ROS_IP (IP de la máquina donde se ejecuta Matlab). Si se está conectado a la misma red, la variable ROS_IP no es necesario definirla.
setenv('ROS_MASTER_URI','http://192.168.1.23:11311')
setenv('ROS_IP','192.168.1.5')
rosshutdown
rosinit % Inicialización de ROS

%% DECLARACIÓN DE SUBSCRIBERS
odom_sub=rossubscriber('/robot0/odom'); % Subscripción a la odometría

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

%% Comienza el programa
while (1)

    waitfor(r);
end

%% Creamos una funcion que recibe como parametros los metros que se desea recorrer
function avanzar(metros)
%Primero vemos donde se encuentra el robot
odom = receive(odom_sub, 10);
pos_X = odom.Pose.Pose.Position.X;

metros_a_recorrer = pos_X + metros;

    %Ahora debe avanzar los metros que se pidan, a partir de esa posición
    while(pos_X < metros_a_recorrer)
        msg.Linear.X = 0.2;
        send(pub,msg);
        pos_X = odom.Pose.Pose.Position.X;
    end
    
    msg.Linear.X = 0;
    send(pub,msg);

end

%% Creamos una funcion que recibe como parametros los grados que se desea girar
function girar(grados)
%Primero vemos donde se encuentra el robot
odom = receive(odom_sub, 10);
pos_Z = odom.Pose.Pose.Orientation.Z;
vel = 0.2;
angulo_a_girar = pos_Z + toNum(grados);
    %Ahora debe girar los grados que se pidan, a partir de esa posición
    if(grados < 0)
        while(pos_Z > angulo_a_girar) 
        msg.Angular.Z = -vel;
        send(pub,msg);
        pos_Z = odom.Pose.Pose.Orientation.Z;
        end
    else
        while(pos_Z < angulo_a_girar)
        msg.Angular.Z = vel;
        send(pub,msg);
        pos_Z = odom.Pose.Pose.Orientation.Z;
        end
    end
    msg.Angular.Z = 0.0;
    send(pub,msg);

end

%% Creamos una funcion que pase de grados al sistema de representacion del robot
function result = toNum(grados)
    result = grados / 180;
end