%% INICIALIZACIÓN DE ROS
% Se definen las variables de entorno ROS_MASTER_URI (ip del Master) y ROS_IP (IP de la máquina donde se ejecuta Matlab). Si se está conectado a la misma red, la variable ROS_IP no es necesario definirla.
setenv('ROS_MASTER_URI','http://192.168.1.23:11311')
setenv('ROS_IP','192.168.1.5')
rosshutdown
rosinit % Inicialización de ROS

%% DECLARACIÓN DE SUBSCRIBERS
sonar_sub0=rossubscriber('/robot0/sonar_0'); % Subscripción a la odometría
sonar_sub1=rossubscriber('/robot0/sonar_1');
sonar_sub2=rossubscriber('/robot0/sonar_2');
sonar_sub3=rossubscriber('/robot0/sonar_3');
sonar_sub4=rossubscriber('/robot0/sonar_4');

odom_sub=rossubscriber('/robot0/odom');

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist');

%% GENERACIÓN DE MENSAJE
msg=rosmessage(pub) %% Creamos un mensaje del tipo declarado en "pub"(geometry_msgs/Twist)
% Velocidades lineales en x,y y z (velocidades en y o z no se usan enrobots diferenciales y entornos 2D)
msg.Linear.X=0.1;
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

%% Comienza el programa
while (1)

    sonar0 = receive(sonar_sub0, 10);
    sonar1 = receive(sonar_sub1, 10);
    sonar2 = receive(sonar_sub2, 10);
    sonar3 = receive(sonar_sub3, 10);
    sonar4 = receive(sonar_sub4, 10);

    if (sonar3.Range_ < 3 || sonar4.Range_ < 3)
        sonarTrasero = 2;
    else
        sonarTrasero = 4;
    end

    if (sonar0.Range_ < 3 && sonar1.Range_ > 3 && sonar2.Range_ > 3 && sonarTrasero > 3)
        disp('1');
    elseif (sonar0.Range_ > 3 && sonar1.Range_ > 3 && sonar2.Range_ < 3 && sonarTrasero > 3)
        disp('2');
    elseif (sonar0.Range_ > 3 && sonar1.Range_ > 3 && sonar2.Range_ > 3 && sonarTrasero < 3)
        disp('3');
    elseif (sonar0.Range_ > 3 && sonar1.Range_ < 3 && sonar2.Range_ > 3 && sonarTrasero > 3)
        disp('4');
    elseif (sonar0.Range_ < 3 && sonar1.Range_ > 3 && sonar2.Range_ < 3 && sonarTrasero > 3)
        disp('5');
    elseif (sonar0.Range_ < 3 && sonar1.Range_ > 3 && sonar2.Range_ > 3 && sonarTrasero < 3)
        disp('6');
    elseif (sonar0.Range_ < 3 && sonar1.Range_ < 3 && sonar2.Range_ > 3 && sonarTrasero > 3)
        disp('7');
    elseif (sonar0.Range_ > 3 && sonar1.Range_ > 3 && sonar2.Range_ < 3 && sonarTrasero < 3)
        disp('8');
    elseif (sonar0.Range_ > 3 && sonar1.Range_ < 3 && sonar2.Range_ < 3 && sonarTrasero > 3)
        disp('9');
    elseif (sonar0.Range_ > 3 && sonar1.Range_ < 3 && sonar2.Range_ > 3 && sonarTrasero < 3)
        disp('10');
    elseif (sonar0.Range_ < 3 && sonar1.Range_ > 3 && sonar2.Range_ < 3 && sonarTrasero < 3)
        disp('11');
    elseif (sonar0.Range_ > 3 && sonar1.Range_ < 3 && sonar2.Range_ < 3 && sonarTrasero < 3)
        disp('12');
    elseif (sonar0.Range_ < 3 && sonar1.Range_ < 3 && sonar2.Range_ > 3 && sonarTrasero < 3)
        disp('13');
    elseif (sonar0.Range_ < 3 && sonar1.Range_ < 3 && sonar2.Range_ < 3 && sonarTrasero > 3)
        disp('14');
    elseif (sonar0.Range_ < 3 && sonar1.Range_ < 3 && sonar2.Range_ < 3 && sonar1.Range_ < 3)
        disp('15');
    else
        disp('0');
    end

    waitfor(r);
end