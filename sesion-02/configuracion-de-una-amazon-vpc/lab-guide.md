# Configuración de una VPC


## Información general del laboratorio


Amazon Virtual Private Cloud (Amazon VPC) le ofrece la capacidad de aprovisionar una sección aislada de forma lógica de la nube de Amazon Web Services (AWS), donde puede iniciar recursos de AWS en una red virtual que defina. Tiene control total sobre el entorno de redes virtuales, incluida la selección de rangos de direcciones IP, la creación de subredes y la configuración de tablas de enrutamiento y puertas de enlace de red.

En este laboratorio, creará una nube virtual privada (VPC) y otros componentes de red que se requieren para implementar recursos, como una instancia de Amazon Elastic Compute Cloud (Amazon EC2).


![El siguiente diagrama muestra la arquitectura final del laboratorio que tiene una VPC, una subred pública y una privada con una instancia de EC2 en cada una y una puerta de enlace de NAT en la subred pública. Ambas subredes están alojadas en una única zona de disponibilidad. El diagrama también muestra la tabla de enrutamiento asociada con cada subred.](images/architecture.png)

## Objetivos

Al finalizar este laboratorio, podrá realizar lo siguiente:

- Crear una VPC con una subred privada y una pública, una puerta de enlace de internet y una puerta de enlace de NAT.
- Configurar las tablas de enrutamiento asociadas con las subredes para el tráfico de internet mediante una puerta de enlace de internet y una puerta de enlace de NAT.
- Iniciar un servidor bastión en una subred pública.
- Usar un servidor bastión para iniciar sesión en una instancia en una subred privada.

Si tiene tiempo, puede completar la sección de desafío opcional en la que deberá crear una instancia de Amazon EC2 en una subred privada y conectarse a ella mediante el servidor bastión.


## Duración

El tiempo estimado para completar este laboratorio es de **45 minutos**.


## Tarea 1: crear una VPC

En esta tarea, creará una nueva VPC.

5. En la **Consola de administración de AWS**, en la barra de **búsqueda**, ingrese y seleccione `VPC` para ir a la **Consola de administración de VPC**.

6. En el panel de navegación izquierdo, en **Nube virtual privada**, elija **Sus VPC**.

   <i class="fas fa-sticky-note" style="color:orange"></i> En cada región, ya se creó para usted una VPC predeterminada con un bloque de enrutamiento entre dominios sin clase (Classless Inter-Domain Routing, CIDR) de 172.31.0.0/16. Incluso si aún no ha creado nada en su cuenta, verá algunos recursos de VPC preexistentes.

7. Elija **Crear VPC** y configure las siguientes opciones:

  - **Recursos que se van a crear:** seleccione **Solo la VPC**.
  - **Etiqueta de nombre**: ingrese `Lab VPC`.
  - **IPv4 CIDR block** (Bloque de CIDR IPV4): seleccione **entrada manual de CIDR IPv4**.
  - **IPv4 CIDR** (CIDR IPv4): ingrese `10.0.0.0/16`.
  - **IPv6 CIDR block** (Bloque de CIDR IPv6): seleccione **No IPv6 CIDR block** (Sin bloque de CIDR IPv6).
  - **Tenencia**: seleccione **Predeterminado**.
  - **Etiquetas:** deje las etiquetas sugeridas tal como están.

8. Elija **Crear VPC**. 

   En la parte superior de la página, aparece un mensaje similar al siguiente: “You successfully created vpc-NNNNNNNNNNN / Lab VPC.” (Creó correctamente vpc-NNNNNNNNNNN/VPC de laboratorio).

9. Elija **Acciones** y, luego, **Editar la configuración de VPC**.

10. En **Configuración de DNS**, seleccione **Habilitar nombres de host DNS**.

11. Seleccione **Guardar**.

    A partir de este momento, las instancias de EC2 que se lancen en la VPC recibirán de forma automática un nombre de host del sistema de nombres de dominio (DNS) IPv4 público.



## Tarea 2: crear subredes

En esta tarea, creará una subred pública y una privada.

### Tarea 2.1: crear una subred pública

12. En el panel de navegación izquierdo, en **Nube virtual privada**, elija **Subredes**.

13. Elija **Crear subred** y configure las siguientes opciones:

  - **ID de la VPC:** elija **Lab VPC** (VPC de laboratorio).
  - **Nombre de la subred:** ingrese `Public Subnet`.
  - **Zona de disponibilidad**: seleccione la primera zona de disponibilidad de la lista. No elija **Sin preferencia**.
  - **IPv4 CIDR block** (Bloque de CIDR de IPv4): ingrese `10.0.0.0/24`.

