# Laboratorio de desafíos 2: ejercicio de scripting de Python



#### Duración

La duración estimada de este laboratorio es de **40 minutos** aproximadamente.



## Inicie su entorno de laboratorio

1. En la parte superior de estas instrucciones, haga clic en <span id="ssb_voc_grey">Start Lab</span> (Iniciar laboratorio) para lanzar su laboratorio.

   Se abrirá el panel “Start Lab” (Iniciar laboratorio), donde se muestra el estado del laboratorio.

2. Espere hasta que aparezca el mensaje “**Lab status: ready**” (Estado del laboratorio: listo) y, luego, haga clic en la **X** para cerrar el panel “Start Lab” (Iniciar laboratorio).

   Este laboratorio inicia una instancia EC2 denominada **Linux Host**. Utilizará este servidor para desarrollar scripts de Python.

3. Haga clic en el menú desplegable <span id="ssb_voc_grey">Details</span> (Detalles) situado encima de estas instrucciones y, a continuación, haga clic en <span id="ssb_voc_grey">Show</span> (Mostrar).
   Copie el valor del campo **ips — public** en un archivo de texto y guarde el archivo como **Lab Details.txt**, utilizando un editor de texto como [Atom](https://atom.io/), [Sublime Text](https://www.sublimetext.com/) o [Visual Studio Code](https://code.visualstudio.com/). Este valor es la dirección IP pública del host Linux.
   La información que haya guardado se denominará<u>*Lab Details*</u>(Detalles del laboratorio) en el laboratorio.



## Uso de SSH para conectarse al host Linux

### <span style="font-size: 30px; color: #0060AA;"><i class="fab fa-windows"></i></span> Usuarios de Windows: uso de SSH para conectarse

<i class="fas fa-comment"></i> Estas instrucciones se dirigen específicamente a usuarios de Microsoft Windows. Si utiliza macOS o Linux, <a href="#ssh-MACLinux">pase a la siguiente sección</a>.

4. Haga clic en el menú desplegable <span id="ssb_voc_grey">Details</span> (Detalles) situado por encima de estas instrucciones que está leyendo actualmente y, a continuación, haga clic en <span id="ssb_voc_grey">Show</span> (Mostrar). Se mostrará una ventana de credenciales.
5. Haga clic en el botón **Download PPK** (Descargar PPK) y guarde el archivo **labsuser.ppk**.
   *Por lo general, el navegador lo guarda en el directorio “Downloads” (Descargas).*
6. Haga clic en la **X** para salir del panel “Details (Detalles)”.
7. Descargue **PuTTY** en SSH en la instancia de Amazon EC2. Si no tiene instalado PuTTY en su equipo, <a href="https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe">descárguelo aquí</a>.
8. Abra **putty.exe**.
9. Configure el tiempo de espera de PuTTY de manera que se mantenga la sesión abierta durante un periodo más prolongado:
   * Haga clic en **Connection** (Conexión).
   * Defina el valor de **Seconds between keepalives (Segundos entre señales de conexión persistente)** en `30` segundos.
10. Configure la sesión de PuTTY de la siguiente manera:
   * Haga clic en **Session** (Sesión).
   * **Nombre de host (o dirección IP):** pegue la **dirección IP de la instancia de host Linux** que guardó en el archivo <u>*Detalles del laboratorio*</u> anteriormente.
   * De vuelta en PuTTY, en la lista **Connection** (Conexión), expanda <i class="far fa-plus-square"></i> **SSH.**
   * Haga clic en **Auth** (Autenticación) *(no lo amplíe)*.
   * Haga clic en **Browse** (Buscar).
   * Busque y seleccione el archivo **labsuser.ppk** que descargó.
   * Haga clic en **Open** (Abrir) para seleccionarlo.
   * Haga clic de nuevo en **Open** (Abrir).
11. Haga clic en **Yes (Sí)** para validar el alojamiento y conectarse a él.
12. Cuando aparezca **Login as** (Iniciar sesión como), escriba `ec2-user`.
      Esto lo conectará a la instancia EC2.
13. Usuarios de Windows: <a href="#ssh-after">Haga clic aquí para pasar a la siguiente tarea.</a>

<a id='ssh-MACLinux'></a>

### Si es usuario <span style="font-size: 30px; color: #808080;"><i class="fab fa-apple"></i></span> de macOS <span style="font-size: 30px; "><i class="fab fa-linux"></i></span> y Linux

Estas instrucciones son específicamente para usuarios de Mac o Linux. Si es un usuario de Windows, <a href="#ssh-after">pase a la siguiente tarea.</a>


14. Haga clic en el menú desplegable <span id="ssb_voc_grey">Details</span> (Detalles) situado por encima de estas instrucciones que está leyendo actualmente y, a continuación, haga clic en <span id="ssb_voc_grey">Show</span> (Mostrar). Se mostrará una ventana de credenciales.
15. Haga clic en el botón **Download PEM** (Descargar PEM) y guarde el archivo **labsuser.pem**.
16. Haga clic en la **X** para salir del panel “Details (Detalles)”.
17. Abra una ventana del terminal y cambie el directorio `cd` por aquel donde se descargó el archivo *labsuser.pem*.
      Por ejemplo, si guardó el archivo *labuser.pem* en el directorio Downloads (Descargas), ejecute este comando:

    ```bash
    cd ~/Downloads
    ```
18. Ejecute este comando para cambiar los permisos de la clave a fin de que sean de solo lectura:

    ```bash
    chmod 400 labsuser.pem
    ```
19. Ejecute el siguiente comando *(reemplace **<public-ip\>** con la dirección IP del **host Linux**que guardó en el archivo <u>*Lab Details (Detalles del laboratorio)*</u> anteriormente)*.

    ```bash
    ssh -i labsuser.pem ec2-user@<public-ip>
    ```
20. Escriba `yes (sí)` cuando se le pregunte si desea permitir una primera conexión a este servidor SSH remoto.
      Como está usando un par de claves para la autenticación, no se le pedirá una contraseña.

<a id='ssh-after'></a>



## Su desafío es el siguiente:

**Nota:** Tanto Python 2 (versión 2.7) como Python 3 (versión 3.7) están instalados en el servidor Host Linux. Python 2 está configurado actualmente como la versión predeterminada. Si desea utilizar Python 3, escriba el siguiente comando en la solicitud:

```bash
   alias python=python3
```

* Escriba una secuencia de **Python script** (comandos de Python) en:
   - Muestra todos los **números primos entre 1 y 250**.
   - Almacene los resultados en un archivo **results.txt** .

* Pruebe el script. Compruebe que produjo los resultados esperados en el archivo **results.txt** .

* **Save the script** (Guarde el script) y **make a note of its location (absolute path)** (anote su ubicación (ruta absoluta)) para referencia futura.



## Fin del laboratorio

Cuando haya terminado con el laboratorio:

21. Haga clic en <span id="ssb_voc_grey">End Lab</span> (Finalizar laboratorio) en la parte superior de esta página y, a continuación, en <span id="ssb_blue">Yes</span> (Sí) para confirmar que desea finalizar el laboratorio.  Aparecerá un panel indicando que “Los recursos de laboratorio se están deteniendo”

22. Haga clic en la **X** de la esquina superior derecha para cerrar el panel. Sus recursos de laboratorio serán persistentes y accesibles cuando vuelva a iniciar el laboratorio.

¿Encontró errores o desea sugerir correcciones? Envíenos un email a [aws-course-feedback@amazon.com](mailto:aws-course-feedback@amazon.com).

¿Tiene alguna otra duda? Contáctenos a través de https://aws.amazon.com/contact-us/aws-training/

*© 2022 Amazon Web Services, Inc. o sus empresas afiliadas. Todos los derechos reservados. Este contenido no puede reproducirse ni redistribuirse, total ni parcialmente, sin el permiso previo por escrito de Amazon Web Services, Inc. Queda prohibida la copia, el préstamo o la venta de carácter comercial.*
