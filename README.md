# Lab 00 -  Introducción a Verilog, Simulación y Máquinas de Estados Finitos (FSM)

En este repositorio se encuentran el diseño, implementación en código Verilog y resultados de simulación de los tres ejercicios planteados de maquina de estado. El flujo de diseño digital aplicado incluye el planteamiento de la arquitectura Control y Datapath, y la verificación con testbench en Verilog y GTKWave.


* `/src/`: Contiene los archivos fuente en Verilog (`.v`) de los diseños.
* `/sim/`: Contiene los archivos *testbench* (`tb_*.v`) para la simulación.
* `/img/`: Contiene los diagramas de bloques y capturas de GTKWave.
* `README.md`: Este informe.

---

## Ejercicio 1: Semáforo Simple

### 1.1 Planteamiento del Diseño

El diseño cuenta con un registro de estado de 2 bits y tiene de tres estados principales, los cuales generan la exclusión mutua de las señales, es decir solo una luz encendida a la vez:

**S0 Luz Verde:** Es el estado por defecto al que retorna el sistema al aplicar la señal de Reset, activa la salida green (01). El sistema permanece en este estado durante 5 ciclos de reloj utilizando un contador interno tras lo cual va automáticamente a S1.

**S1 Luz Amarilla:** Activa la salida yellow (01) y apaga las demás. La máquina mantiene este estado de precaución por 2 ciclos de reloj antes de transicionar.

**S2 Luz Roja:** Activa la salida red (01). El sistema mantiene la señal de detención por 4 ciclos de reloj. Al finalizar este periodo, el ciclo se reinicia y la FSM retorna al estado S0.

### 1.2 Diagrama
<img width="892" height="575" alt="image" src="https://github.com/user-attachments/assets/cea9f85e-c723-439a-89d2-3abb5bb6dd54" />


### 1.3 Resultados de Simulación
<img width="1174" height="383" alt="image" src="https://github.com/user-attachments/assets/b8cdcb94-8335-44a9-8729-b2af25ae15a1" />


**Análisis de la simulación:**
**Secuencia:** Se aprecia que la señal green permanece en alto (1) durante exactamente 5 ciclos de reloj, cuando termina este tiempo, la máquina pasa al estado S1, activando yellow por 2 ciclos, y después al estado S2, manteniendo red en alto por 4 ciclos, para luego reiniciar el patrón.

**Exclusión entre colores:** Se confirma la regla de que solo una salida puede estar activa a la vez.

**Reset:** La gráfica demuestra claramente el funcionamiento de la señal de reinicio. Al principio de la simulación, y nuevamente a la mitad, se aplica un pulso de rst. En ambos casos, se observa cómo el sistema aborta inmediatamente su estado actual por medio de su patrón que se ve interrumpido y fuerza a la máquina a regresar al estado inicial.

##  Ejercicio 2: Acumulador Secuencial

### 2.1 Planteamiento del Diseño
La variante específica que implementamos fue la de sumar la entrada x exactamente 3 veces.

El funcionamiento lo dividimos en 4 estados muy fáciles de seguir:

**IDLE:** Es el estado de reposo. El sistema se queda aquí mientras la señal Start sea 0. Apenas recibe un pulso de Start = 1, despierta y avanza.

**LOAD:** Es el paso de preparación, auí simplemente reseteamos el acumulador dejándolo en ceros (acc = 00000) para asegurar que no arrastremos basura de cálculos anteriores.

**ADD:** El sistema le suma el valor de x a lo que ya tenga el acumulador (acc = acc + X). la máquina se queda dando vueltas en este estado mientras el valor acumulado sea menor a 3X. En el momento en que alcanza esto (acc = 3X), sale de ahí.

**DONE:** se hace Done = 1 por un instante para avisar que el cálculo terminó, y luego el sistema vuelve a la tranquilidad del estado IDLE, ya sea por el siguiente ciclo de reloj o si se activa el reset.

### 2.2 Diagrama
<img width="1042" height="601" alt="image" src="https://github.com/user-attachments/assets/72da10a7-b667-4efb-9607-b60ebc58917e" />


### 2.3 Resultados de Simulación
<img width="1165" height="338" alt="image" src="https://github.com/user-attachments/assets/a3ff8f3c-f08c-441f-a2da-29ed27f76c30" />


**Análisis de la simulación:**
[📝 Nota para ti: Explica cómo se ve el pulso de start, cómo el registro 'acc' va incrementando su valor en cada ciclo de reloj, y cómo se activa la señal 'done'].

---

##  Ejercicio 3: Transmisor Serial Síncrono

### 3.1 Planteamiento del Diseño (Descripción de la ASM)
Se hizo un transmisor de 8 bits pensado en una máquina de estado algorítmica ASM. El sistema está compuesto por una Unidad de Control que a su vez es una maquina de estados finita, de 5 estados: IDLE, LOAD, BIT_HOLD, SHIFT_NEXt, DONE y un Datapath que incluye un registro de desplazamiento shift_reg, un contador de temporización tick_cnt y un contador de bits bit_count. 

El sistema recibe un byte de entrada lo carga en el registro y lo transmite bit a bit iniciando por el bit menos significativo por la línea serial tx, controlando la duración de cada bit mediante el parámetro "CLKS_PER_BIT".

### 3.2 Diagrama de Bloques

![Carta ASM Transmisor](./img/asm_transmisor.png)
*(Añade aquí tu diagrama de bloques y/o dibujo de la máquina de estados ASM)*

### 3.3 Resultados de Simulación y Análisis en GTKWave
<img width="1106" height="355" alt="image" src="https://github.com/user-attachments/assets/d4e75110-e09f-42b7-8741-e391a5f19b47" />

<img width="1159" height="393" alt="image" src="https://github.com/user-attachments/assets/515ae851-23fd-4403-9a19-08d69910c630" />

**Explicación del funcionamiento:**
Se observa el correcto flujo de datos a través de los estados definidos, al recibir el pulso de start, el sistema sale de IDLE y pasa a transmitir. De acuerdo con los requerimientos técnicos, se conf irma lo siguiente:

**Transmisión correcta de los 8 bits:** Se verifica en la gráfica que, tras cargar los datos de prueba 8'hA5 y 8'h3C, el registro de desplazamiento transfiere los valores correctamente a la línea tx bit a bit.
**Duración exacta de cada bit:** Se observa que la señal tx mantiene su valor durante CLKS_PER_BIT ciclos de reloj. Esto se logra gracias al contador interno tick_cnt, el cual se reinicia apropiadamente al cambiar de bit.
**Activación correcta de busy:** La señal busy se eleva a 1 lógico en el estado LOAD y se mantiene activa sin interrupciones durante toda la transmisión (estados BIT_HOLD y SHIFT_NEXT), regresando a 0 al terminar.
**Activación de done por un único ciclo:** Se comprueba que, al despachar el octavo bit, el sistema transiciona al estado DONE. En este punto, la señal done se activa (1) durante un ciclo de reloj antes de que el sistema regrese automáticamente al estado IDLE.
