# Cree su servidor de base de datos e interactúe con su base de datos usando una aplicación

## Información general del laboratorio

En este laboratorio, creará una instancia de base de datos de Amazon RDS y la configurará para permitir conexiones desde su servidor web. También descargará e instalará una aplicación web que utiliza la base de datos para almacenar información.

Este laboratorio demuestra cómo integrar una aplicación web con Amazon RDS, mostrando un escenario práctico donde una aplicación PHP se conecta a una base de datos MySQL para gestionar datos de productos y pedidos.

![Diagrama de arquitectura mostrando una instancia EC2 con aplicación web conectándose a una instancia RDS](resource/public/images/architecture-lab1.png)

## Objetivos

Al finalizar este laboratorio, podrá realizar lo siguiente:

- Lanzar una instancia de base de datos de Amazon RDS con alta disponibilidad
- Configurar la instancia de base de datos para permitir conexiones desde su servidor web
- Abrir una aplicación web e interactuar con su base de datos
- Probar la funcionalidad de la aplicación web con la base de datos
- Monitorear las conexiones y el rendimiento de la base de datos

## Duración

El tiempo estimado para completar este laboratorio es de **25 minutos**.

## Tarea 1: Crear un grupo de subredes de base de datos

Un grupo de subredes de base de datos es una colección de subredes que especifica las redes que Amazon RDS puede usar para la instancia de base de datos.

1. En la **Consola de administración de AWS**, busque y seleccione **RDS**.

2. En el panel de navegación izquierdo, elija **Subnet groups** (Grupos de subredes).

3. Elija **Create DB Subnet Group** (Crear grupo de subredes de BD).

4. En la página **Create DB subnet group**, configure:

   **Subnet group details:**
   - **Name**: `lab-db-subnet-group`
   - **Description**: `Database subnet group for lab`
   - **VPC**: Seleccione **Lab VPC**

5. En la sección **Add subnets**:
   - **Availability Zones**: Seleccione las dos primeras zonas disponibles
   - **Subnets**: Seleccione las subredes privadas (10.0.1.0/24 y 10.0.3.0/24)

6. Elija **Create** (Crear).

## Tarea 2: Crear un grupo de seguridad para la base de datos

Creará un grupo de seguridad para permitir que su servidor web acceda a la instancia de base de datos RDS.

7. En el menú **Services** (Servicios), elija **EC2**.

8. En el panel de navegación izquierdo, elija **Security Groups** (Grupos de seguridad).

9. Elija **Create security group** (Crear grupo de seguridad).

10. Configure el grupo de seguridad:

    **Basic details:**
    - **Security group name**: `DB Security Group`
    - **Description**: `Permit access from Web Security Group`
    - **VPC**: **Lab VPC**

11. En la sección **Inbound rules** (Reglas de entrada):
    - Elija **Add rule** (Agregar regla)
    - **Type**: **MYSQL/Aurora (3306)**
    - **Source**: Busque y seleccione **Web Security Group**

    <i class="fas fa-info-circle" style="color:blue"></i> Esto permitirá que cualquier instancia EC2 asociada con el **Web Security Group** acceda a la base de datos.

12. Elija **Create security group** (Crear grupo de seguridad).

## Tarea 3: Crear una instancia de base de datos

En esta tarea, configurará y lanzará una instancia de base de datos Multi-AZ de Amazon RDS para MySQL.

13. En el menú **Services** (Servicios), elija **RDS**.

14. Elija **Create database** (Crear base de datos).

15. Seleccione **MySQL** como motor de base de datos.

16. En **Templates** (Plantillas), seleccione **Dev/Test** (Desarrollo/Pruebas).

17. En **Settings** (Configuración):
    - **DB instance identifier**: `lab-database`
    - **Master username**: `main`
    - **Master password**: `lab-password`
    - **Confirm password**: `lab-password`

18. En **DB instance class** (Clase de instancia de BD):
    - Seleccione **Burstable classes** (Clases ampliables)
    - Elija **db.t3.micro**

