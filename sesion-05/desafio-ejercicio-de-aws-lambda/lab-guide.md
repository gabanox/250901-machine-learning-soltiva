# [Desafío] Ejercicio de AWS Lambda

## Información general del laboratorio

Este es un laboratorio de desafío donde aplicará sus conocimientos de AWS Lambda para resolver un problema real de procesamiento de datos. En lugar de seguir instrucciones paso a paso, se le presentará un escenario y deberá diseñar e implementar la solución completa.

El desafío consiste en crear un sistema automatizado de procesamiento de reportes de ventas que se activa cuando se cargan archivos CSV a un bucket de S3, procesa los datos, genera estadísticas y envía notificaciones por email con los resultados.

![Diagrama de arquitectura del desafío mostrando el flujo de datos desde S3 hasta SNS](images/arch-activity-5.png)

## Escenario del desafío

Una empresa de retail necesita un sistema automatizado para procesar reportes de ventas diarios. Los archivos CSV se cargan a un bucket S3 cada noche, y el sistema debe:

1. **Detectar automáticamente** cuando se carga un nuevo archivo CSV
2. **Procesar el archivo** para extraer estadísticas de ventas
3. **Generar un reporte** con métricas clave
4. **Guardar el reporte** en formato JSON en S3
5. **Enviar notificaciones** por email con un resumen ejecutivo

## Objetivos del desafío

Al completar este desafío, habrá demostrado su capacidad para:

- Diseñar una arquitectura serverless completa
- Implementar procesamiento de archivos con Lambda
- Manejar errores y casos edge de forma robusta
- Crear notificaciones inteligentes basadas en datos
- Optimizar funciones Lambda para rendimiento
- Implementar logging y monitoreo efectivos

## Duración

El tiempo estimado para completar este desafío es de **60 minutos**.

## Especificaciones técnicas

### Formato de archivo de entrada

Los archivos CSV tendrán la siguiente estructura:

```csv
fecha,producto,categoria,cantidad,precio_unitario,vendedor,region
2024-01-15,Laptop Dell,Electrónicos,2,899.99,Juan Pérez,Norte
2024-01-15,Mouse Inalámbrico,Electrónicos,5,25.50,María García,Sur
2024-01-15,Teclado Mecánico,Electrónicos,3,75.00,Carlos López,Centro
```

### Métricas requeridas en el reporte

Su función Lambda debe calcular y generar:

1. **Ventas totales** (cantidad × precio_unitario)
2. **Número total de transacciones**
3. **Producto más vendido** (por cantidad)
4. **Categoría con mayores ingresos**
5. **Ventas por región**
6. **Ventas por vendedor**
7. **Precio promedio por transacción**
8. **Top 5 productos por ingresos**

### Estructura del reporte de salida

```json
{
  "report_metadata": {
    "generated_at": "2024-01-16T08:30:00Z",
    "source_file": "ventas_2024-01-15.csv",
    "total_records": 150,
    "processing_time_ms": 245
  },
  "summary": {
    "total_sales": 45678.90,
    "total_transactions": 150,
    "average_transaction": 304.53,
    "top_product": "Laptop Dell",
    "top_category": "Electrónicos"
  },
  "details": {
    "sales_by_region": {
      "Norte": 15234.50,
      "Sur": 18923.40,
      "Centro": 11521.00
    },
    "sales_by_seller": {
      "Juan Pérez": 8934.50,
      "María García": 12456.78
    },
    "top_products": [
      {"product": "Laptop Dell", "revenue": 5678.90, "quantity": 15},
      {"product": "Monitor 4K", "revenue": 3456.78, "quantity": 8}
    ]
  }
}
```

## Requisitos de implementación

### 1. Configuración de infraestructura

- **Bucket S3**: Para archivos de entrada y reportes generados
- **Función Lambda**: Para procesamiento de datos
- **Tema SNS**: Para notificaciones por email
- **Roles IAM**: Con permisos mínimos necesarios

### 2. Manejo de errores

Su solución debe manejar:
- Archivos CSV malformados
- Registros con datos faltantes
- Archivos demasiado grandes
- Errores de red o AWS
- Timeouts de función Lambda

### 3. Optimización y mejores prácticas

- Usar variables de entorno para configuración
- Implementar logging estructurado
- Optimizar memoria y timeout de Lambda
- Usar procesamiento por lotes cuando sea apropiado
- Implementar reintentos para operaciones críticas

## Tareas del desafío

### Tarea 1: Diseño de la arquitectura
**Tiempo estimado: 10 minutos**

1. Diseñe la arquitectura completa del sistema
2. Identifique todos los servicios AWS necesarios
3. Defina los permisos IAM requeridos
4. Planifique el flujo de datos end-to-end

### Tarea 2: Configuración de la infraestructura
**Tiempo estimado: 15 minutos**

1. Cree el bucket S3 con las carpetas necesarias:
   - `input/` - Para archivos CSV de entrada
   - `reports/` - Para reportes generados
   - `errors/` - Para archivos con errores

2. Configure el tema SNS para notificaciones

3. Cree la función Lambda con configuración inicial

4. Configure los permisos IAM necesarios

### Tarea 3: Implementación del procesamiento
**Tiempo estimado: 25 minutos**

1. Implemente la lógica de procesamiento de CSV
2. Calcule todas las métricas requeridas
3. Genere el reporte en formato JSON
4. Implemente manejo robusto de errores

### Tarea 4: Integración y notificaciones
**Tiempo estimado: 10 minutos**

1. Configure el trigger de S3
2. Implemente la lógica de notificaciones SNS
3. Cree mensajes informativos para diferentes escenarios
4. Pruebe la integración completa

