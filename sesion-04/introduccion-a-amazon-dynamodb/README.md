# Introduction to Amazon DynamoDB


## Información general sobre el laboratorio

Amazon DynamoDB es un servicio de base de datos NoSQL ágil y flexible para todas las aplicaciones que necesiten una latencia constante en milisegundos de un solo dígito a cualquier escala. Se trata de una base de datos completamente administrada que soporta modelos de clave-valor y de documentos. Su modelo de datos flexible y su desempeño de confianza lo convierten en un complemento perfecto para aplicaciones móviles, web, de juegos, de tecnología publicitaria y de Internet de las cosas (IoT), entre otras.

En este laboratorio, creará una tabla en DynamoDB para almacenar información sobre una biblioteca de música. Después, consultará la biblioteca de música y luego eliminará la tabla de DynamoDB.

## Temas tratados

En este laboratorio, deberá realizar lo siguiente:

- crear una tabla de Amazon DynamoDB

- ingresar datos en una tabla de Amazon DynamoDB

- consultar una tabla de Amazon DynamoDB

- eliminar una tabla de Amazon DynamoDB

### Duración

El tiempo estimado para completar este laboratorio es de **35 minutos**.


## Cómo acceder a la Consola de administración de AWS

1. En la esquina superior derecha de estas instrucciones, seleccione <i class="fas fa-caret-right"></i> **Start Lab** (Comenzar laboratorio). 

    **Consejo para la solución de problemas**: Si aparece el error **Access Denied** (Acceso denegado), cierre el aviso de error y vuelva a seleccionar <i class="fas fa-caret-right"></i> **Start Lab** (Comenzar laboratorio).

2. El estado del laboratorio se puede interpretar de la siguiente manera: 

    - Un círculo rojo junto a ** <u>AWS <i class="fas fa-circle fa-xs" style="color:#ff0000;"></i></u>** en la esquina superior izquierda de esta página indica que el laboratorio no se ha iniciado.

    - Un círculo amarillo junto a **<u>AWS <i class="fas fa-circle fa-xs" style="color:#fff700;"></i></u>** en la esquina superior izquierda de esta página indica que el laboratorio se está iniciando.

    - Un círculo verde junto a **<u>AWS <i class="fas fa-circle fa-xs" style="color:#00ff7f;"></i></u>** en la esquina superior izquierda de esta página indica que el laboratorio está listo.

   Espere a que el laboratorio se encuentre listo antes de continuar.

3. En la parte superior de estas instrucciones, seleccione el círculo verde junto a **<u>AWS <i class="fas fa-circle fa-xs" style="color:#00ff7f;"></i></u>**

    Esta opción abrirá la Consola de administración de AWS en una nueva pestaña del navegador. El sistema iniciará sesión de forma automática.

    **Sugerencia**: Si no se abre una pestaña nueva del navegador, suele aparecer un anuncio o un ícono en la parte superior de este con un mensaje que indica que el navegador impide que el sitio web abra ventanas emergentes. Seleccione el banner o el ícono, y elija **Allow pop ups** (Permitir ventanas emergentes).

4. Ajuste la pestaña de la Consola de administración de AWS para que aparezca junto a estas instrucciones. Idealmente, debería poder ver ambas pestañas del navegador al mismo tiempo para seguir los pasos del laboratorio.

    <i class="fas fa-exclamation-triangle"></i> **No cambie la región del laboratorio a menos que se le indique específicamente**.


## Tarea 1: Crear una nueva tabla

En esta tarea, creará una nueva tabla en DynamoDB llamada **Música**. Cada tabla requiere una clave de partición (o clave principal) que se utiliza para dividir datos de partición en los servidores de DynamoDB. Una tabla también puede tener una clave de ordenación. La combinación de una clave de partición y una clave de ordenación identifica de forma única cada elemento de una tabla de DynamoDB.

5. En la Consola de administración de AWS, seleccione el menú <i class="fas fa-th"></i> **Services** (Servicios). En **Base de datos**, elija **DynamoDB**.

6. Elija **Create table** (Crear tabla).

7. En **Table name** (Nombre de la tabla), ingrese `Music`

8. Para **Partition key** (Clave de partición), ingrese `Artist` y deje **String** (Cadena) seleccionado en la lista desplegable.

