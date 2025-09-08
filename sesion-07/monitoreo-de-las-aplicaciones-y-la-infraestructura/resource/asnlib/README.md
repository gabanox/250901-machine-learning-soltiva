# Supervisión de la infraestructura

<!---
Note for Translators: This lab is based on Academy Cloud Operations. You should be able to copy a lot of translated text from that lab.
-->


## Información general del laboratorio

Supervisar las aplicaciones y la infraestructura es fundamental para ofrecer servicios de TI confiables y coherentes.

Los requisitos de supervisión van desde la recopilación de estadísticas para análisis a largo plazo hasta la reacción rápida a los cambios y a las interrupciones. La supervisión también puede servir de apoyo a los informes de cumplimiento al verificar de manera continua que la infraestructura cumple los estándares de la organización.

En este laboratorio, se muestra cómo utilizar las métricas de Amazon CloudWatch, Registros de Amazon CloudWatch, Eventos de Amazon CloudWatch y AWS Config para supervisar la infraestructura y las aplicaciones.

Después de completar este laboratorio, podrá hacer lo siguiente:

- Utilizar activar comando de AWS Systems Manager para instalar el agente de CloudWatch en instancias de Amazon Elastic Compute Cloud (Amazon EC2).
- Supervisar los registros de aplicaciones con el agente de CloudWatch y con Registros de CloudWatch.
- Supervisar las métricas del sistema con el agente de CloudWatch y las métricas de CloudWatch.
- Crear notificaciones en tiempo real con Eventos de CloudWatch
- Realizar un seguimiento del cumplimiento de la infraestructura mediante AWS Config.

**Duración**

El tiempo estimado para completar este laboratorio es de **60 minutos**.



## Acceso a la Consola de administración de AWS

1. En la parte superior de estas instrucciones, seleccione <span id="ssb_voc_grey">Start Lab</span> (Comenzar laboratorio) para iniciar el laboratorio.

Se abrirá el panel Start Lab (Comenzar laboratorio), donde se muestra el estado del laboratorio. 

2. Espere hasta que aparezca el mensaje **Lab status: ready** (Estado de la sesión de laboratorio: listo) y, a continuación, elija la **X** para cerrar el panel Start Lab (Comenzar laboratorio).

3. En la parte superior de estas instrucciones, seleccione <span id="ssb_voc_grey">AWS</span>.

Este paso abrirá la Consola de administración de AWS en una pestaña nueva del navegador. El sistema iniciará sesión de forma automática.

**Sugerencia**: Si no se abre una pestaña nueva del navegador, debería aparecer un anuncio o un ícono en la parte superior de este que suele indicar que el navegador no permite que se abran ventanas emergentes en el sitio. Seleccione el anuncio o ícono y elija **Permitir ventanas emergentes**.

4. Ubique la pestaña de la Consola de administración de AWS de modo que aparezca al lado de estas instrucciones. Lo ideal sería que pudiera ver ambas pestañas del navegador al mismo tiempo, de modo que sea más sencillo seguir los pasos del laboratorio.

<i class="fas fa-exclamation-triangle"></i> No modifique la región durante este laboratorio.



## Tarea 1: instalar el agente de CloudWatch

Puede utilizar el agente de CloudWatch para recopilar métricas de las instancias de EC2 y de los servidores en las instalaciones, incluidas las siguientes:

- **Métricas a nivel de sistema de las instancias de EC2**, como la asignación de recursos de la CPU, el espacio libre en el disco y la utilización de la memoria. Estas métricas se recopilan de la propia máquina y complementan las métricas estándar de CloudWatch que recopila CloudWatch.
- **Métricas a nivel de sistema de servidores en las instalaciones** que permiten la supervisión de entornos híbridos y de servidores no administrados por AWS.
- **Registros del sistema y de las aplicaciones** de servidores Linux y Windows.
- **Métricas personalizadas** de aplicaciones y servicios que utilizan los protocolos <a href="https://github.com/etsy/statsd" target="_blank">StatsD</a> y <a href="https://collectd.org/" target="_blank">collectd</a>.

En esta tarea, se utilizará Systems Manager para instalar el agente de CloudWatch en una instancia de EC2. Lo configurará para recopilar tanto las métricas de la aplicación como las del sistema.

<img src="images/install-agent.png" alt="AWS Systems Manager" width="700">


5. En la **Consola de administración de AWS**, en el menú <span id="ssb_services">Servicios <i class="fas fa-angle-down"></i></span>, seleccione **Systems Manager**.

