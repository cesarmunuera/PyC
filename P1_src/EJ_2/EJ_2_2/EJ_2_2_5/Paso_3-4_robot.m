%% INICIALIZACIÓN DE ROS
% Se definen las variables de entorno ROS_MASTER_URI (ip del Master) y ROS_IP (IP de la máquina donde se ejecuta Matlab). Si se está conectado a la misma red, la variable ROS_IP no es necesario definirla.
setenv('ROS_MASTER_URI','http://172.29.30.175:11311')
setenv('ROS_IP','172.29.29.51')
rosshutdown
rosinit % Inicialización de ROS

%% Activamos los motores
pub_motor = rospublisher('/cmd_motor_state', 'std_msgs/Int32');
msg_motor = rosmessage(pub_motor);
msg_motor.Data = 1;
send(pub_motor,msg_motor)

%% DECLARACIÓN DE SUBSCRIBERS
sonar_sub0=rossubscriber('/sonar_0'); % Subscripción a la odometría
% Subscripción a sonar ????

%% DECLARACIÓN DE PUBLISHERS
pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist');

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
contador = 1;
continuar = true;
array = [];
arrayFiltrado = [];

%% Bucle de control infinito

while (contador < 1002)
    sonar0 = receive(sonar_sub0, 10);
    s0 = sonar0.Range_;

    array(contador) = s0;
    contador = contador + 1

    waitfor(r);
end

msg.Angular.X=0;
send(pub,msg);

arrayFiltrado = movmean(array,5); % aplicamos un filtro de media móvil con ventana de longitud 5
plot(array,'r'); 
hold on; 
plot(arrayFiltrado,'b');

title('Ejercicio 2.2.5 Paso 4')
xlabel('Numero de muestras')
ylabel('Distancia')