9. En **Sort key - *optional*** (Clave de ordenación [opcional]), ingrese `Song` y deje seleccionado **String** (Cadena).

    La tabla utilizará la configuración predeterminada para los índices y la capacidad de aprovisionamiento.

10. Desplácese hacia abajo y elija **Create alarm** (Crear una alarma).

    La tabla se creará en menos de 1 minuto. Espere que la tabla **Music** (Música) esté **Active** (Activa) antes de pasar a la siguiente tarea.


## Tarea 2: Agregar datos

En esta tarea, agregará datos a la tabla **Music** (Música). Una *tabla* es una colección de datos sobre un tema determinado.

Cada tabla contiene varios *elementos*. Un elemento es un grupo de atributos que se identifica de forma única entre todos los demás elementos. Los elementos de DynamoDB son similares en muchos sentidos a las filas de otros sistemas de base de datos. En DynamoDB, no existen límites con respecto a la cantidad de elementos que puede almacenar en una tabla.

Cada elemento se compone de uno o más *atributos*. Un atributo es un componente fundamental de los datos que no es necesario seguir dividiendo. Por ejemplo, un elemento en una tabla de **Música** contiene atributos como Canción y Artista. Los atributos de DynamoDB son similares a las columnas de otros sistemas de bases de datos, pero cada elemento (fila) puede tener atributos diferentes (columnas).

Cuando escribe un elemento en una tabla de DynamoDB, solo se requieren la clave de partición y la clave de ordenación, si se utiliza. Además de estos campos, la tabla no necesita un esquema. Esto significa que se pueden agregar atributos a un elemento que pueden ser diferentes a aquellos de otros elementos.

11. Seleccione la tabla **Music** (Música).

12. Elija **Actions ** (Acciones) y, a continuación, elija **Create item** (Eliminar elemento).

13. Para el valor **Artist** (Artista), ingrese `Pink Floyd`

14. Para el valor **Song** (Canción), Ingrese `Money`

    Estos son los únicos atributos que se requieren, pero ahora podrá agregar atributos adicionales.

15. Para agregar atributos adicionales, elija **Add new attribute** (Agregar nuevo atributo).

16. En la lista desplegable, seleccione **String** (Cadena).

    Se agregará una nueva fila de atributos.

17. Para el nuevo atributo, escriba lo siguiente:

    * **FIELD**: `Album`
    * **VALUE**: `The Dark Side of the Moon`

18. Agregue otro nuevo atributo mediante el botón **Add new attribute** (Agregar nuevo atributo).

19. En la lista desplegable, elija **Number** (Número).

    Se agregará un nuevo atributo de número.

20. Para el nuevo atributo, escriba lo siguiente:

    * **FIELD**: `Year`
    * **VALUE**: `1973`

21. Seleccione **Create item** (Crear elemento).

    El elemento ahora se agregó a la tabla **Music** (Música).

22. De manera similar, para crear un tercer elemento, use los siguientes atributos:

    | Nombre del atributo | Tipo de atributo | Valor del atributo |
    | -------------- | -------------- | --------------- |
    | Artista         | Cadena         | John Lennon     |
    | Canción           | Cadena         | Imagine         |
    | Álbum          | Cadena         | Imagine         |
    | Año           | Número         | 1971            |
    | Género          | Cadena         | Soft rock       |

    Observe que este elemento tiene un atributo adicional llamado **Genre** (Género). Este es un ejemplo de que cada elemento es capaz de tener diferentes atributos sin necesidad de predefinir un esquema de tablas.

23. Para crear un tercer elemento, use los siguientes atributos.

    | Nombre del atributo | Tipo de atributo | Valor del atributo         |
    |----------------|----------------|-------------------------|
    | Artista         | Cadena         | Psy                     |
    | Canción           | Cadena         | Gangnam Style           |
    | Álbum          | Cadena         | Psy 6 (Six Rules), Part 1 |
    | Año           | Número         | 2011                    |
    | LengthSeconds  | Número         | 219                     |

    Una vez más, este elemento tiene un nuevo atributo, **Lengthseconds**, que identifica la longitud de la canción. Esto demuestra la flexibilidad de una base de datos NoSQL.

    También hay formas más rápidas de cargar datos en DynamoDB, como el uso de AWS Command Line Interface, la carga de datos mediante programación o el uso de una de las herramientas gratuitas disponibles en Internet.


## Tarea 3: Modificar un elemento existente

Ahora observa que hay un error en sus datos. En esta tarea, modificará un elemento existente.