## Código de inicio (opcional)

Si necesita ayuda para comenzar, puede usar esta estructura básica:

```python
import json
import boto3
import csv
from datetime import datetime
from io import StringIO
from collections import defaultdict
import logging

# Configurar logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Clientes AWS
s3_client = boto3.client('s3')
sns_client = boto3.client('sns')

def lambda_handler(event, context):
    """
    Función principal del desafío Lambda
    """
    try:
        # TODO: Procesar evento de S3
        # TODO: Descargar y procesar archivo CSV
        # TODO: Generar reporte
        # TODO: Guardar reporte en S3
        # TODO: Enviar notificación
        
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Procesamiento completado'})
        }
        
    except Exception as e:
        logger.error(f"Error en procesamiento: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }

def process_csv_data(csv_content):
    """
    Procesar datos CSV y generar métricas
    """
    # TODO: Implementar procesamiento
    pass

def generate_report(metrics, metadata):
    """
    Generar reporte en formato JSON
    """
    # TODO: Implementar generación de reporte
    pass

def send_notification(report_summary):
    """
    Enviar notificación SNS
    """
    # TODO: Implementar notificación
    pass
```

## Datos de prueba

Use este archivo CSV para probar su implementación:

```csv
fecha,producto,categoria,cantidad,precio_unitario,vendedor,region
2024-01-15,Laptop Dell XPS,Electrónicos,2,1299.99,Juan Pérez,Norte
2024-01-15,Mouse Logitech,Accesorios,5,45.99,María García,Sur
2024-01-15,Teclado Mecánico,Accesorios,3,89.99,Carlos López,Centro
2024-01-15,Monitor Samsung 27",Electrónicos,1,349.99,Ana Martínez,Norte
2024-01-15,Webcam HD,Accesorios,4,79.99,Luis Rodríguez,Sur
2024-01-15,Tablet iPad,Electrónicos,1,599.99,Elena Sánchez,Centro
2024-01-15,Audífonos Sony,Accesorios,6,129.99,Miguel Torres,Norte
2024-01-15,Impresora HP,Oficina,2,199.99,Carmen Ruiz,Sur
2024-01-15,Disco Duro Externo,Almacenamiento,3,119.99,Roberto Silva,Centro
2024-01-15,Router WiFi,Redes,1,89.99,Patricia Morales,Norte
```

## Criterios de evaluación

Su solución será evaluada en base a:

### Funcionalidad (40%)
- ✅ Procesamiento correcto de archivos CSV
- ✅ Cálculo preciso de todas las métricas
- ✅ Generación correcta del reporte JSON
- ✅ Integración exitosa con S3 y SNS

### Manejo de errores (25%)
- ✅ Validación de datos de entrada
- ✅ Manejo de archivos malformados
- ✅ Logging apropiado de errores
- ✅ Recuperación graceful de fallos

### Arquitectura y mejores prácticas (20%)
- ✅ Uso eficiente de servicios AWS
- ✅ Configuración apropiada de permisos IAM
- ✅ Optimización de rendimiento
- ✅ Código limpio y bien estructurado

### Monitoreo y observabilidad (15%)
- ✅ Logging estructurado y útil
- ✅ Métricas de rendimiento
- ✅ Notificaciones informativas
- ✅ Facilidad de debugging

## Casos edge a considerar

- **Archivos vacíos**: ¿Qué hacer con archivos sin datos?
- **Datos faltantes**: ¿Cómo manejar registros incompletos?
- **Valores negativos**: ¿Son válidas las cantidades negativas?
- **Fechas inválidas**: ¿Cómo procesar fechas malformadas?
- **Archivos grandes**: ¿Cómo optimizar el procesamiento?
- **Duplicados**: ¿Debe detectar y manejar registros duplicados?

## Extensiones opcionales

Si completa el desafío básico, considere estas extensiones:

### Extensión 1: Análisis temporal
- Compare ventas con períodos anteriores
- Identifique tendencias de crecimiento
- Detecte anomalías en los datos

### Extensión 2: Alertas inteligentes
- Configure umbrales para métricas clave
- Envíe alertas cuando se excedan límites
- Implemente diferentes niveles de notificación

### Extensión 3: Visualización de datos
- Genere gráficos simples en formato SVG
- Cree dashboards básicos
- Exporte datos para herramientas de BI

## Entrega del desafío

Para completar el desafío, debe entregar:

1. **Código de la función Lambda** completo y funcional
2. **Configuración de infraestructura** (permisos IAM, triggers, etc.)
3. **Archivo de prueba** con resultados de ejecución
4. **Documentación breve** explicando su solución

## Consejos para el éxito

- 📋 **Planifique antes de codificar**: Dedique tiempo al diseño
- 🧪 **Pruebe incrementalmente**: Valide cada componente por separado
- 📝 **Use logging abundante**: Facilitará el debugging
- ⚡ **Optimice después**: Haga que funcione primero, optimice después
- 🛡️ **Piense en fallos**: ¿Qué puede salir mal y cómo lo manejará?

## Recursos de apoyo

- [Documentación de AWS Lambda](https://docs.aws.amazon.com/lambda/)
- [Procesamiento de archivos con Python](https://docs.python.org/3/library/csv.html)
- [Mejores prácticas de logging](https://docs.aws.amazon.com/lambda/latest/dg/python-logging.html)
- [Optimización de rendimiento](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)

---

**¡Buena suerte con el desafío!** 🚀

Este ejercicio le permitirá demostrar sus habilidades en el desarrollo de soluciones serverless completas y su capacidad para resolver problemas reales con AWS Lambda.