6. En el panel de navegación izquierdo, seleccione **Run Command**.

    <i class="fas fa-comment"></i> Si no hay un panel de navegación visible, seleccione el ícono <i class="fa fa-bars"></i> en la esquina superior izquierda para que aparezca.

    Utilizará Run Command para implementar un comando escrito con anterioridad que instalará el agente de CloudWatch.

7. Seleccione <span id="ssb_orange">Ejecutar un comando</span>.

8. Seleccione el botón junto a <i class="fas fa-dot-circle" style="color:#0073BB;"></i> **AWS-ConfigureAWSPackage** (normalmente aparece en la parte superior de la lista).  

9. Desplácese a la sección **Parámetros de comando** y configure la siguiente información:

   - **Acción:** seleccione **Install** (Instalar).
   - **Nombre:** ingrese `AmazonCloudWatchAgent`.
   - **Versión:** ingrese `latest`.

10. En la sección **Destinos**, seleccione <i class="fas fa-dot-circle" style="color:#0073BB;"></i> **Elegir instancias manualmente** y, luego, en **Instancias**, marque la casilla situada junto a **Web Server**.

    Esta configuración instala el agente de CloudWatch en el servidor web.

11. Al final de la página, seleccione <span id="ssb_orange">Ejecutar</span>.

12. Espere a que **Estado general** cambie a **Éxito**. Ocasionalmente, puede seleccionar la opción de actualizar <i class="fas fa-redo"></i>, situada en la parte superior de la página para actualizar el estado.

    Puede consultar el resultado del trabajo para confirmar que se ha ejecutado correctamente.

13. En **Destinos y salidas**, elija <i class="fas fa-dot-circle" style="color:#0073BB;"></i> junto a la instancia y, luego, haga clic en <span id="ssb_white">Ver salida</span>.

14. Expanda <i class="fas fa-caret-right"></i> **Step 1 - Output** (Paso 1 - Salida).

     Debería ver el mensaje **Successfully installed arnarn:aws:ssm:::package/AmazonCloudWatchAgent** (Se instaló correctamente arn:aws:ssm:::package/AmazonCloudWatchAgent).

     Si aparece el mensaje **Step execution skipped due to unsatisfied preconditions: '"StringEquals": [platformType, Windows]'. Step name: createDownloadFolder** (La ejecución del paso se omitió debido a que no se satisficieron las condiciones previas: “‘StringEquals’: platformType, Windows”. Nombre del paso: createDownloadFolder), en su lugar expanda <i class="fas fa-caret-right"></i> **Step 2 - Output** (Paso 2 - Salida). Puede elegir esta opción porque la instancia que usa se creó desde una AMI de Linux. Puede ignorar este mensaje tranquilamente.

     Ahora configure el agente de CloudWatch para recopilar la información de registro deseada. La instancia tiene un servidor web instalado para que configure el agente de CloudWatch con el fin de recopilar los registros del servidor web y las métricas del sistema general.

     Almacenará el archivo de configuración en el almacén de parámetros de AWS Systems Manager; el agente de CloudWatch luego podrá recuperarlo.

15. En el panel de navegación izquierdo, seleccione **Almacén de parámetros**.

16. Seleccione <span id="ssb_orange">Crear parámetro</span> y, luego, configure la siguiente información:

    - **Name** (Nombre): ingrese `Monitor-Web-Server`.
    - **Description** (Descripción): ingrese `Collect web logs and system metrics`.
    - **Value** (Valor): copie y pegue la siguiente configuración:

    ```json
    {
      "logs": {
        "logs_collected": {
          "files": {
            "collect_list": [
              {
                "log_group_name": "HttpAccessLog",
                "file_path": "/var/log/httpd/access_log",
                "log_stream_name": "{instance_id}",
                "timestamp_format": "%b %d %H:%M:%S"
              },
              {
                "log_group_name": "HttpErrorLog",
                "file_path": "/var/log/httpd/error_log",
                "log_stream_name": "{instance_id}",
                "timestamp_format": "%b %d %H:%M:%S"
              }
            ]
          }
        }
      },
      "metrics": {
        "metrics_collected": {
          "cpu": {
            "measurement": [
              "cpu_usage_idle",
              "cpu_usage_iowait",
              "cpu_usage_user",
              "cpu_usage_system"
            ],
            "metrics_collection_interval": 10,
            "totalcpu": false
          },
          "disk": {
            "measurement": [
              "used_percent",
              "inodes_free"
            ],
            "metrics_collection_interval": 10,
            "resources": [
              "*"
            ]
          },
          "diskio": {
            "measurement": [
              "io_time"
            ],
            "metrics_collection_interval": 10,
            "resources": [
              "*"
            ]
          },
          "mem": {
            "measurement": [
              "mem_used_percent"
            ],
            "metrics_collection_interval": 10
          },
          "swap": {
            "measurement": [
              "swap_used_percent"
            ],
            "metrics_collection_interval": 10
          }
        }
      }
    }
    ```

    Estudie en detalle la configuración anterior. Define los siguientes elementos por supervisar.

    - **Registros**: dos archivos de registro del servidor web que se recopilarán y enviarán a Registros de CloudWatch.
    - **Métricas**: métricas de la CPU, disco y memoria que se envían a las métricas de CloudWatch.