24. En el panel DynamoDB, en **Tables** (Tablas), seleccione **Explore Items** (Explorar elementos).

25. Seleccione el botón <i class="far fa-dot-circle"></i> **Music** (Música).

26. Elija **Psy**.

27. Cambie el atributo **Year** (Año) de **2011** a **2012**.

28. Seleccione **Save changes** (Guardar los cambios).

    El elemento está actualizado.


## Tarea 4: Consultar la tabla

Hay dos formas de consultar una tabla de DynamoDB: *consulta* y *análisis*.

Una operación de consulta busca elementos basados en la clave primaria y, de forma opcional, en la clave de ordenación. Está completamente indexada, por lo que funciona muy rápido.

29. Expanda **Scan/Query items** (Analizar/consultar elementos) y seleccione **Query** (Consultar).

    Ahora se muestran los campos Artist (Artista) (clave de partición) y Song (Canción) (clave de ordenación).

30. Ingrese los siguientes detalles:

    * **Artista (clave de partición):** `Psy`
    * **Canción (clave de ordenación):** `Gangnam Style`

31. Elija **Run** (Ejecutar). 

    La canción aparece rápidamente en la lista. Es posible que tenga que desplazarse hacia abajo para ver este resultado.
    
    Una consulta es la forma más eficiente de recuperar datos de una tabla de DynamoDB. 

    Como alternativa, puede analizar un elemento. Esta opción implica buscar entre todos los elementos de una tabla, por lo que es menos eficiente y puede llevar mucho tiempo para tablas más grandes.

32. Desplácese hacia arriba en la página y seleccione **Scan** (Analizar).

33. Expanda **Filters** (Filtros) e ingrese los siguientes valores:

    - En **Attribute Name** (Nombre del atributo), ingrese: `Year`

    - En **Type** (Tipo), elija **Number** (Número).

    - En **Value** (Valor), ingrese `1971`.

34. Seleccione **Run** (Ejecutar).

    Solo se muestra la canción que se lanzó en 1971.


## Tarea 5: Eliminar la tabla

En esta tarea, eliminará la tabla **Music** (Música), lo que también eliminará todos los datos de la tabla.

35. En el panel DynamoDB, en **Tables** (Tablas), seleccione **Update settings** (Actualizar configuración).

36. Seleccione la tabla **Music** (Música) si todavía no está seleccionada.

37. Elija **Actions ** (Acciones) y, a continuación, elija **Delete table** (Eliminar tabla). 

38. En el panel de confirmación, ingrese `delete` y seleccione **Delete table** (Eliminar tabla).

    Se eliminará la tabla.


## Conclusión

<i class="far fa-thumbs-up" style="color:blue"></i> ¡Felicitaciones! Aprendió a realizar correctamente las siguientes tareas:

- Crear una tabla de Amazon DynamoDB

- Ingresar datos en una tabla de Amazon DynamoDB

- Consultar una tabla de Amazon DynamoDB

- Eliminar una tabla de Amazon DynamoDB

Para obtener información acerca de DynamoDB, consulte la [documentación de DynamoDB](http://aws.amazon.com/documentation/dynamodb).


## Laboratorio completo <i class="fas fa-graduation-cap"></i>

39. En la parte superior de esta página, seleccione <i class="fas fa-square-full fa-xs"></i> **End Lab** (Finalizar laboratorio) y, luego, presione <span id="ssb_blue">Yes</span> (Sí) para confirmar que desea finalizar el laboratorio.
    
40. Aparece brevemente el mensaje **Ended AWS Lab Successfully** (El laboratorio de AWS finalizó correctamente), que indica que concluyó el laboratorio.

Para obtener más información sobre AWS Training and Certification, consulte [AWS Training and Certification](https://aws.amazon.com/training/) (Capacitación y certificación de AWS).

*Sus comentarios son bienvenidos y valorados.*
Si desea compartir alguna sugerencia o corrección, proporcione los detalles en nuestro [Formulario de contacto de AWS Training and Certification](https://support.aws.amazon.com/#/contacts/aws-training).

*© 2022, Amazon Web Services, Inc. y sus empresas afiliadas. Todos los derechos reservados. Este contenido no puede reproducirse ni redistribuirse, total ni parcialmente, sin el permiso previo por escrito de Amazon Web Services, Inc. Queda prohibida la copia, el préstamo o la venta de carácter comercial.*

