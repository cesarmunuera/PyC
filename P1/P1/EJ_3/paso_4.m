%% INICIALIZACIÓN DE ROS
% Se definen las variables de entorno ROS_MASTER_URI (ip del Master) y ROS_IP (IP de la máquina donde se ejecuta Matlab). Si se está conectado a la misma red, la variable ROS_IP no es necesario definirla.
setenv('ROS_MASTER_URI','http://172.29.30.172:11311')
setenv('ROS_IP','172.29.29.72')
rosshutdown
rosinit

%%
odom_sub = rossubscriber('/pose'); % Subscripción a la odometría
odom = receive(odom_sub, 10);
pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist');

%% activamos los motores
pub_motor = rospublisher('/cmd_motor_state', 'std_msgs/Int32');
msg_motor = rosmessage(pub_motor);
msg_motor.Data = 1;
send(pub_motor,msg_motor)

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
avanzar(2, odom_sub, pub)
girar(90, odom_sub, pub)
avanzar(1, odom_sub, pub)
girar(-90, odom_sub, pub)
avanzar(1, odom_sub, pub)


%% Creamos una funcion que recibe como parametros los metros que se desea recorrer
function avanzar(metros, subs, pub)

odom = receive(subs, 10);
msg=rosmessage(pub);

%Primero vemos donde se encuentra el robot
pos_X = odom.Pose.Pose.Position.X;
metros_a_recorrer = pos_X + metros;

    %Ahora debe avanzar los metros que se pidan, a partir de esa posición
    while(pos_X < metros_a_recorrer)
        msg.Linear.X = 0.2;
        send(pub,msg);
        odom = receive(subs, 10);
        pos_X = odom.Pose.Pose.Position.X;
    end
    msg.Linear.X = 0;
    send(pub,msg);
end

%% Creamos una funcion que recibe como parametros los grados que se desea girar
function girar(grados, subs, pub)

odom = receive(subs, 10);
msg=rosmessage(pub);

%Primero vemos donde se encuentra el robot
odom = receive(subs, 10);
pos_Z = abs(odom.Pose.Pose.Orientation.Z);
pos_ant = pos_Z;
vel = 0.2;
numGrados = toNum(grados);
dis_reco = 0;
    %Ahora debe girar los grados que se pidan, a partir de esa posición
    if(grados < 0)
        vel = -vel;
    end

    while(dis_reco <= numGrados)
    msg.Angular.Z = vel;
    send(pub,msg);
    odom = receive(subs, 10);
    pos_Z = abs(odom.Pose.Pose.Orientation.Z);

    if (pos_ant > pos_Z)
        dis_reco = dis_reco + (1 - (pos_Z - pos_ant));
    else
        dis_reco = dis_reco + (pos_Z - pos_ant);
    end

    pos_ant = pos_Z;
    end
    msg.Angular.Z = 0;
    send(pub,msg);

end

%% Creamos una funcion que pase de grados al sistema de representacion del robot
function result = toNum(grados)
    result = abs(grados / 180);
end