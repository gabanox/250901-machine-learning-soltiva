# Introducción a Amazon DynamoDB

## Información general del laboratorio

Amazon DynamoDB es un servicio de base de datos NoSQL completamente administrado que proporciona un rendimiento rápido y predecible con escalabilidad perfecta. DynamoDB le permite descargar las cargas administrativas de funcionamiento y escalado de una base de datos distribuida, para no tener que preocuparse por el aprovisionamiento de hardware, la configuración y configuración, la replicación, la aplicación de parches de software o el escalado de clústeres.

En este laboratorio, creará una tabla de DynamoDB, agregará datos mediante la consola y las API, y explorará las características clave como índices secundarios globales, streams y escalado automático.

## Objetivos

Al finalizar este laboratorio, podrá realizar lo siguiente:

- Crear y configurar tablas de Amazon DynamoDB
- Agregar, consultar y actualizar elementos usando la consola y AWS CLI
- Crear índices secundarios globales (GSI) para consultas eficientes
- Configurar escalado automático para manejar cargas variables
- Implementar DynamoDB Streams para capturar cambios de datos
- Usar operaciones de lectura y escritura por lotes
- Aplicar mejores prácticas de diseño para DynamoDB

## Duración

El tiempo estimado para completar este laboratorio es de **35 minutos**.

## Tarea 1: Crear una tabla de DynamoDB

En esta tarea, creará su primera tabla de DynamoDB para almacenar información de productos de una cafetería.

1. En la **Consola de administración de AWS**, busque y seleccione **DynamoDB**.

2. En el panel de DynamoDB, elija **Create table** (Crear tabla).

3. Configure la tabla:
   - **Table name** (Nombre de tabla): `Products`
   - **Partition key** (Clave de partición): `ProductId` (String)
   - **Sort key** (Clave de ordenamiento): `Category` (String)

4. En **Settings** (Configuración):
   - Seleccione **Default settings** (Configuración predeterminada)
   - **Table class**: Standard
   - **Capacity mode**: On-demand

5. Elija **Create table** (Crear tabla).

   <i class="fas fa-info-circle" style="color:blue"></i> **Nota**: La creación de la tabla toma unos segundos.

## Tarea 2: Agregar elementos a la tabla

Agregue algunos productos de muestra a su tabla usando la consola.

6. Una vez que la tabla esté **Active** (Activa), selecciónela.

7. Vaya a la pestaña **Explore table items** (Explorar elementos de tabla).

8. Elija **Create item** (Crear elemento).

9. Agregue el primer producto:
   ```json
   {
     "ProductId": "PROD001",
     "Category": "Coffee",
     "ProductName": "Espresso Blend",
     "Price": 12.99,
     "Description": "Rich and bold espresso blend",
     "InStock": true,
     "StockQuantity": 150
   }
   ```

10. Elija **Create item** (Crear elemento).

11. Repita el proceso para agregar más productos:

    **Producto 2:**
    ```json
    {
      "ProductId": "PROD002",
      "Category": "Coffee",
      "ProductName": "Colombian Supreme",
      "Price": 15.50,
      "Description": "Premium Colombian coffee beans",
      "InStock": true,
      "StockQuantity": 75
    }
    ```

    **Producto 3:**
    ```json
    {
      "ProductId": "PROD003",
      "Category": "Tea",
      "ProductName": "Earl Grey",
      "Price": 8.99,
      "Description": "Classic Earl Grey tea",
      "InStock": true,
      "StockQuantity": 200
    }
    ```

    **Producto 4:**
    ```json
    {
      "ProductId": "PROD004",
      "Category": "Pastry",
      "ProductName": "Croissant",
      "Price": 3.50,
      "Description": "Fresh buttery croissant",
      "InStock": false,
      "StockQuantity": 0
    }
    ```

## Tarea 3: Consultar elementos

Aprenda diferentes formas de consultar datos en DynamoDB.

12. En la pestaña **Explore table items**, use el **Scan** para ver todos los elementos.

13. Pruebe una consulta específica:
    - Cambie de **Scan** a **Query**
    - **Partition key**: `ProductId` = `PROD001`
    - **Sort key**: `Category` = `Coffee`
    - Elija **Run** (Ejecutar)

14. Experimente con filtros:
    - Use **Scan** con filtros
    - Agregue un filtro: `InStock` = `true`
    - Elija **Run** (Ejecutar)

## Tarea 4: Crear un índice secundario global (GSI)

