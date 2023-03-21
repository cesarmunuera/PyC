%% INICIALIZACIÓN DE ROS
% Se definen las variables de entorno ROS_MASTER_URI (ip del Master) y ROS_IP (IP de la máquina donde se ejecuta Matlab). Si se está conectado a la misma red, la variable ROS_IP no es necesario definirla.
setenv('ROS_MASTER_URI','http://172.29.30.176:11311')
setenv('ROS_IP','172.29.29.72')
rosshutdown
rosinit % Inicialización de ROS

%% Activamos los motores
pub_motor = rospublisher('/cmd_motor_state', 'std_msgs/Int32');
msg_motor = rosmessage(pub_motor);
msg_motor.Data = 1;
send(pub_motor,msg_motor)

%% DECLARACIÓN DE SUBSCRIBERS
sonar0_sub=rossubscriber('/sonar_0');
sonar1_sub=rossubscriber('/sonar_1');
sonar2_sub=rossubscriber('/sonar_2');
sonar3_sub=rossubscriber('/sonar_3');
sonar4_sub=rossubscriber('/sonar_4');
sonar5_sub=rossubscriber('/sonar_5');
sonar6_sub=rossubscriber('/sonar_6');
sonar7_sub=rossubscriber('/sonar_7');

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist');

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
dist = 4.5;
contador = 0;
c0 = 0;
c3 = 0;
c5 = 0;
ctrasero = 0;

%% Comienza el programa
while (contador < 100)

    sonar0 = receive(sonar0_sub, 10);
    sonar3 = receive(sonar3_sub, 10);
    sonar5 = receive(sonar5_sub, 10);
    sonar6 = receive(sonar6_sub, 10);
    sonar7 = receive(sonar7_sub, 10);


    if (sonar6.Range_ < dist || sonar7.Range_ < dist)
        sonarTrasero = 2;
    else
        sonarTrasero = 5;
    end


    if (sonar3.Range_ < dist && sonar0.Range_ > dist && sonar5.Range_ > dist && sonarTrasero > dist)
        disp('1');
    elseif (sonar3.Range_ > dist && sonar0.Range_ > dist && sonar5.Range_ < dist && sonarTrasero > dist)
        disp('2');
    elseif (sonar3.Range_ > dist && sonar0.Range_ > dist && sonar5.Range_ > dist && sonarTrasero < dist)
        disp('3');
    elseif (sonar3.Range_ > dist && sonar0.Range_ < dist && sonar5.Range_ > dist && sonarTrasero > dist)
        disp('4');
    elseif (sonar3.Range_ < dist && sonar0.Range_ > dist && sonar5.Range_ < dist && sonarTrasero > dist)
        disp('5');
    elseif (sonar3.Range_ < dist && sonar0.Range_ > dist && sonar5.Range_ > dist && sonarTrasero < dist)
        disp('6');
    elseif (sonar3.Range_ < dist && sonar0.Range_ < dist && sonar5.Range_ > dist && sonarTrasero > dist)
        disp('7');
    elseif (sonar3.Range_ > dist && sonar0.Range_ > dist && sonar5.Range_ < dist && sonarTrasero < dist)
        disp('8');
    elseif (sonar3.Range_ > dist && sonar0.Range_ < dist && sonar5.Range_ < dist && sonarTrasero > dist)
        disp('9');
    elseif (sonar3.Range_ > dist && sonar0.Range_ < dist && sonar5.Range_ > dist && sonarTrasero < dist)
        disp('10');
    elseif (sonar3.Range_ < dist && sonar0.Range_ > dist && sonar5.Range_ < dist && sonarTrasero < dist)
        disp('11');
    elseif (sonar3.Range_ > dist && sonar0.Range_ < dist && sonar5.Range_ < dist && sonarTrasero < dist)
        disp('12');
    elseif (sonar3.Range_ < dist && sonar0.Range_ < dist && sonar5.Range_ > dist && sonarTrasero < dist)
        disp('13');
    elseif (sonar3.Range_ < dist && sonar0.Range_ < dist && sonar5.Range_ < dist && sonarTrasero > dist)
        disp('14');
    elseif (sonar3.Range_ < dist && sonar0.Range_ < dist && sonar5.Range_ < dist && sonarTrasero < dist)
        disp('15');
    else
        disp('0');
    end


    if (sonar0.Range_ < dist)
        c0 = c0 + 1;
    end

    if (sonar3.Range_ < dist)
        c3 = c3 + 1;
    end

    if (sonar3.Range_ < dist)
        c5 = c5 + 1;
    end

    if (sonar6.Range_ < dist || sonar7.Range_ < dist)
        ctrasero = ctrasero + 1;
    end

    contador = contador + 1;

    waitfor(r);
end

disp("La fiabilidad del sonar 0 es del " + c0 + " %.")
disp("La fiabilidad del sonar 3 es del " + c3 + " %.")
disp("La fiabilidad del sonar 5 es del " + c5 + " %.")
disp("La fiabilidad del sonar trasero es del " + ctrasero + " %.")