14. Seleccione **Crear subred**.

    Ahora debe configurar la subred pública para que asigne de forma automática una dirección IP pública a todas las instancia de EC2 que se lancen en ella.

15. Seleccione **Subred pública**.

16. Elija **Acciones** y, luego, **Editar la configuración de la subred**.

17. En **Configuración de la asignación automática de IP**, elija **Enable auto-assign public IPv4 address** (Habilitar la asignación automática de dirección IPv4 pública).

18. Seleccione **Guardar**.

    <i class="fas fa-comment"></i> Aunque se otorgó el nombre **Public Subnet** a esta subred, todavía no es pública. Una subred pública debe tener una puerta de enlace de internet, que deberá adjuntar más adelante en el laboratorio.

### Tarea 2.2: crear una subred privada

En esta tarea, creará la subred privada, que se usará para recursos que deben permanecer aislados de internet.

19. Para crear la subred privada, repita los pasos de la tarea anterior y seleccione las siguientes opciones:

  - **ID de la VPC:** elija **Lab VPC** (VPC de laboratorio).
  - **Nombre de la subred:** ingrese `Private Subnet`.
  - **Zona de disponibilidad:** seleccione la primera zona de disponibilidad de la lista. No elija **Sin preferencia**.
  - **IPv4 CIDR block** (Bloque de CIDR de IPv4): ingrese `10.0.2.0/23`.

20. Seleccione **Crear subred**.

    El bloque de CIDR de 10.0.2.0/23 incluye todas las direcciones IP que comienzan con 10.0.2.x y 10.0.3.x. Este rango tiene el doble de tamaño que una subred pública porque la mayoría de los recursos deben permanecer en las subredes privadas, a menos que se necesite específicamente que se pueda acceder a ellas desde internet.

    Su VPC ahora tiene dos subredes. Sin embargo, la VPC está aislada por completo y no se puede comunicar con los recursos que se encuentran fuera de la VPC. 

    A continuación, configurará la subred pública para conectarse a internet a través de una puerta de enlace de internet.



## Tarea 3: crear una puerta de enlace de internet

En esta tarea, creará una puerta de enlace de internet para su VPC. Necesita una puerta de enlace de internet para establecer conectividad externa con instancias de EC2 en las VPC.

21. En el panel de navegación izquierdo, en **Nube virtual privada**, elija **Gateways de Internet**.

22. Seleccione **Crear gateway de Internet** y, luego, en **Etiqueta de nombre**, ingrese `Lab IGW`.

23. Seleccione **Crear gateway de Internet**.

24. Elija **Acciones** y, luego, seleccione **Asociar a una VPC**.

    La subred pública ahora tiene conexión a internet. Sin embargo, para dirigir el tráfico a internet, también debe configurar la tabla de enrutamiento de la subred pública de modo que use la puerta de enlace de internet.



## Tarea 4: configurar tablas de enrutamiento

En esta tarea, realizará lo siguiente:

- Crear una tabla de enrutamiento pública para el tráfico de internet.
- Agregar una ruta a la tabla de enrutamiento para dirigir el tráfico de internet a la puerta de enlace de internet.
- Asociar la subred pública a la nueva tabla de enrutamiento.

25. En el panel de navegación izquierdo, en **Nube virtual privada**, elija **Tablas de enrutamiento**.

    Se enumeran varias tablas de enrutamiento.

26. Seleccione la tabla de enrutamiento que incluya la **Lab VPC** (VPC de laboratorio) en la columna **VPC**.

    **Sugerencia:** Si no puede ver la columna VPC, desplácese hacia la derecha.

27. En la columna **Name** (Nombre), elija el ícono de edición, ingrese `Private Route Table` para **Edit Name** (Editar nombre) y, luego, seleccione **Save** (Guardar).

28. Seleccione la pestaña **Rutas**.

    En este momento, solo hay una ruta. En esta, figura que todo el tráfico destinado a 10.0.0.0/16 (que es el rango de la VPC de laboratorio), se enrutará localmente. Esta opción permite que todas las subredes dentro de una VPC se comuniquen entre sí.

    Ahora creará una nueva tabla de enrutamiento pública para enviar tráfico público a la puerta de enlace de internet.

