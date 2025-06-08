# 🤖Robótica Movil 2025-1

## 🪶Autores
* Julian Andres Gonzalez Reina
* Emily Angelica Villanueva Serna
* Elvin Andres Corredor Torres

## ℹ️Navegacion por planeacion (ROBOT ePuck)

### 🏁Objetivos
* Ejecutar las etapas necesarias para crear una ruta ´optima y la simulaci´on de una misi´on de robot con ruedas por el metodo de navegación por planeación.

### Modelo cinematico

### Mapas

Para el inicio de la simulacion se tomo el mapa propuesto, el cual correspondia a una matriz logica de 52x52, donde 0 indica un lugar vacio y el 1 un lugar ocupado. En la Figura 1 se puede evidenciar el mapa graficado con el software Matlab en el que se considero una resolucion de 40 celdas/ metro. Por otro lado, en la figura 2 se puede evidenciar el mapa inflado considerando un radio de inflado de 0.054 el cual corresponde al radio del robot ePuck que se encuentra en CoppeliaSim.

![Figura1](https://github.com/user-attachments/assets/3e8ac12a-0fa6-4d04-92d1-9830fac7473d)

![Figura2](https://github.com/user-attachments/assets/737b7126-0a7c-4303-96f3-134ed966bdbc)

### Planeacion PRM

Una vez con el mapa inflado utilizamos el algoritmo PRM para realizar la planeacion de la ruta asignada (Inicio Superior Izquieda -Salida Inferior Derecha). Para este algoritmo utilizamos la funcion "mobileRobotPRM" la cual establece dentro de un mapa una serie de nodos conectados y junto con la funcion "findpath" calcula una ruta óptima entre dos puntos usando el grafo generado por el planificador PRM (mobileRobotPRM). Los valores de los parametros usados se listan a continuacion:

* prm.NumNodes = 300
* prm.ConnectionDistance = 0.2
* startLocation = [0, 1.2]
* endLocation = [1.2, 0]

La ruta optima encontrada por el algoritmo segun los parametros se presenta en la siguiente tabla.

| Index |    X    |    Y    |
|:-----:|:-------:|:-------:|
|   1   | 0.0000  | 1.2000  |
|   2   | 0.0368  | 1.2017  |
|   3   | 0.2660  | 1.1570  |
|   4   | 0.2986  | 1.1057  |
|   5   | 0.4915  | 1.1414  |
|   6   | 0.7007  | 1.0461  |
|   7   | 0.7208  | 1.1061  |
|   8   | 0.7930  | 1.1318  |
|   9   | 0.8945  | 1.1203  |
|  10   | 0.9111  | 0.9511  |
|  11   | 0.9288  | 0.9027  |
|  12   | 1.0564  | 0.8777  |
|  13   | 1.2170  | 0.9440  |
|  14   | 1.2037  | 0.8203  |
|  15   | 1.2053  | 0.6428  |
|  16   | 1.2240  | 0.3914  |
|  17   | 1.1581  | 0.3726  |
|  18   | 1.1279  | 0.3412  |
|  19   | 1.1535  | 0.2361  |
|  20   | 1.2158  | 0.0073  |
|  21   | 1.2000  | 0.0000  |
