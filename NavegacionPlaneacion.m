%% ===============================
%  PLANEACIÓN DE RUTAS CON PRM Y RRT
%  Fundamentos de Robótica Móvil - UNAL
%  ===============================

clear all; close all; clc;

% ===============================
% 1. Cargar mapa binario y configurar el entorno
% ===============================

load('Celdas_binarias_ejercicio.mat');

%Caracteristicas del robot

L=(0.054/2); %Radio robot (m)
Rr=0.02117; %Radio de la rueda(m)

% Crear mapa de ocupación
resolucion = 40;             % Celdas por metro
tamano_mapa = 52 / resolucion;  % 1.3 metros
Mapa = binaryOccupancyMap(tamano_mapa, tamano_mapa, resolucion);
setOccupancy(Mapa, sm4b);   % Cargar datos al mapa

% Mostrar mapa original
figure(1); show(Mapa); title('Mapa Original');

% Crear copia para inflar
MapaInflado = copy(Mapa);  % <- muy importante
inflate(MapaInflado, L);

% Mostrar mapa inflado
figure(2); show(MapaInflado); title('Mapa Inflado');

% ==============================
% 1. Planeación con PRM
% ==============================
prm = mobileRobotPRM;
prm.Map = MapaInflado;          % Usamos el mapa inflado
prm.NumNodes = 300;             % Número de nodos del roadmap
prm.ConnectionDistance = 0.2;   % Distancia de conexión entre nodos (ajustable)

% Puntos de inicio y fin (en metros, dentro del mapa 13x13)
startLocation = [0.1, 1.2];   % Esquina inferior izquierda
endLocation = [1.2, 0.1];   % Esquina superior derecha (ajustar según ocupación)

% Encontrar camino
% Se encarga de calcular una ruta óptima entre dos puntos usando el grafo generado por el planificador PRM (mobileRobotPRM).
% Utiliza Dijkstra (u otro algoritmo similar de grafos) para encontrar la ruta más corta entre los nodos más cercanos a los puntos de inicio y fin.
path = findpath(prm, startLocation, endLocation);

% ==============================
% 2. Planeación con RRT
% ==============================

% Espacio de estados SE2 (x, y, orientación)
ss = stateSpaceSE2;

% Definir límites según el mapa inflado
ss.StateBounds = [MapaInflado.XWorldLimits; 
                  MapaInflado.YWorldLimits; 
                  [-pi pi]];

% Validador de colisiones basado en occupancy map
sv = validatorOccupancyMap(ss);
sv.Map = MapaInflado;
sv.ValidationDistance = 0.15;  % menor distancia para validación más precisa

% Crear el planificador RRT
planner = plannerRRT(ss, sv);
planner.MaxIterations = 100000;
planner.MaxConnectionDistance = 0.5;

% Pose inicial y final (x, y, theta)
startPose = [startLocation 0];  % Ajusta según tu mapa
goalPose = [endLocation 0];
% Planear ruta
[pthObj, solnInfo] = plan(planner, startPose, goalPose);

% ==============================
% 3. Visualización en Subplots
% ==============================
figure

% Subplot 1: PRM con grafo
subplot(2,2,1)
show(prm)
title('PRM - Mapa inflado y grafo')
axis equal

% Subplot 2: Ruta PRM sobre mapa original
subplot(2,2,2);
show(Mapa); hold on;
if ~isempty(path)
    plot(path(:,1), path(:,2), 'r-', 'LineWidth', 2);
end
plot(startLocation(1), startLocation(2), 'go', 'MarkerSize', 8, 'LineWidth', 2);
plot(endLocation(1), endLocation(2), 'mo', 'MarkerSize', 8, 'LineWidth', 2);
title('Ruta Óptima con PRM');
legend('Ruta PRM', 'Inicio', 'Meta');
axis equal;

% Subplot de RRT
subplot(2,2,3)
show(MapaInflado); hold on
title('Ruta óptima con RRT')

% Graficar nodos explorados (grafo)
if isfield(solnInfo, 'TreeData') && ~isempty(solnInfo.TreeData)
    plot(solnInfo.TreeData(:,1), solnInfo.TreeData(:,2), 'b.', 'MarkerSize', 5);
end

% Subplot 4: Ruta PRM sobre mapa original
subplot(2,2,4);
show(Mapa); hold on;

% Graficar ruta si existe
if ~isempty(pthObj.States)
    plot(pthObj.States(:,1), pthObj.States(:,2), 'r-', 'LineWidth', 2);
    plot(startPose(1), startPose(2), 'go', 'MarkerSize', 10, 'LineWidth', 2);
    plot(goalPose(1),  goalPose(2),  'mo', 'MarkerSize', 10, 'LineWidth', 2);
end
title('Ruta Óptima con RRT');
legend('Ruta PRM', 'Inicio', 'Meta');
axis equal