17. Seleccione <span id="ssb_orange">Crear parámetro</span>.

    Este parámetro será referenciado al iniciar el agente de CloudWatch.

    Ahora utilice otro Run Command para iniciar el agente de CloudWatch en el servidor web.

18. En el panel de navegación izquierdo, seleccione **Run Command**.

19. Elija <span id="ssb_orange">Run Command</span>.

20. Elija la casilla <i class="fa fa-search"></i> y haga las selecciones que se detallan a continuación:

    - Seleccione **Prefijo del nombre del documento**.
    - Seleccione **Es igual a**.
    - Ingrese `AmazonCloudWatch-ManageAgent`.
    - Verifique que el filtro sea **Prefijo del nombre del documento: Es igual a: AmazonCloudWatch-ManageAgent**
    - Presione Entrar.

     Antes de ejecutar el comando, puede ver su definición.

21. Seleccione **AmazonCloudWatch-ManageAgent** (elija el nombre en sí).

    Se abrirá una nueva pestaña del navegador en la que se mostrará la definición del comando.

    Examine el contenido de cada pestaña para ver cómo se define un documento de comandos.

22. Seleccione la pestaña **Contenido** y desplácese hasta la parte inferior para ver el script específico que se ejecutará en la instancia de destino.

    El script referencia al almacén de parámetros de AWS Systems Manager porque recupera la configuración del agente de CloudWatch que definió con anterioridad.

23. Cierre la pestaña actual del navegador web, lo que lo llevará nuevamente a la pestaña **Ejecutar un comando** en la que se encontraba antes.

    Compruebe que haya seleccionado el botón <i class="fas fa-dot-circle" style="color:#0073BB;"></i> situado junto a **AmazonCloudWatch-ManageAgent**.

24. En la sección **Parámetros de comando**, configure la siguiente información:

    - **Acción:** seleccione **configurar**.
    - **Modo:** seleccione **ec2**.
    - **Optional Configuration Source** (Fuente de configuración opcional): seleccione **ssm**.
    - **Optional Configuration Location** (Ubicación de configuración opcional): ingrese `Monitor-Web-Server`.
    - **Optional Restart** (Reinicio opcional): seleccione **yes** (sí).

    De esta forma, configura el agente para que utilice la configuración que almacenó previamente en el Almacén de parámetros.

25. En la sección **Destinos**, elija <i class="fas fa-dot-circle" style="color:#0073BB;"></i> **Elegir instancias manualmente**.

26. En la sección **Instancias**, seleccione la casilla situada junto a **Web Server**.

27. Seleccione <span id="ssb_orange">Ejecutar</span>.

28. Espere a que **Estado general** cambie a **Éxito**. Ocasionalmente, puede seleccionar la opción de actualizar <i class="fas fa-redo"></i>, situada en la parte superior de la página para actualizar el estado.

    El agente de CloudWatch ahora se está ejecutando en la instancia y envía datos de registro y métricas a CloudWatch.



## Tarea 2: supervisar registros de aplicaciones mediante Registros de CloudWatch

Puede utilizar Registros de CloudWatch para supervisar las aplicaciones y los sistemas con datos de registro. Por ejemplo, Registros de CloudWatch puede hacer un seguimiento del número de errores que se producen en los registros de la aplicación y enviarle una notificación cuando la tasa de errores supere el umbral que especifique.