29. Seleccione **Crear tabla de enrutamiento** y configure las siguientes opciones:

  - **Name - _optional_ (Nombre - opcional):** ingrese `Public Route Table`.
  - **VPC:** seleccione **Lab VPC** (VPC de laboratorio).

30. Seleccione **Crear tabla de enrutamiento**.

31. Después de creada la tabla de enrutamiento, en la pestaña **Rutas**, elija <span id="ssb_white">Editar rutas</span>.

    **Nota:** Ahora agregue una ruta para dirigir el tráfico de internet (0.0.0.0/0) a la puerta de enlace de internet.

32. Elija <span id="ssb_white">Agregar ruta</span> y configure las siguientes opciones:

  - **Destino:** ingrese `0.0.0.0/0`.
  - **Objetivo:** seleccione **Gateway de Internet** y, luego, seleccione **Lab IGW** en la lista.

33. Seleccione **Guardar cambios**.

    El último paso es asociar esta nueva tabla de enrutamiento a la subred pública.

34. Elija la pestaña **Asociaciones de subredes**.

35. Elija <span id="ssb_white">Editar asociaciones de subredes</span>.

36. Seleccione **Subred pública**.

37. Elija **Guardar asociaciones**.

    La subred pública ahora es pública porque tiene una entrada de tabla de enrutamiento que envía tráfico a internet mediante la puerta de enlace de internet.

    En las tareas anteriores, creó una VPC y la asoció a una puerta de enlace de internet. A continuación, creó subredes y una tabla de enrutamiento, y asoció una tabla de enrutamiento pública a la subred pública. Ahora iniciará recursos en las subredes según sea necesario.

## Tarea 5: Iniciar un servidor bastión en la subred pública

Un servidor bastión (también conocido como jump box) es una instancia de EC2 en una subred pública que se configura de forma segura para brindar acceso a los recursos de una subred privada. Los operadores de sistemas se pueden conectar al servidor bastión y, luego, pasar a los recursos de la subred privada.

En esta tarea, iniciará un servidor bastión de una instancia de EC2 en la subred pública que creó anteriormente.

38. En la Consola de administración de AWS, en la barra de **búsqueda**, ingrese y seleccione `EC2` para ir a la **Consola de administración de Elastic Compute Cloud**.

39. En el panel de navegación izquierdo, elija **Instancias**.

40. Elija **Lanzar instancias** y configure las siguientes opciones:

  - En la sección **Nombre y etiquetas**, ingrese `Bastion Server`.

  - En la sección **Application and OS Images (Amazon machine Image)** (Imágenes de la aplicación y el sistema operativo [Imagen de máquina de Amazon]), configure las siguientes opciones:
    - **Inicio rápido:** seleccione **Amazon Linux**.
    - **Amazon Machine Image (AMI)** (Imagen de máquina de Amazon [AMI]): seleccione **Amazon Linux 2023 AMI**.
    
  - En la sección **Tipo de instancia**, elija **t3.micro**.

  - En la sección **Par de claves (inicio de sesión)**, seleccione **Continuar sin un par de claves (no recomendado)**.

    <i class="fas fa-sticky-note" style="color:orange"></i> Utilizará EC2 Instance Connect para acceder al shell que se ejecuta en la instancia de EC2, por lo que no se necesita un par de claves en el laboratorio.

41. En la sección **Configuraciones de red**, seleccione <span style="ssb_white">Editar</span> y configure las siguientes opciones:

  - **VPC - _obligatorio_:** elija **Lab VPC** (VPC de laboratorio).
  - **Subred**: elija **Subred pública**.
  - **Asignar automáticamente IP pública:** elija **Habilitar**.
  - **Firewall (grupos de seguridad):** elija **Crear grupo de seguridad**.
    - **Nombre del grupo de seguridad - _obligatorio_:** ingrese `Bastion Security Group`.
    - **Descripción - _obligatorio_:** ingrese `Allow SSH`.
  - **Reglas de grupos de seguridad de entrada:**
    - **Tipo:** elija **ssh**.
    - **Tipo de origen:** elija **Cualquier lugar**.

42. Seleccione **Lanzar instancia**.


43. Para ver la instancia lanzada, elija **Ver todas las instancias**.

    <i class="fas fa-sticky-note" style="color:orange"></i> La instancia de EC2 con el nombre **Bastion Server** se encuentra inicialmente en estado *Pendiente*. Después el **Estado de la instancia** cambiará a <span style="color:green"><i class="far fa-check-circle"></i> *En ejecución*, lo que indica que la instancia ha finalizado su arranque.

    El servidor bastión se iniciará en la subred pública. 

    Continúe con la siguiente tarea. No hace falta que espere a que la instancia esté en ejecución.