Cree un GSI para consultar productos por categoría eficientemente.

15. En la tabla **Products**, vaya a la pestaña **Indexes** (Índices).

16. Elija **Create index** (Crear índice).

17. Configure el índice:
    - **Index name** (Nombre del índice): `CategoryIndex`
    - **Partition key**: `Category` (String)
    - **Sort key**: `Price` (Number)
    - **Projected attributes**: All attributes

18. Elija **Create index** (Crear índice).

19. Espere a que el índice esté **Active** (Activo).

## Tarea 5: Consultar usando el GSI

Use el nuevo índice para consultas eficientes por categoría.

20. Vaya a **Explore table items**.

21. En el menú desplegable junto al nombre de la tabla, seleccione **CategoryIndex**.

22. Use **Query** con el índice:
    - **Partition key**: `Category` = `Coffee`
    - Elija **Run** (Ejecutar)

23. Agregue un filtro de rango:
    - **Sort key condition**: `Price` between `10` and `20`
    - Elija **Run** (Ejecutar)

## Tarea 6: Usar AWS CLI con DynamoDB

Configure y use AWS CLI para interactuar con DynamoDB.

24. Si no está ya conectado, conéctese a una instancia EC2 que tenga AWS CLI configurado.

25. Verifique la configuración de AWS CLI:
    ```bash
    aws configure list
    ```

26. Liste las tablas de DynamoDB:
    ```bash
    aws dynamodb list-tables
    ```

27. Obtenga información de la tabla:
    ```bash
    aws dynamodb describe-table --table-name Products
    ```

28. Agregue un elemento usando CLI:
    ```bash
    aws dynamodb put-item \
        --table-name Products \
        --item '{
            "ProductId": {"S": "PROD005"},
            "Category": {"S": "Snack"},
            "ProductName": {"S": "Chocolate Chip Cookie"},
            "Price": {"N": "2.50"},
            "Description": {"S": "Homemade chocolate chip cookie"},
            "InStock": {"BOOL": true},
            "StockQuantity": {"N": "100"}
        }'
    ```

29. Consulte el elemento recién agregado:
    ```bash
    aws dynamodb get-item \
        --table-name Products \
        --key '{
            "ProductId": {"S": "PROD005"},
            "Category": {"S": "Snack"}
        }'
    ```

## Tarea 7: Operaciones por lotes

Aprenda a usar operaciones por lotes para mayor eficiencia.

30. Cree un archivo JSON para carga por lotes:
    ```bash
    cat > batch-items.json << 'EOF'
    {
        "Products": [
            {
                "PutRequest": {
                    "Item": {
                        "ProductId": {"S": "PROD006"},
                        "Category": {"S": "Coffee"},
                        "ProductName": {"S": "French Roast"},
                        "Price": {"N": "13.99"},
                        "Description": {"S": "Dark roasted French coffee"},
                        "InStock": {"BOOL": true},
                        "StockQuantity": {"N": "80"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "ProductId": {"S": "PROD007"},
                        "Category": {"S": "Tea"},
                        "ProductName": {"S": "Green Tea"},
                        "Price": {"N": "7.50"},
                        "Description": {"S": "Organic green tea"},
                        "InStock": {"BOOL": true},
                        "StockQuantity": {"N": "120"}
                    }
                }
            }
        ]
    }
    EOF
    ```

31. Ejecute la escritura por lotes:
    ```bash
    aws dynamodb batch-write-item --request-items file://batch-items.json
    ```

32. Verifique que los elementos se agregaron:
    ```bash
    aws dynamodb scan --table-name Products --select COUNT
    ```

## Tarea 8: Actualizar elementos

Aprenda diferentes formas de actualizar elementos existentes.

33. Actualice un elemento usando la consola:
    - Seleccione `PROD001` en la tabla
    - Elija **Edit** (Editar)
    - Cambie `StockQuantity` a `125`
    - Elija **Save changes** (Guardar cambios)

34. Actualice un elemento usando AWS CLI:
    ```bash
    aws dynamodb update-item \
        --table-name Products \
        --key '{
            "ProductId": {"S": "PROD002"},
            "Category": {"S": "Coffee"}
        }' \
        --update-expression "SET Price = :newPrice, StockQuantity = StockQuantity - :sold" \
        --expression-attribute-values '{
            ":newPrice": {"N": "16.00"},
            ":sold": {"N": "10"}
        }' \
        --return-values ALL_NEW
    ```

## Tarea 9: Configurar escalado automático