Registros de CloudWatch utiliza sus datos de registro existentes para la supervisión, por lo que no se requieren cambios en el código. Por ejemplo, puede supervisar los registros de la aplicación en busca de términos literales específicos (como “NullReferenceException”) o contar el número de apariciones de un término literal en una posición concreta de los datos de registro (como los códigos de estado 404 en un registro de acceso al servidor web). Cuando se encuentra el término que busca, Registros de CloudWatch informa los datos a una métrica de CloudWatch que usted especifica. Los datos del registro se cifran mientras están en tránsito y en reposo.

En esta tarea, generará datos de registro en el servidor web y, luego, supervisará los registros mediante Registros de CloudWatch.

<img src="images/cloudwatch-logs.png" alt="Registros de CloudWatch" width="700">

El servidor web genera dos tipos de datos de registro:

- registros de acceso
- registros de error

Primero acceda al servidor web.

29. Seleccione el menú desplegable <span id="ssb_voc_grey">Details</span> (Detalles), situado sobre estas instrucciones y, luego, seleccione <span id="ssb_voc_grey">Show</span> (Mostrar).

    Copie el valor de **WebServerIP**.

30. Abra una nueva pestaña en el navegador web, pegue el valor de **WebServerIP** que copió y presione Intro.

    Se debería visualizar una **página de prueba** del servidor web.

    Se generarán datos de registro al intentar acceder a una página inexistente.

31. Añada `/start` a la URL del navegador y presione Intro.

    Recibirá un mensaje de error porque la página no existe. ¡Eso está bien! Se generarán datos en los registros de acceso que se enviarán a Registros de CloudWatch.

32. Mantenga esta pestaña abierta en su navegador web, pero vuelva a la pestaña de navegador que muestra la Consola de administración de AWS.

33. En el menú <span id="ssb_services">Servicios <i class="fas fa-angle-down"></i></span>, elija **CloudWatch**.

34. En el panel de navegación izquierdo, seleccione **Grupos de registros**.

    Deberían aparecer dos registros en la lista: **HttpAccessLog** y **HttpErrorLog**.

    <i class="fas fa-exclamation-triangle"></i> Si estos registros no aparecen en la lista, intente esperar un minuto y, luego, seleccione <i class="fas fa-sync"></i> **Actualizar**.

35. Seleccione **HttpAccessLog** (elija el nombre en sí).

36. En la sección **Flujos de registros**, seleccione la **Secuencia de registro** que se encuentra en la tabla (elija el nombre en sí). Tiene el mismo ID de la instancia EC2 en donde se encuentra adjunto el registro.

    Deberían mostrarse los datos de registro, que consisten en solicitudes **GET** que se enviaron al servidor web. Para ver información adicional, seleccione <i class="fas fa-caret-right"></i> a fin de expandir las líneas. Los datos de registro incluyen información sobre la computadora y el navegador que realizaron la solicitud.

    Debería ver una línea que contiene la solicitud **/start** con un código 404, que significa que la página no se encontró.

    Esto demuestra cómo los archivos de registro pueden enviarse de forma automática desde una instancia de EC2 o un servidor en las instalaciones a Registros de CloudWatch. Los datos de registro son accesibles sin tener que entrar en cada servidor individual. Los datos de registro también pueden recopilarse de varios servidores, por ejemplo, de una flota de servidores web de Auto Scaling.



### Crear un filtro de métricas en Registros de CloudWatch

Ahora configurará un filtro para identificar **errores 404** en el archivo de registro. Este error de manera normal indica que el servidor web está generando enlaces no válidos y que los usuarios los están seleccionando.

37. En el panel de navegación izquierdo, seleccione **Grupos de registros**.

38. Marque la casilla de verificación situada junto a **HttpAccessLog**. 

39. En el menú desplegable <span id="ssb_white">Acciones</span>, seleccione **Crear un filtro de métricas**.

    Un patrón de filtro define los campos del archivo de registro y filtra los datos por valores específicos.

40. Pegue la siguiente línea en la casilla **Patrón de filtro**:

    ```plain
    [ip, id, user, timestamp, request, status_code=404, size]
    ```

    Esta línea le indica a Registros de CloudWatch cómo interpretar los campos de los datos de registro y define un filtro para encontrar líneas que incluyan solo **status_code=404**, lo que sugiere que no se ha encontrado una página.

41. En la sección **Probar patrón**, utilice el menú desplegable para seleccionar el ID de la instancia de EC2. Debe ser similar a **i-0f07ab62aae4xxxx9**.

42. Seleccione <span id="ssb_white">Probar patrón</span>.

43. En la sección **Resultados**, seleccione **Mostrar resultados de la prueba**.

    Debería ver al menos un resultado con **$status_code** de **404**. Este código de estado indica que se solicitó una página que no se encontró.

