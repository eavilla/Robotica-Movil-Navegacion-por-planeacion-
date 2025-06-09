% Ruta planificada (path)
path = [... 
    0, 1.2;
    0.0368, 1.2017;
    0.2660, 1.1570;
    0.2986, 1.1057;
    0.4915, 1.1414;
    0.7007, 1.0461;
    0.7208, 1.1061;
    0.7930, 1.1318;
    0.8945, 1.1203;
    0.9111, 0.9511;
    0.9288, 0.9027;
    1.0564, 0.8777;
    1.2170, 0.9440;
    1.2037, 0.8203;
    1.2053, 0.6428;
    1.2240, 0.3914;
    1.1581, 0.3726;
    1.1279, 0.3412;
    1.1535, 0.2361;
    1.2158, 0.0073;
    1.2, 0
];

%% --- Conectar con CoppeliaSim ---
disp('Conectando a CoppeliaSim...');
vrep = remApi('remoteApi');
vrep.simxFinish(-1);
clientID = vrep.simxStart('127.0.0.1', 19997, true, true, 5000, 5);

if clientID == -1
    error('No se pudo conectar a CoppeliaSim');
end

disp('Conectado a CoppeliaSim');

vrep.simxStartSimulation(clientID, vrep.simx_opmode_blocking);

%% --- Obtener handles ---
[~, leftMotor] = vrep.simxGetObjectHandle(clientID, 'ePuck_leftJoint', vrep.simx_opmode_blocking);
[~, rightMotor] = vrep.simxGetObjectHandle(clientID, 'ePuck_rightJoint', vrep.simx_opmode_blocking);
[~, robotHandle] = vrep.simxGetObjectHandle(clientID, 'ePuck', vrep.simx_opmode_blocking);

vrep.simxGetObjectPosition(clientID, robotHandle, -1, vrep.simx_opmode_streaming);
vrep.simxGetObjectOrientation(clientID, robotHandle, -1, vrep.simx_opmode_streaming);
pause(0.2);

%% --- Parámetros del robot ---
L = 0.053;
r = 0.02122;
dt = 0.05;
Kp_v = 1.8;
Kp_w = 3.0;
goalRadius = 1.73;

%% --- Seguir la ruta ---
disp('Siguiendo ruta...');
for idx = 1:size(path, 1)
    target = path(idx, :);
    while true
        [~, pos] = vrep.simxGetObjectPosition(clientID, robotHandle, -1, vrep.simx_opmode_buffer);
        [~, ori] = vrep.simxGetObjectOrientation(clientID, robotHandle, -1, vrep.simx_opmode_buffer);
        x = pos(1);
        y = pos(2);
        theta = ori(1);  % Asumido en radianes

        dx = target(1) - x;
        dy = target(2) - y;
        distance = sqrt(dx^2 + dy^2);
        fprintf('dx=%.2f, dy=%.2f,x=%.2f, y=%.2f, θ=%.2f, target=[%.2f %.2f]\n', dx, dy, x, y, theta, target(1), target(2));
        if distance < goalRadius
            break;
        end

        alpha = atan2(dx, dy) - theta;
        alpha = atan2(sin(alpha), cos(alpha));

        v = Kp_v * distance;
        w = Kp_w * alpha;

        vL = (2*v - w*L) / (2*r);
        vR = (2*v + w*L) / (2*r);

        vL = max(min(vL, 5), -5);
        vR = max(min(vR, 5), -5);

        vrep.simxSetJointTargetVelocity(clientID, leftMotor, vL, vrep.simx_opmode_streaming);
        vrep.simxSetJointTargetVelocity(clientID, rightMotor, vR, vrep.simx_opmode_streaming);


        pause(dt);
    end
end

%% --- Finalizar simulación ---
vrep.simxStopSimulation(clientID, vrep.simx_opmode_blocking);
vrep.simxFinish(clientID);
vrep.delete();

disp('Ruta completada.');


%% --- Detener el robot ---
vrep.simxSetJointTargetVelocity(clientID, leftMotor, 0, vrep.simx_opmode_streaming);
vrep.simxSetJointTargetVelocity(clientID, rightMotor, 0, vrep.simx_opmode_streaming);
pause(0.5);

%% --- Finalizar simulación ---
vrep.simxStopSimulation(clientID, vrep.simx_opmode_blocking);
vrep.simxFinish(clientID);
vrep.delete();

disp('Ruta completada.');