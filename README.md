# Lab 00 -  Introducción a Verilog, Simulación y Máquinas de Estados Finitos (FSM)

En este repositorio se encuentran el diseño, implementación en código Verilog y resultados de simulación de los tres ejercicios planteados de maquina de estado. El flujo de diseño digital aplicado incluye el planteamiento de la arquitectura (Control + Datapath), y la verificación mediante *testbenches* en Verilog y GTKWave.

## 📁 Estructura del Repositorio

* `/src/`: Contiene los archivos fuente en Verilog (`.v`) de los diseños.
* `/sim/`: Contiene los archivos *testbench* (`tb_*.v`) para la simulación.
* `/img/`: Contiene los diagramas de bloques y capturas de GTKWave.
* `README.md`: Este informe técnico.

---

## 🚦 Ejercicio 1: FSM de Control – Semáforo Simple

### 1.1 Planteamiento del Diseño
[📝 Nota para ti: Describe aquí brevemente el diseño. Menciona que es una FSM de Moore con 3 estados (S0, S1, S2) y cómo el contador interno maneja los ciclos de reloj para cada luz.]

### 1.2 Diagrama
<img width="892" height="575" alt="image" src="https://github.com/user-attachments/assets/cea9f85e-c723-439a-89d2-3abb5bb6dd54" />


### 1.3 Resultados de Simulación
<img width="1174" height="383" alt="image" src="https://github.com/user-attachments/assets/b8cdcb94-8335-44a9-8729-b2af25ae15a1" />


**Análisis de la simulación:**
[📝 Nota para ti: Explica aquí qué se ve en la imagen. Confirma que el verde duró 5 ciclos, amarillo 2 y rojo 4. Confirma que solo hay una salida activa a la vez].

---

## ➕ Ejercicio 2: FSM con Datapath – Acumulador Secuencial

### 2.1 Planteamiento del Diseño
[📝 Nota para ti: Describe el sistema. Menciona los estados IDLE, LOAD, ADD, DONE y cómo la Unidad de Control maneja la Ruta de Datos (el registro acumulador). Menciona qué variante te tocó (ej. sumar 4 veces)].

### 2.2 Diagrama
<img width="1042" height="601" alt="image" src="https://github.com/user-attachments/assets/72da10a7-b667-4efb-9607-b60ebc58917e" />


### 2.3 Resultados de Simulación
<img width="1165" height="338" alt="image" src="https://github.com/user-attachments/assets/a3ff8f3c-f08c-441f-a2da-29ed27f76c30" />


**Análisis de la simulación:**
[📝 Nota para ti: Explica cómo se ve el pulso de start, cómo el registro 'acc' va incrementando su valor en cada ciclo de reloj, y cómo se activa la señal 'done'].

---

## 📡 Ejercicio 3: ASM Completa – Transmisor Serial Síncrono

### 3.1 Planteamiento del Diseño (Descripción de la ASM)
Se hizo un transmisor de 8 bits pensado en una máquina de estado algorítmica ASM. El sistema está compuesto por una Unidad de Control que a su vez es una maquina de estados finita, de 5 estados: IDLE, LOAD, BIT_HOLD, SHIFT_NEXt, DONE y un Datapath que incluye un registro de desplazamiento shift_reg, un contador de temporización tick_cnt y un contador de bits bit_count. 

El sistema recibe un byte de entrada lo carga en el registro y lo transmite bit a bit iniciando por el bit menos significativo por la línea serial tx, controlando la duración de cada bit mediante el parámetro "CLKS_PER_BIT".

### 3.2 Diagrama de Bloques

![Carta ASM Transmisor](./img/asm_transmisor.png)
*(Añade aquí tu diagrama de bloques y/o dibujo de la máquina de estados ASM)*

### 3.3 Resultados de Simulación y Análisis en GTKWave
<img width="1106" height="355" alt="image" src="https://github.com/user-attachments/assets/d4e75110-e09f-42b7-8741-e391a5f19b47" />

<img width="1159" height="393" alt="image" src="https://github.com/user-attachments/assets/515ae851-23fd-4403-9a19-08d69910c630" />

**Explicación del funcionamiento observado:**
Se observa el correcto flujo de datos a través de los estados definidos, al recibir el pulso de start, el sistema sale de IDLE y pasa a transmitir. De acuerdo con los requerimientos técnicos, se conf irma lo siguiente:

1. **Transmisión correcta de los 8 bits:** Se verifica en la gráfica que, tras cargar los datos de prueba 8'hA5 y 8'h3C, el registro de desplazamiento transfiere los valores correctamente a la línea tx bit a bit.
2. **Duración exacta de cada bit:** Se observa que la señal tx mantiene su valor durante CLKS_PER_BIT ciclos de reloj. Esto se logra gracias al contador interno tick_cnt, el cual se reinicia apropiadamente al cambiar de bit.
3. **Activación correcta de busy:** La señal busy se eleva a 1 lógico en el estado LOAD y se mantiene activa sin interrupciones durante toda la transmisión (estados BIT_HOLD y SHIFT_NEXT), regresando a 0 al terminar.
4. **Activación de done por un único ciclo:** Se comprueba que, al despachar el octavo bit, el sistema transiciona al estado DONE. En este punto, la señal done se activa (1) durante un ciclo de reloj antes de que el sistema regrese automáticamente al estado IDLE.