44. Elija <span id="ssb_orange">Siguiente</span>.

45. Dentro de la sección **Crear nombre de filtro**, en la casilla **Nombre del filtro**, ingrese `404Errors`.

46. En la sección **Detalles de la métrica**, configure la siguiente información:

    - **Espacio de nombres de métrica:** ingrese `LogMetrics`
    - **Nombre de la métrica:** ingrese `404Errors`
    - **Valor de métrica:** ingrese `1`

47. Elija <span id="ssb_orange">Siguiente</span>. Si *Siguiente* no está habilitado, haga clic en un campo de texto vacío. Esto cambiará el enfoque y lo habilitará.

48. En la página **Ver la vista previa y crear**, seleccione <span id="ssb_orange">Crear un filtro de métricas</span>.

    Este filtro de métricas puede utilizarse ahora en una alarma.



### Cree una alarma utilizando el filtro

Ahora configurará una alarma para enviar una notificación cuando se reciban demasiados errores **404 Not Found**.

49. En el panel **404Errors**, seleccione la casilla de la esquina superior derecha.

50. En la sección **Filtros de métricas**, seleccione <span id="ssb_white">Crear alarma</span>.

51. Configure los siguientes ajustes:

    - En la sección **Métricas**, en **Periodo**, seleccione **1 minute** (1 minuto).
    - En la sección **Condiciones**, seleccione lo siguiente:
      - **Siempre que 404Errors sea**: seleccione <i class="fas fa-dot-circle" style="color:#0073BB;"></i> **Mayor/Igual**.
      - **than** (que): ingrese `5`.
    - Elija <span id="ssb_orange">Siguiente</span>.

52. En la sección **Notificación**, configure lo siguiente:

    - **Seleccione un tema de SNS:** seleccione <i class="fas fa-dot-circle" style="color:#0073BB;"></i> **Crear un tema nuevo**.
    - **Email endpoints that will receive the notification** (Puntos de enlace de correo electrónico que recibirán la notificación): ingrese una dirección de correo electrónico a la que pueda acceder desde el aula.
    - Seleccione <span id="ssb_white">Crear un tema</span>.
    - Elija <span id="ssb_orange">Siguiente</span>.

53. En **Nombre y descripción**, configure los siguientes ajustes:

    - **Nombre de la alarma:** ingrese `404 Errors`.
    - **Descripción de la alarma:** ingrese `Alert when too many 404s detected on an instance`.
    - Elija <span id="ssb_orange">Siguiente</span>.

54. Seleccione <span id="ssb_orange">Crear alarma</span>.

55. Diríjase a su correo electrónico, busque un mensaje de confirmación y haga clic en el enlace **Confirmar la suscripción**.

56. Regrese a la Consola de administración de AWS.

57. En el panel de navegación izquierdo, seleccione **CloudWatch** (en la parte superior). 

    Su alarma debería aparecer en color <span style="color:orange">naranja</span>, lo que indica que hay **datos insuficientes** para activar la alarma. Esta alarma aparece porque no se recibieron datos de forma reciente.

    Acceda al servidor web para generar datos de registro.

58. Vuelva a la pestaña del navegador web que contiene el servidor web.

<i class="fas fa-comment"></i> Si la pestaña del navegador del servidor web ya no está abierta, seleccione el menú desplegable <span id="ssb_voc_grey">Details</span> (Detalles), situado arriba de estas instrucciones y, luego, seleccione <span id="ssb_voc_grey">Show</span> (Mostrar).

Copie el valor de **WebServerIP** y péguelo en una nueva pestaña del navegador.


59. Intente ir a páginas que no existen agregando el nombre de una página después de la dirección IP. Repita este paso al menos cinco veces.

    Por ejemplo, ingrese `http://192.0.2.0/start2`.

    Cada solicitud independiente generará una entrada de registro distinta.

60. Espere 1 o 2 minutos para que la alarma se active. En la Consola de administración de AWS, ocasionalmente, puede seleccionar <i class="fas fa-redo"></i> **Actualizar**, para actualizar el estado.

    El gráfico que se muestra en la página de CloudWatch debería volverse <span style="color:red">rojo</span> para indicar que está en el estado **Alarma**.