19. En **Storage** (Almacenamiento):
    - **Storage type**: **General Purpose SSD (gp2)**
    - **Allocated storage**: **20** GiB
    - Desmarque **Enable storage autoscaling** (Habilitar escalado automático del almacenamiento)

20. En **Connectivity** (Conectividad):
    - **Virtual private cloud (VPC)**: **Lab VPC**
    - **DB Subnet Group**: **lab-db-subnet-group**
    - **Public access**: **No**
    - **VPC security groups**: Elija **Choose existing** (Elegir existente)
    - Seleccione **DB Security Group** y desmarque **default**

21. Expanda **Additional configuration** (Configuración adicional):
    - **Initial database name**: `lab`
    - Desmarque **Enable automated backups** (Habilitar copias de seguridad automáticas)
    - Desmarque **Enable Enhanced monitoring** (Habilitar monitoreo mejorado)

22. Elija **Create database** (Crear base de datos).

    Su base de datos se lanzará en un despliegue Multi-AZ, lo que significa que Amazon RDS mantendrá automáticamente una copia de respaldo síncrona de su base de datos en una zona de disponibilidad diferente.

    <i class="fas fa-clock" style="color:orange"></i> La creación de la base de datos tomará aproximadamente 4 minutos. Puede continuar con la siguiente tarea mientras se crea.

## Tarea 4: Interactuar con su base de datos

En esta tarea, abrirá una aplicación web ejecutándose en su servidor web y la configurará para usar la base de datos.

23. Mientras la base de datos se está creando, elija **EC2** en el menú **Services** (Servicios).

24. En el panel de navegación izquierdo, elija **Instances** (Instancias).

25. En el panel central, debería haber una instancia ejecutándose llamada **Web Server**.

26. Seleccione la instancia **Web Server**.

27. En la pestaña **Details** (Detalles), copie la **Public IPv4 address** (Dirección IPv4 pública).

28. Abra una nueva pestaña del navegador web, pegue la dirección IP y presione Enter.

    Debería ver una aplicación web que muestra información sobre la instancia EC2.

## Tarea 5: Configurar la aplicación web

Ahora configurará la aplicación para conectarse a la base de datos.

29. Regrese a la consola de **RDS**.

30. En el panel de navegación izquierdo, elija **Databases** (Bases de datos).

31. Elija **lab-database**.

32. Desplácese hacia abajo hasta la sección **Connectivity & security** (Conectividad y seguridad) y copie el **Endpoint**. Se verá similar a: `lab-database.cxhwae5uw4w4.us-west-2.rds.amazonaws.com`

33. Regrese a la pestaña del navegador con la aplicación web.

34. En la aplicación web, elija **RDS** en el menú superior.

    Ahora configurará la aplicación para conectarse a su base de datos.

35. Configure la conexión de base de datos:
    - **Endpoint**: Pegue el endpoint de RDS que copió
    - **Database**: `lab`
    - **Username**: `main`
    - **Password**: `lab-password`

36. Elija **Submit** (Enviar).

    Un mensaje indicará que la aplicación ahora está conectada a la base de datos.

## Tarea 6: Probar la aplicación web

Ahora probará la aplicación web agregando, editando y eliminando información.

37. En la aplicación web, elija **+ Add Address** (+ Agregar dirección).

38. Ingrese la siguiente información:
    - **Name**: `Shanghai`
    - **Address**: `300 Fucheng Road`
    - **City**: `Shanghai`
    - **Port**: `80`

39. Elija **Create** (Crear).

    La dirección ahora debería aparecer en la tabla.

40. Agregue algunas direcciones más:

    **Dirección 2:**
    - **Name**: `Los Angeles`
    - **Address**: `400 Broad Street`
    - **City**: `Los Angeles`
    - **Port**: `80`

    **Dirección 3:**
    - **Name**: `London`
    - **Address**: `20 Broad Street`
    - **City**: `London`
    - **Port**: `80`

41. Pruebe la funcionalidad de edición:
    - Elija **Edit** (Editar) junto a una de las direcciones
    - Modifique la información
    - Elija **Update** (Actualizar)

42. Pruebe la funcionalidad de eliminación:
    - Elija **Remove** (Eliminar) junto a una dirección
    - Confirme la eliminación