## Tarea 6: crear una puerta de enlace de NAT

En esta tarea, iniciará una puerta de enlace de NAT en la subred pública y configurará la tabla de enrutamiento privada para facilitar la comunicación entre los recursos en la subred privada y en internet. 

44. En la Consola de administración de AWS, en la barra de **búsqueda**, ingrese `NAT gateways`, seleccione la lista de **Características** y elija **Gateways NAT**.

45. Elija **Crear gateway NAT** y configure las siguientes opciones:

  - **Nombre:** ingrese `Lab NAT gateway`. 
  - **Subred:** en la lista desplegable, seleccione **Subred pública**.

46. Elija <span id="ssb_white">Asignar IP elástica</span>.

47. Elija **Crear una gateway NAT**.

    Ahora, debe configurar la subred privada para enviar el tráfico de internet a la puerta de enlace de NAT.

48. En el panel de navegación izquierdo, elija **Tablas de enrutamiento** y, luego, seleccione **Tabla de enrutamiento privada**.

49. Seleccione la pestaña **Rutas**.

    En la tabla de enrutamiento, ahora figura una sola entrada, que dirige el tráfico a nivel local dentro de la VPC. Agregue una ruta adicional para enviar el tráfico de internet a través de la puerta de enlace de NAT.

51. Seleccione <span id="ssb_white">Editar rutas</span>.

52. Seleccione <span id="ssb_white">Agregar ruta</span> y configure las siguientes opciones:

  - **Destino:** ingrese `0.0.0.0/0`.
  - **Objetivo:** seleccione **Gateway NAT** y, luego, seleccione **nat-** en la lista.

53. Seleccione **Guardar cambios**.

    El tráfico de red de los recursos de la subred privada que deben comunicarse con internet ahora se dirigirá a la puerta de enlace de NAT, que reenviará la solicitud a internet. Las respuestas fluirán por la puerta de enlace de NAT y regresarán a la subred privada.

     

## Desafío opcional: Probar la subred privada

<i class="fas fa-comment"></i> Este desafío es opcional y se ofrece en caso de que le quede tiempo en el laboratorio.

En este desafío opcional, lanzará una instancia de EC2 en la subred privada y confirmará que se pueda comunicar con internet.

### Lanzar una instancia en la subred privada

En esta tarea opcional, lanzará una instancia de EC2 en la subred privada.

54. Siga las instrucciones que utilizó para iniciar el servidor bastión y configure las siguientes opciones:

    - En la sección **Nombre y etiquetas**, ingrese `Private Instance`.
    - En la sección **Application and OS Images (Amazon machine Image)** (Imágenes de la aplicación y el sistema operativo [Imagen de máquina de Amazon]), configure las siguientes opciones:
      - **Inicio rápido:** seleccione **Amazon Linux**.
      - **Amazon Machine Image (AMI)** (Imagen de máquina de Amazon [AMI]): seleccione **Amazon Linux 2023 AMI**.
    - En la sección **Tipo de instancia**, elija **t3.micro**.
    - En la sección **Par de claves (inicio de sesión)**, seleccione **Continuar sin un par de claves (no recomendado)**.
    - En la sección **Configuraciones de red**, seleccione <span id="ssb_white">Editar</span> y configure las siguientes opciones:
      - **VPC - _obligatorio_:** elija **Lab VPC** (VPC de laboratorio).
      - **Subred:** elija **Subred privada** (no la subred pública).
      - **Firewall (grupos de seguridad):** elija **Crear grupo de seguridad**.
        - **Nombre del grupo de seguridad - _obligatorio_:** ingrese `Private Instance SG`.
        - **Descripción - _obligatorio_:** ingrese `Allow SSH from Bastion`.
      - **Reglas de grupos de seguridad de entrada:**
        - **Tipo:** elija **ssh**.
        - **Tipo de origen:** elija **Custom** (Personalizado).
        - **Origen:** elija **10.0.0.0/16**.

55. Expanda la sección **Detalles avanzados** y para **Datos de usuario - _opcional_**, pegue el siguiente script:
    
      ```bash
      #!/bin/bash
      # Turn on password authentication for lab challenge
      echo 'lab-password' | passwd ec2-user --stdin
      sed -i 's|[#]*PasswordAuthentication no|PasswordAuthentication yes|g' /etc/ssh/sshd_config
      systemctl restart sshd.service
      ```
    
    <i class="fas fa-comment"></i> Este script permite iniciar sesión usando una contraseña. Se incluye para abreviar los pasos del laboratorio, pero no es lo recomendable para las implementaciones de instancias normales.