61. Revise su correo electrónico. Debería haber recibido un correo electrónico con el asunto **ALARM: "404 Errors"** (Alarma: errores 404).

    Esta tarea demuestra cómo puede crear una alarma a partir de los datos de registro de la aplicación y recibir alertas cuando se detecta un comportamiento inusual en el archivo de registro. El archivo de registro es accesible dentro de Registros de CloudWatch para realizar un análisis adicional con el fin de diagnosticar las actividades que activaron la alarma.



## Tarea 3: supervisar métricas de las instancias mediante CloudWatch

Las métricas son datos sobre el rendimiento de los sistemas. CloudWatch almacena las métricas de los servicios de AWS que utiliza. También puede publicar las métricas de su aplicación a través del agente de CloudWatch o de manera directa desde su aplicación. CloudWatch puede presentar las métricas para su búsqueda o para representarlas en gráficos, paneles y alarmas.

En esta tarea, se utilizarán las métricas que proporciona CloudWatch.

<img src="images/cloudwatch-metrics.png" alt="Métricas de CloudWatch" width="700">

62. En el menú <span id="ssb_services">Servicios <i class="fas fa-angle-down"></i></span>, elija **EC2**.

63. En el panel de navegación izquierdo, elija **Instancias**.

64. Marque la casilla situada junto a **Web Server**.

65. Seleccione la pestaña **Supervisión** situada en la mitad inferior de la página.

    Examine las métricas presentadas. También puede seleccionar un gráfico si desea mostrar más información.

    CloudWatch recoge métricas sobre el uso de la CPU, el disco y la red dentro de la instancia. Estas métricas ven la instancia desde el exterior como una máquina virtual, pero no dan información de lo que se ejecuta en su interior, como mediciones del espacio de memoria o de disco libres. Por fortuna, puede obtener información sobre lo que ocurre dentro de la instancia gracias a la información recopilada por el agente de CloudWatch ya que este se ejecuta dentro de la instancia con el fin de recopilar métricas.

66. En el **menú de Servicios**, seleccione **CloudWatch**.

67. En el panel de navegación izquierdo, haga clic en **Métricas**. Luego, expanda <i class="fas fa-caret-right"></i> **Métricas** y seleccione Todas las métricas.

    En la mitad inferior de la página, se muestran las diferentes métricas que CloudWatch ha recopilado. AWS genera de forma automática algunas de estas métricas y el agente de CloudWatch recopila otras.

68. Seleccione **CWAgent** y, luego, seleccione **device, fstype, host, path** (dispositivo, fstype, host, ruta).

    Podrá ver las métricas de espacio en disco que captura el agente de CloudWatch.

69. Sobre la tabla, seleccione **CWAgent**, (en la línea que dice **All > CWAgent > device, fstype, host, path**) (dispositivo, fstype, host, ruta).

70. Seleccione **host**.

    Podrá ver las métricas relacionadas con la memoria del sistema.

71. Sobre la tabla, seleccione **Todas** (en la línea que dice **All > CWAgent > device, fstype, host, path**) (dispositivo, fstype, host, ruta).

    Explore las demás métricas que recopila CloudWatch. Se trata de métricas generadas de forma automática procedentes de los servicios de AWS que se han utilizado en esta cuenta de AWS.

    Puede <i class="far fa-check-square" style="color:#0073BB;"></i> seleccionar las métricas que desea que aparezcan en el gráfico.



## Tarea 4: crear notificaciones en tiempo real

Eventos de CloudWatch proporciona un flujo casi en tiempo real de eventos del sistema que describen cambios en los recursos de AWS. Las reglas simples pueden hacer coincidir eventos y dirigirlos a una o más funciones o flujos de destino. Eventos de CloudWatch registra los cambios operativos a medida que se producen.

Eventos de CloudWatch responde a estos cambios operativos y toma las medidas correctivas necesarias enviando mensajes para responder al entorno, activando funciones, realizando cambios y recopilando información sobre el estado. También puede utilizar Eventos de CloudWatch para programar acciones automatizadas que se activen por su cuenta en determinados momentos a través de expresiones cron o rate.

En esta tarea, creará una notificación en tiempo real que le informará cuando una instancia se detiene o termina.

<img src="images/cloudwatch-events.png" alt="Eventos de CloudWatch" width="700">

72. En el panel de navegación izquierdo, expanda <i class="fas fa-caret-right"></i> **Eventos** y seleccione **Reglas**.

73. Seleccione **Crear una regla**.