## Tarea 7: Verificar la persistencia de datos

Verifique que los datos persisten incluso si reinicia la aplicación web.

43. Regrese a la consola de **EC2**.

44. Con la instancia **Web Server** seleccionada, elija **Instance state** > **Reboot instance** (Estado de instancia > Reiniciar instancia).

45. Elija **Reboot** (Reiniciar) para confirmar.

46. Espere hasta que la instancia muestre **Status check** como **2/2 checks passed** (Verificación de estado: 2/2 verificaciones aprobadas).

47. Regrese a la pestaña del navegador con la aplicación web y actualice la página.

48. Elija **RDS** en el menú y verifique que sus datos todavía están allí.

    <i class="fas fa-check-circle" style="color:green"></i> Esto demuestra que sus datos se almacenan de forma persistente en la base de datos RDS, no en la instancia EC2 local.

## Tarea 8: Monitorear la base de datos

Explore las métricas de monitoreo de su instancia RDS.

49. Regrese a la consola de **RDS**.

50. Seleccione su instancia **lab-database**.

51. Elija la pestaña **Monitoring** (Monitoreo).

52. Revise las métricas disponibles:
    - **CPU Utilization** (Utilización de CPU)
    - **Database Connections** (Conexiones de base de datos)
    - **Freeable Memory** (Memoria liberable)
    - **Network Receive Throughput** (Rendimiento de recepción de red)

53. Observe cómo las métricas reflejan la actividad de su aplicación web.

## Tarea 9: Explorar la configuración Multi-AZ

Aprenda sobre la configuración de alta disponibilidad de su base de datos.

54. En la consola de RDS, con su instancia **lab-database** seleccionada, revise la sección **Configuration** (Configuración).

55. Note que **Multi-AZ** está configurado como **Yes** (Sí).

    <i class="fas fa-info-circle" style="color:blue"></i> Esto significa que Amazon RDS mantiene automáticamente una réplica de standby síncrona de su base de datos en una zona de disponibilidad diferente.

56. En caso de falla de la instancia principal, RDS realizará automáticamente un failover a la réplica de standby.

## Desafío opcional: Probar la carga de la aplicación

Si completa las tareas principales, pruebe agregar más datos para ver cómo responde la aplicación.

57. Cree un script simple para agregar múltiples registros rápidamente.

58. Monitoree las métricas de RDS mientras agrega los datos.

59. Observe cómo cambian las métricas de **CPU Utilization** y **Database Connections**.

## Limpieza de recursos

Al finalizar el laboratorio, los recursos se limpiarán automáticamente. Si está ejecutando este laboratorio en su propia cuenta:

60. Elimine la instancia de base de datos RDS.
61. Elimine el grupo de subredes de base de datos.
62. Elimine el grupo de seguridad de base de datos.

## Conclusión

En este laboratorio ha aprendido a:

- ✅ Crear una instancia de base de datos Amazon RDS Multi-AZ
- ✅ Configurar grupos de seguridad para acceso seguro a la base de datos
- ✅ Integrar una aplicación web con Amazon RDS
- ✅ Probar operaciones CRUD (Crear, Leer, Actualizar, Eliminar) en la aplicación
- ✅ Verificar la persistencia de datos independiente de la instancia web
- ✅ Monitorear el rendimiento de la base de datos
- ✅ Comprender los beneficios de Multi-AZ para alta disponibilidad

Amazon RDS simplifica significativamente la administración de bases de datos relacionales, proporcionando características empresariales como alta disponibilidad, copias de seguridad automáticas y monitoreo integrado.

---

## Recursos adicionales

- [Guía del usuario de Amazon RDS](https://docs.aws.amazon.com/rds/latest/userguide/)
- [Implementaciones Multi-AZ de Amazon RDS](https://docs.aws.amazon.com/rds/latest/userguide/Concepts.MultiAZ.html)
- [Mejores prácticas para Amazon RDS](https://docs.aws.amazon.com/rds/latest/userguide/CHAP_BestPractices.html)
- [Monitoreo de Amazon RDS](https://docs.aws.amazon.com/rds/latest/userguide/monitoring-overview.html)