56. Seleccione **Lanzar instancia**.

57. Para ver la instancia lanzada, elija **Ver todas las instancias**.

### Iniciar sesión en el servidor bastión

La instancia que acaba de lanzar está en la subred privada, por lo que no es posible iniciar sesión directamente en la instancia. En cambio, primero debe iniciar sesión en el servidor bastión en la subred pública y, luego, en la instancia privada del servidor bastión.

58. En la **Consola de administración de AWS**, en la barra de **búsqueda**, ingrese y seleccione `EC2` para abrir la **Consola de administración de Elastic Compute Cloud**.

59. En el panel de navegación, seleccione **Instancias**.

60. En la lista de instancias, seleccione la instancia **Bastion Server**.

61. Seleccione **Conectar**.

62. En la pestaña **EC2 Instance Connect**, seleccione **Conectar**.

    **Nota:** Si prefiere usar un cliente SSH para conectarse a la instancia de EC2, consulte la guía para [Conectarse a su instancia de Linux](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html).

### Iniciar sesión en una instancia privada

Ahora debe iniciar sesión en el servidor bastión, que se encuentra en la subred pública. Mantenga abierta esta ventana del terminal para uso posterior.

Ahora, se conectará a la instancia privada, que se encuentra en la subred privada.

63. En la consola de Amazon EC2, elija **Instancias** y seleccione **Private Instance** (Instancia privada) (y borre cualquier otra instancia).

64. Copie las **Direcciones IPv4 privadas** (que se muestran en la mitad inferior de la página) en el portapapeles.

    Esta dirección IP es una dirección IP privada que comienza con 10.0.2.x o 10.0.3.x. No se puede acceder a esta dirección desde internet; por eso, primero debe iniciar sesión en el servidor bastión. Ahora debe iniciar sesión en la instancia privada.

65. Regrese a la ventana del terminal y ejecute el siguiente comando. En el comando, reemplace _PRIVATE-IP_ por la dirección IP que acaba de copiar en el portapapeles:

    ```plain
    ssh PRIVATE-IP
    ```

    El comando debería que ejecutó debe ser similar al siguiente: ssh 10.0.2.123

66. Si aparece el mensaje “Are you sure you want to continue connecting” (¿Está seguro de que desea continuar con la conexión?), ingrese `yes`.

67. Cuando se le solicite una contraseña, ingrese `lab-password`.

    Ya debería estar conectado a la instancia privada. Completó esta tarea porque primero se conectó al servidor bastión (en la subred pública) y, después, a la instancia privada (en la subred privada).

### Probar la puerta de enlace de NAT

La parte final de este desafío es confirmar que la instancia privada puede acceder a internet.

Para hacerlo, debe ejecutar el comando ping.

68. Ejecute el siguiente comando:

    ```plain
    ping -c 3 amazon.com
    ```

    Debe ver resultados similares a lo siguiente:

    ```
    PING amazon.com (176.32.98.166) 56(84) bytes of data.
    64 bytes from 176.32.98.166 (176.32.98.166): icmp_seq=1 ttl=222 time=79.2 ms
    64 bytes from 176.32.98.166 (176.32.98.166): icmp_seq=2 ttl=222 time=79.2 ms
    64 bytes from 176.32.98.166 (176.32.98.166): icmp_seq=3 ttl=222 time=79.0 ms
    ```

Este resultado indica que la instancia privada se comunicó con éxito con amazon.com por internet.
La instancia privada está en la subred privada y la única manera de que esto sea posible en la situación actual es pasando por la puerta de enlace de NAT.
Este resultado confirma que la configuración de la red tuvo éxito.



## Conclusión

¡Felicitaciones! Realizó correctamente lo siguiente:

- Creó una VPC con una subred privada y una pública, una puerta de enlace de internet y una puerta de enlace de NAT.
- Configuró las tablas de enrutamiento asociadas a las subredes para el tráfico de internet mediante una puerta de enlace de internet y una puerta de enlace de NAT.
- Inició un servidor bastión en una subred pública.
- Usó un servidor bastión para iniciar sesión en una instancia en una subred privada.

## Recursos adicionales

- [¿Qué es Amazon VPC?](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
- [Bloques de CIDR de VPC](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html)