74. En la sección **Origen del evento**, configure los siguientes ajustes:

    - **Nombre del servicio:** seleccione **EC2**.
    - **Tipo de evento:** seleccione **EC2 Instance State-change Notification** (Notificación de cambios de estado de instancia de EC2).
    - Seleccione la casilla de verificación <i class="fas fa-dot-circle" style="color:#0073BB;"></i> **Estado(s) específico(s)**.
    - En el menú desplegable, seleccione **detenida** y **terminada**.

75. En la sección **Destinos** de la derecha, configure los siguientes ajustes:

    - Seleccione <span id="ssb_grey">  <i class="fas fa-plus-circle"></i> **Agregar destino**</span>.
    - En el menú desplegable con la **Función Lambda**, seleccione **Tema de SNS**.
    - En **Tema**, seleccione la opción de tema **Default_CloudWatch_Alarms_Topic** (Tema predeterminado de alarmas de CloudWatch).

76. En la parte inferior de la página, seleccione <span id="ssb_blue">Configurar los detalles</span>.

77. En **Definición de la regla**, configure los siguientes ajustes:

    - En **Nombre**, ingrese `Instance_Stopped_Terminated`.
    - Seleccione <span id="ssb_blue">Crear una regla</span>.



### Configure una notificación en tiempo real

Puede configurar Amazon Simple Notification Service (Amazon SNS) para enviar las notificaciones en tiempo real a su teléfono a través de SMS o a su dirección de correo electrónico. Debido a que la configuración de la mensajería SMS requiere la apertura de un ticket ante AWS Support, así como tiempo para configurar los cambios en su cuenta, utilizará la misma dirección de correo electrónico que utilizó con anterioridad para completar este ejercicio.

