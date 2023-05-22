function girar(giros, odom_sub, pub, msg_vel)
    %% Decripcion:
    % Esta fucnion es la encargada de girar el robot, en funcion de las
    % necesidades (algoritmo con obtener_paredes.m). Cuando se llama a esta
    % funcion, se sabe a donde se tiene que girar, aqui no se decide el
    % giro. 
    % Se usa la acumulacion del giro para parar. Hay 3 casos. Si se tiene
    % que girar a la izquierda pi/2, a la izquierda pi, o a la derecha
    % pi/2, pero con velocidad negativa.

    %% Variables    
    angulo_acumulado = 0;
    vel_max = 0.9;
    vel_min = 0.05;
    angulo_a_recorrer = 1.5707;
    rate = 10;

    %% Definimos la perodicidad del bucle (10 hz)
    r = robotics.Rate(rate);
    waitfor(r);

    %% Recogemos primeros valores
    odom = receive(odom_sub,10);
    quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
    euler=quat2eul(quaternion,'ZYX');
    theta_original = abs(euler(1));


    %% Si tenemos que hacer un giro de 270 lo cambiamos a uno de 90 en sentido contrario
    if(giros == 3)
        vel_max = -vel_max;
        vel_min = -vel_min;
        giros = 1;
    end

    %% Si tenemos que hacer un giro 180, cambiamos el angulo a recorrer a pi
    if (giros == 2)
        angulo_a_recorrer = round(pi, 4);
    end

    %% Cuerpo del pograma principal
    msg_vel.Angular.Z = vel_max;
    send(pub,msg_vel);
    
    theta_anterior = theta_original;
    while(angulo_a_recorrer > angulo_acumulado)
        % Obtenemos el theta actual
        odom = receive(odom_sub,10);
        quaternion=[odom.Pose.Pose.Orientation.W odom.Pose.Pose.Orientation.X odom.Pose.Pose.Orientation.Y odom.Pose.Pose.Orientation.Z];
        euler=quat2eul(quaternion,'ZYX');
        theta_actual=abs(euler(1));

        % Calculamos cuanto se ha girado y se lo sumamos al giro acumulado
        dist_dif = abs(theta_actual - theta_anterior);
        angulo_acumulado = angulo_acumulado + dist_dif;

        % Si estamos cerca de llegar al angulo previsto, bajamos la
        % velocidad para que no nos pasemos.
        if(angulo_acumulado >= angulo_a_recorrer - 0.15)
            msg_vel.Angular.Z = vel_min;
            send(pub,msg_vel);
        end
        theta_anterior = theta_actual;

        % Temporización del bucle según el parámetro establecido en r
        waitfor(r);
    end

    msg_vel.Angular.Z = 0;
    send(pub,msg_vel);
end