Configure el escalado automático para manejar cargas variables.

35. En la consola de DynamoDB, seleccione la tabla **Products**.

36. Vaya a la pestaña **Additional settings** (Configuración adicional).

37. En **Capacity**, elija **Edit** (Editar).

38. Cambie a **Provisioned** mode:
    - **Read capacity**: 5 unidades
    - **Write capacity**: 5 unidades
    - Habilite **Auto scaling** para ambas

39. Configure auto scaling:
    - **Target utilization**: 70%
    - **Minimum capacity**: 1
    - **Maximum capacity**: 10

40. Elija **Save changes** (Guardar cambios).

## Tarea 10: Configurar DynamoDB Streams

Configure streams para capturar cambios en los datos.

41. En la tabla **Products**, vaya a **Exports and streams**.

42. En **DynamoDB stream details**, elija **Enable** (Habilitar).

43. Configure el stream:
    - **View type**: New and old images
    - Elija **Enable stream** (Habilitar stream)

44. Una vez habilitado, anote el **Stream ARN** para uso futuro.

45. Pruebe el stream haciendo cambios a un elemento:
    ```bash
    aws dynamodb update-item \
        --table-name Products \
        --key '{
            "ProductId": {"S": "PROD003"},
            "Category": {"S": "Tea"}
        }' \
        --update-expression "SET StockQuantity = StockQuantity - :sold" \
        --expression-attribute-values '{
            ":sold": {"N": "5"}
        }'
    ```

## Tarea 11: Explorar métricas de CloudWatch

Monitoree el rendimiento de su tabla DynamoDB.

46. Navegue a **CloudWatch** en la consola de AWS.

47. Vaya a **Metrics** > **DynamoDB**.

48. Explore las métricas disponibles:
    - **Table Metrics**: ConsumedReadCapacityUnits, ConsumedWriteCapacityUnits
    - **Global Secondary Index Metrics**
    - **Stream Metrics** (si configuró streams)

49. Cree un dashboard personalizado:
    - Elija **Create dashboard**
    - Agregue widgets para las métricas clave de su tabla

## Desafío opcional: Implementar TTL

Si completa las tareas principales, configure Time To Live (TTL).

50. Agregue un atributo TTL a algunos elementos:
    ```bash
    # Calcular timestamp para 24 horas en el futuro
    TOMORROW=$(date -d '+1 day' +%s)
    
    aws dynamodb update-item \
        --table-name Products \
        --key '{
            "ProductId": {"S": "PROD004"},
            "Category": {"S": "Pastry"}
        }' \
        --update-expression "SET ExpirationTime = :ttl" \
        --expression-attribute-values "{
            \":ttl\": {\"N\": \"$TOMORROW\"}
        }"
    ```

51. Habilite TTL en la tabla:
    - En la consola, vaya a **Additional settings**
    - En **Time to Live**, elija **Edit**
    - **TTL attribute**: `ExpirationTime`
    - Elija **Enable TTL**

## Limpieza de recursos

Al finalizar el laboratorio:

52. Deshabilite DynamoDB Streams si no los necesita.

53. Elimine la tabla **Products**:
    - Seleccione la tabla
    - Elija **Delete** (Eliminar)
    - Confirme escribiendo `delete`

54. Limpie los archivos temporales en EC2:
    ```bash
    rm batch-items.json
    ```

## Conclusión

En este laboratorio ha aprendido a:

- ✅ Crear y configurar tablas de DynamoDB
- ✅ Realizar operaciones CRUD usando consola y CLI
- ✅ Crear y usar índices secundarios globales
- ✅ Configurar escalado automático
- ✅ Implementar DynamoDB Streams
- ✅ Usar operaciones por lotes para eficiencia
- ✅ Monitorear rendimiento con CloudWatch

DynamoDB es una base de datos NoSQL poderosa que ofrece rendimiento consistente y escalabilidad automática para aplicaciones modernas.

---

## Recursos adicionales

- [Guía para desarrolladores de Amazon DynamoDB](https://docs.aws.amazon.com/dynamodb/latest/developerguide/)
- [Mejores prácticas de DynamoDB](https://docs.aws.amazon.com/dynamodb/latest/developerguide/best-practices.html)
- [Patrones de diseño de DynamoDB](https://docs.aws.amazon.com/dynamodb/latest/developerguide/bp-modeling-nosql.html)
- [DynamoDB Streams](https://docs.aws.amazon.com/dynamodb/latest/developerguide/Streams.html)