Puede obtener más información acerca de cómo configurar la mensajería SMS con SNS en la [Guía para desarrolladores de Amazon Simple Notification Service](https://docs.aws.amazon.com/sns/latest/dg/sns-mobile-phone-number-as-subscriber.html).

78. En el menú <span id="ssb_services">Servicios <i class="fas fa-angle-down"></i></span>, seleccione **Simple Notification Service**.

79. En el panel de navegación izquierdo, seleccione **Temas**.

80. Seleccione el enlace situado en la columna **Nombre**.

    Debería ver solo una suscripción asociada a la dirección de correo electrónico. Este es el tema que configuró en la tarea 2.

81. En el menú <span id="ssb_services">Servicios <i class="fas fa-angle-down"></i></span>, elija **EC2**.

82. En el panel de navegación izquierdo, elija **Instancias**.

83. Marque la casilla situada junto a **Web Server**.

84. Seleccione <span id="ssb_white">Estado de instancia <i class="fas fa-angle-down"></i></span>, luego, **Detener instancia** y, finalmente, <span id="ssb_orange">Detener</span>.

    La instancia **Web Server** entrará en el estado **Deteniendo**. Después de un minuto, pasará al estado **Detenida**.

Debería recibir un correo electrónico con detalles sobre la instancia que se detuvo.

El mensaje tendrá el formato JSON. Para recibir un mensaje de más fácil lectura, podría crear una función de AWS Lambda activada por Eventos de CloudWatch. De esta forma, la función de Lambda podría expresar el mensaje en un formato de más fácil lectura y enviarlo mediante Amazon SNS.

Esta tarea demuestra cómo recibir una notificación en tiempo real cuando la infraestructura cambia.



## Tarea 5: supervisar el cumplimiento de la infraestructura

AWS Config es un servicio que permite examinar, auditar y evaluar las configuraciones de los recursos de AWS. AWS Config supervisa y registra de manera continua sus configuraciones de recursos de AWS y le permite automatizar la evaluación de las configuraciones registradas comparándolas con las configuraciones deseadas.

AWS Config puede revisar los cambios en las configuraciones y las relaciones entre los recursos de AWS, examinar a profundidad historiales detallados de configuraciones de recursos y determinar el cumplimiento general con las configuraciones especificadas en las pautas internas. AWS Config le permite simplificar la auditoría del cumplimiento, los análisis de seguridad, la administración de los cambios y la solución de problemas operativos.

En esta tarea, activará las reglas de AWS Config para garantizar el cumplimiento del etiquetado y de los volúmenes de Amazon Elastic Block Store (Amazon EBS).

85. En el menú <span id="ssb_services">Servicios <i class="fas fa-angle-down"></i></span>, elija **Config**.

86. Si aparece **Comenzar**, haga lo siguiente:

    - Elija <span id="ssb_orange">Comenzar</span>.
    - Elija <span id="ssb_orange">Siguiente</span>. 
    - Elija <span id="ssb_orange">Siguiente</span>.
    - Seleccione <span id="ssb_orange">Confirmar</span>.

    De este modo, configurará AWS Config para su primer uso. Aparecerá una ventana en la que se indicará **Le damos la bienvenida a AWS Config**. Puede cerrarla.

87. En el panel de navegación izquierdo, seleccione **Reglas** (en la parte superior).

88. Seleccione <span id="ssb_orange">Agregar regla</span>.

89. En la sección **Reglas administradas por AWS**, del campo de búsqueda, ingrese `required-tags`.

90. Seleccione el botón que se encuentra junto a **required-tags**.

91. Elija <span id="ssb_orange">Siguiente</span>.

    Configure la regla para que por cada recurso se requiera un código de proyecto.

92. En la página **Configurar regla**, desplácese a **Parámetros** y configure los siguientes ajustes:

    - A la derecha de **tag1Key**, ingrese `project` (reemplace cualquier valor existente).
    - En la parte inferior de la página, seleccione <span id="ssb_orange">Siguiente</span>.
    - Seleccione <span id="ssb_orange">Agregar regla</span>. 

    Esta regla buscará los recursos que no contienen la etiqueta **project** (proyecto). Esta acción tardará unos minutos, así que continúe con los siguientes pasos. No necesita esperar.

    Ahora agregue una regla que busque los volúmenes de EBS que no están asociados a instancias de EC2.

93. Seleccione <span id="ssb_orange">Agregar regla</span>. 

94. En la sección **Reglas administradas por AWS**, del campo de búsqueda, ingrese `ec2-volume-inuse-check`.

95. Seleccione el botón que se encuentra junto a **ec2-volume-inuse-check**.

96. Elija <span id="ssb_orange">Siguiente</span>.

97. Vuelva a seleccionar <span id="ssb_orange">Siguiente</span>.

98. Seleccione <span id="ssb_orange">Agregar regla</span>. 

99. Espere hasta que al menos una de las reglas haya completado la evaluación. Actualice la página del navegador si es necesario.

    <i class="fas fa-comment"></i> Si recibe una mensaje que indica que **No hay recursos dentro del ámbito**, espere unos minutos más. Este mensaje sugiere que AWS Config todavía está escaneando los recursos disponibles. El mensaje termina por desaparecer.

100. Seleccione cada una de las reglas para consultar los resultados de las auditorías. 

101. En <i class="fas fa-caret-right"></i> **Recursos dentro del ámbito** seleccione **Conforme** en la lista.

     Lo siguiente debería aparecer entre los resultados:

     - **required-tags:** se encontró una instancia de EC2 conforme (porque el servidor web tiene una etiqueta **project** [proyecto]) y muchos recursos no conformes que no poseen la etiqueta **project** (proyecto).
     - **ec2-volume-inuse-check**: se encontró un volumen conforme (asociado a una instancia) y un volumen no conforme (no asociado a una instancia).

     AWS Config cuenta con una gran biblioteca de verificaciones de cumplimiento predefinidas y puede crear verificaciones adicionales escribiendo su propia regla de AWS Config por medio de Lambda.



## Laboratorio completado

<i class="icon-flag-checkered"></i> ¡Felicitaciones! Completó el laboratorio.

102. Seleccione <span id="ssb_voc_grey">End Lab</span> (Finalizar laboratorio) en la parte superior de esta página y, a continuación, seleccione <span id="ssb_blue">Yes</span> (Sí) para confirmar que desea finalizar el laboratorio.  

Aparecerá un panel que indica **DELETE has been initiated… You may close this message box now.** (Se ha iniciado la ELIMINACIÓN… Ya puede cerrar este cuadro de mensaje).

103. Seleccione la **X** en la esquina superior derecha para cerrar el panel.



## Recursos adicionales

Para obtener más información sobre AWS Training and Certification, consulte https://aws.amazon.com/training/.

*Sus comentarios son bienvenidos y valorados.*

Si desea compartir alguna sugerencia o corrección, ingrese los detalles en nuestro [Formulario de contacto de AWS Training and Certification](https://support.aws.amazon.com/#/contacts/aws-training).

*© 2022, Amazon Web Services, Inc. y sus filiales. Todos los derechos reservados. Este contenido no puede reproducirse ni redistribuirse, total ni parcialmente, sin el permiso previo por escrito de Amazon Web Services, Inc. Queda prohibida la copia, el préstamo o la venta de carácter comercial.*
