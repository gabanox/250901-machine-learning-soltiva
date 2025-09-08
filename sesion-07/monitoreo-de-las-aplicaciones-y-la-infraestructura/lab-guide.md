# Monitoreo de las aplicaciones y la infraestructura

## Información general del laboratorio

El monitoreo efectivo es crucial para mantener aplicaciones de Machine Learning funcionando de manera óptima en producción. Este laboratorio le enseñará a implementar un sistema completo de monitoreo que incluye métricas de infraestructura, logs de aplicaciones, alertas automatizadas y dashboards informativos.

Aprenderá a usar Amazon CloudWatch, AWS Systems Manager, y otras herramientas para crear un sistema de observabilidad completo que le permita detectar problemas antes de que afecten a los usuarios finales.

![Diagrama de arquitectura de monitoreo mostrando CloudWatch, EC2, y sistemas de alertas](resource/asnlib/images/cloudwatch-metrics.png)

## Objetivos

Al finalizar este laboratorio, podrá realizar lo siguiente:

- Configurar CloudWatch para recopilar métricas personalizadas
- Implementar logging estructurado para aplicaciones
- Crear dashboards informativos y alertas proactivas
- Monitorear aplicaciones de Machine Learning en producción
- Configurar notificaciones automáticas para eventos críticos
- Usar AWS Systems Manager para automatizar respuestas
- Implementar distributed tracing para microservicios
- Crear runbooks automatizados para incidentes comunes

## Duración

El tiempo estimado para completar este laboratorio es de **60 minutos**.

## Tarea 1: Configurar métricas personalizadas de CloudWatch

En esta tarea, configurará métricas personalizadas para monitorear una aplicación de ML.

1. **Conéctese a la instancia EC2** proporcionada para el laboratorio.

2. **Instale el agente de CloudWatch**:
   ```bash
   # Descargar e instalar el agente
   wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
   sudo rpm -U ./amazon-cloudwatch-agent.rpm
   ```

3. **Configure el agente de CloudWatch**:
   ```bash
   sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
   ```

4. **Cree un script de aplicación ML con métricas personalizadas**:
   ```python
   # ml_monitoring_app.py
   import boto3
   import time
   import random
   import json
   import logging
   from datetime import datetime
   import numpy as np
   from sklearn.ensemble import RandomForestClassifier
   from sklearn.datasets import make_classification
   
   # Configurar logging
   logging.basicConfig(
       level=logging.INFO,
       format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
       handlers=[
           logging.FileHandler('/var/log/ml-app.log'),
           logging.StreamHandler()
       ]
   )
   logger = logging.getLogger('MLApp')
   
   # Cliente de CloudWatch
   cloudwatch = boto3.client('cloudwatch')
   
   class MLModelMonitor:
       def __init__(self, model_name="RandomForestModel"):
           self.model_name = model_name
           self.model = None
           self.prediction_count = 0
           self.error_count = 0
           self.latency_history = []
           
       def train_model(self):
           """Entrenar modelo de ejemplo"""
           logger.info("Iniciando entrenamiento del modelo")
           start_time = time.time()
           
           try:
               # Generar datos sintéticos
               X, y = make_classification(n_samples=1000, n_features=20, 
                                        n_informative=10, n_redundant=10, 
                                        random_state=42)
               
               # Entrenar modelo
               self.model = RandomForestClassifier(n_estimators=100, random_state=42)
               self.model.fit(X, y)
               
               training_time = time.time() - start_time
               
               # Enviar métrica de tiempo de entrenamiento
               self.send_metric('ModelTrainingTime', training_time, 'Seconds')
               logger.info(f"Modelo entrenado en {training_time:.2f} segundos")
               
           except Exception as e:
               logger.error(f"Error en entrenamiento: {str(e)}")
               self.send_metric('ModelTrainingErrors', 1, 'Count')
               raise
   
       def predict(self, features):
           """Realizar predicción con monitoreo"""
           start_time = time.time()
           
           try:
               if self.model is None:
                   raise ValueError("Modelo no entrenado")
               
               # Realizar predicción
               prediction = self.model.predict([features])[0]
               probability = self.model.predict_proba([features])[0].max()
               
               # Calcular latencia
               latency = time.time() - start_time
               self.latency_history.append(latency)
               
               # Incrementar contador
               self.prediction_count += 1
               
               # Enviar métricas
               self.send_metric('PredictionLatency', latency * 1000, 'Milliseconds')
               self.send_metric('PredictionCount', 1, 'Count')
               self.send_metric('ModelConfidence', probability, 'Percent')
               
               # Log de predicción
               logger.info(f"Predicción: {prediction}, Confianza: {probability:.3f}, Latencia: {latency*1000:.2f}ms")
               
               # Detectar predicciones de baja confianza
               if probability < 0.7:
                   self.send_metric('LowConfidencePredictions', 1, 'Count')
                   logger.warning(f"Predicción de baja confianza: {probability:.3f}")
               
               return prediction, probability
               
           except Exception as e:
               self.error_count += 1
               self.send_metric('PredictionErrors', 1, 'Count')
               logger.error(f"Error en predicción: {str(e)}")
               raise
   
       def send_metric(self, metric_name, value, unit):
           """Enviar métrica personalizada a CloudWatch"""
           try:
               cloudwatch.put_metric_data(
                   Namespace='MLApplication',
                   MetricData=[
                       {
                           'MetricName': metric_name,
                           'Value': value,
                           'Unit': unit,
                           'Dimensions': [
                               {
                                   'Name': 'ModelName',
                                   'Value': self.model_name
                               },
                               {
                                   'Name': 'Environment',
                                   'Value': 'Production'
                               }
                           ]
                       }
                   ]
               )
           except Exception as e:
               logger.error(f"Error enviando métrica {metric_name}: {str(e)}")
   
       def get_health_metrics(self):
           """Obtener métricas de salud del modelo"""
           if len(self.latency_history) > 0:
               avg_latency = np.mean(self.latency_history[-100:])  # Últimas 100 predicciones
               p95_latency = np.percentile(self.latency_history[-100:], 95)
           else:
               avg_latency = 0
               p95_latency = 0
           
           error_rate = (self.error_count / max(self.prediction_count, 1)) * 100
           
           return {
               'prediction_count': self.prediction_count,
               'error_count': self.error_count,
               'error_rate': error_rate,
               'avg_latency_ms': avg_latency * 1000,
               'p95_latency_ms': p95_latency * 1000
           }
   
   def simulate_ml_workload():
       """Simular carga de trabajo de ML con monitoreo"""
       monitor = MLModelMonitor()
       
       # Entrenar modelo
       monitor.train_model()
       
       # Simular predicciones
       logger.info("Iniciando simulación de predicciones")
       
       for i in range(100):
           try:
               # Generar características aleatorias
               features = np.random.randn(20)
               
               # Simular latencia variable
               if random.random() < 0.1:  # 10% de predicciones lentas
                   time.sleep(random.uniform(0.1, 0.5))
               
               # Realizar predicción
               prediction, confidence = monitor.predict(features)
               
               # Simular errores ocasionales
               if random.random() < 0.05:  # 5% de errores
                   raise Exception("Error simulado en predicción")
               
               # Pausa entre predicciones
               time.sleep(random.uniform(0.1, 1.0))
               
           except Exception as e:
               logger.error(f"Error en iteración {i}: {str(e)}")
               continue
       
       # Mostrar métricas finales
       health = monitor.get_health_metrics()
       logger.info(f"Métricas finales: {json.dumps(health, indent=2)}")
       
       return monitor
   
   if __name__ == "__main__":
       simulate_ml_workload()
   ```

5. **Ejecute la aplicación de monitoreo**:
   ```bash
   python3 ml_monitoring_app.py
   ```

## Tarea 2: Configurar dashboards de CloudWatch

Cree dashboards informativos para visualizar las métricas de su aplicación.

6. **Navegue a CloudWatch** en la consola de AWS.

7. **Cree un nuevo dashboard**:
   - Elija **Dashboards** > **Create dashboard**
   - **Dashboard name**: `ML-Application-Dashboard`

8. **Agregue widgets para métricas clave**:

   **Widget 1: Latencia de predicciones**
   - **Widget type**: Line
   - **Metric**: `MLApplication > PredictionLatency`
   - **Statistic**: Average, P95
   - **Period**: 1 minute

   **Widget 2: Tasa de errores**
   - **Widget type**: Number
   - **Metric**: `MLApplication > PredictionErrors`
   - **Statistic**: Sum
   - **Period**: 5 minutes

   **Widget 3: Throughput de predicciones**
   - **Widget type**: Line
   - **Metric**: `MLApplication > PredictionCount`
   - **Statistic**: Sum
   - **Period**: 1 minute

   **Widget 4: Confianza del modelo**
   - **Widget type**: Gauge
   - **Metric**: `MLApplication > ModelConfidence`
   - **Statistic**: Average

9. **Guarde el dashboard** y observe las métricas en tiempo real.

## Tarea 3: Configurar alertas y notificaciones

Configure alertas proactivas para detectar problemas automáticamente.

10. **Cree un tema SNS** para notificaciones:
    ```bash
    aws sns create-topic --name ml-app-alerts
    ```

11. **Suscríbase al tema con su email**:
    ```bash
    aws sns subscribe --topic-arn arn:aws:sns:region:account:ml-app-alerts \
                      --protocol email --notification-endpoint su-email@ejemplo.com
    ```

12. **Confirme la suscripción** desde su email.

13. **Cree alarmas de CloudWatch**:

    **Alarma 1: Alta latencia**
    ```bash
    aws cloudwatch put-metric-alarm \
        --alarm-name "ML-High-Latency" \
        --alarm-description "Latencia alta en predicciones ML" \
        --metric-name PredictionLatency \
        --namespace MLApplication \
        --statistic Average \
        --period 300 \
        --threshold 500 \
        --comparison-operator GreaterThanThreshold \
        --evaluation-periods 2 \
        --alarm-actions arn:aws:sns:region:account:ml-app-alerts
    ```

    **Alarma 2: Tasa de errores alta**
    ```bash
    aws cloudwatch put-metric-alarm \
        --alarm-name "ML-High-Error-Rate" \
        --alarm-description "Tasa de errores alta en ML" \
        --metric-name PredictionErrors \
        --namespace MLApplication \
        --statistic Sum \
        --period 300 \
        --threshold 10 \
        --comparison-operator GreaterThanThreshold \
        --evaluation-periods 1 \
        --alarm-actions arn:aws:sns:region:account:ml-app-alerts
    ```

    **Alarma 3: Baja confianza del modelo**
    ```bash
    aws cloudwatch put-metric-alarm \
        --alarm-name "ML-Low-Confidence" \
        --alarm-description "Confianza baja del modelo ML" \
        --metric-name ModelConfidence \
        --namespace MLApplication \
        --statistic Average \
        --period 300 \
        --threshold 0.6 \
        --comparison-operator LessThanThreshold \
        --evaluation-periods 2 \
        --alarm-actions arn:aws:sns:region:account:ml-app-alerts
    ```

## Tarea 4: Implementar logging estructurado

Configure logging avanzado para mejor observabilidad.

14. **Cree un script de logging estructurado**:
    ```python
    # structured_logging.py
    import json
    import logging
    import boto3
    from datetime import datetime
    import traceback
    import sys
    
    class StructuredLogger:
        def __init__(self, name, log_group='/aws/ec2/ml-application'):
            self.logger = logging.getLogger(name)
            self.logger.setLevel(logging.INFO)
            
            # CloudWatch Logs client
            self.logs_client = boto3.client('logs')
            self.log_group = log_group
            self.log_stream = f"ml-app-{datetime.now().strftime('%Y-%m-%d-%H-%M-%S')}"
            
            # Crear log group y stream
            self._setup_cloudwatch_logging()
            
            # Configurar handler para CloudWatch
            handler = CloudWatchLogsHandler(self.logs_client, self.log_group, self.log_stream)
            formatter = StructuredFormatter()
            handler.setFormatter(formatter)
            self.logger.addHandler(handler)
    
        def _setup_cloudwatch_logging(self):
            """Configurar log group y stream en CloudWatch"""
            try:
                # Crear log group si no existe
                self.logs_client.create_log_group(logGroupName=self.log_group)
            except self.logs_client.exceptions.ResourceAlreadyExistsException:
                pass
            
            try:
                # Crear log stream
                self.logs_client.create_log_stream(
                    logGroupName=self.log_group,
                    logStreamName=self.log_stream
                )
            except self.logs_client.exceptions.ResourceAlreadyExistsException:
                pass
    
        def log_prediction(self, model_name, features, prediction, confidence, latency):
            """Log estructurado para predicciones"""
            log_data = {
                'event_type': 'prediction',
                'model_name': model_name,
                'prediction': prediction,
                'confidence': confidence,
                'latency_ms': latency * 1000,
                'feature_count': len(features),
                'timestamp': datetime.utcnow().isoformat()
            }
            self.logger.info("Model prediction", extra={'structured_data': log_data})
    
        def log_error(self, error_type, error_message, context=None):
            """Log estructurado para errores"""
            log_data = {
                'event_type': 'error',
                'error_type': error_type,
                'error_message': str(error_message),
                'context': context or {},
                'traceback': traceback.format_exc(),
                'timestamp': datetime.utcnow().isoformat()
            }
            self.logger.error("Application error", extra={'structured_data': log_data})
    
        def log_performance(self, operation, duration, metadata=None):
            """Log de métricas de rendimiento"""
            log_data = {
                'event_type': 'performance',
                'operation': operation,
                'duration_ms': duration * 1000,
                'metadata': metadata or {},
                'timestamp': datetime.utcnow().isoformat()
            }
            self.logger.info("Performance metric", extra={'structured_data': log_data})
    
    class StructuredFormatter(logging.Formatter):
        """Formatter para logs estructurados en JSON"""
        
        def format(self, record):
            log_entry = {
                'timestamp': datetime.utcnow().isoformat(),
                'level': record.levelname,
                'logger': record.name,
                'message': record.getMessage(),
            }
            
            # Agregar datos estructurados si existen
            if hasattr(record, 'structured_data'):
                log_entry.update(record.structured_data)
            
            return json.dumps(log_entry)
    
    class CloudWatchLogsHandler(logging.Handler):
        """Handler personalizado para CloudWatch Logs"""
        
        def __init__(self, logs_client, log_group, log_stream):
            super().__init__()
            self.logs_client = logs_client
            self.log_group = log_group
            self.log_stream = log_stream
            self.sequence_token = None
    
        def emit(self, record):
            """Enviar log a CloudWatch"""
            try:
                log_message = self.format(record)
                timestamp = int(datetime.utcnow().timestamp() * 1000)
                
                log_event = {
                    'timestamp': timestamp,
                    'message': log_message
                }
                
                kwargs = {
                    'logGroupName': self.log_group,
                    'logStreamName': self.log_stream,
                    'logEvents': [log_event]
                }
                
                if self.sequence_token:
                    kwargs['sequenceToken'] = self.sequence_token
                
                response = self.logs_client.put_log_events(**kwargs)
                self.sequence_token = response.get('nextSequenceToken')
                
            except Exception as e:
                self.handleError(record)
    ```

15. **Integre logging estructurado en su aplicación ML**:
    ```python
    # ml_app_with_structured_logging.py
    from structured_logging import StructuredLogger
    import time
    import numpy as np
    
    # Inicializar logger estructurado
    logger = StructuredLogger('MLApplication')
    
    def enhanced_predict(model, features):
        """Predicción con logging estructurado mejorado"""
        start_time = time.time()
        
        try:
            prediction = model.predict([features])[0]
            confidence = model.predict_proba([features])[0].max()
            latency = time.time() - start_time
            
            # Log estructurado de predicción
            logger.log_prediction(
                model_name="RandomForestModel",
                features=features,
                prediction=int(prediction),
                confidence=float(confidence),
                latency=latency
            )
            
            # Log de rendimiento
            logger.log_performance(
                operation="model_prediction",
                duration=latency,
                metadata={
                    'feature_dimension': len(features),
                    'model_type': 'RandomForest'
                }
            )
            
            return prediction, confidence
            
        except Exception as e:
            logger.log_error(
                error_type="prediction_error",
                error_message=str(e),
                context={'feature_count': len(features)}
            )
            raise
    ```

## Tarea 5: Configurar monitoreo de infraestructura

Configure monitoreo completo de la infraestructura subyacente.

16. **Configure métricas de sistema con CloudWatch Agent**:
    ```json
    {
        "agent": {
            "metrics_collection_interval": 60,
            "run_as_user": "cwagent"
        },
        "metrics": {
            "namespace": "MLInfrastructure",
            "metrics_collected": {
                "cpu": {
                    "measurement": [
                        "cpu_usage_idle",
                        "cpu_usage_iowait",
                        "cpu_usage_user",
                        "cpu_usage_system"
                    ],
                    "metrics_collection_interval": 60
                },
                "disk": {
                    "measurement": [
                        "used_percent"
                    ],
                    "metrics_collection_interval": 60,
                    "resources": [
                        "*"
                    ]
                },
                "diskio": {
                    "measurement": [
                        "io_time"
                    ],
                    "metrics_collection_interval": 60,
                    "resources": [
                        "*"
                    ]
                },
                "mem": {
                    "measurement": [
                        "mem_used_percent"
                    ],
                    "metrics_collection_interval": 60
                },
                "netstat": {
                    "measurement": [
                        "tcp_established",
                        "tcp_time_wait"
                    ],
                    "metrics_collection_interval": 60
                }
            }
        },
        "logs": {
            "logs_collected": {
                "files": {
                    "collect_list": [
                        {
                            "file_path": "/var/log/ml-app.log",
                            "log_group_name": "/aws/ec2/ml-application",
                            "log_stream_name": "{instance_id}/ml-app"
                        }
                    ]
                }
            }
        }
    }
    ```

17. **Aplique la configuración**:
    ```bash
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
        -a fetch-config -m ec2 -c file:/path/to/config.json -s
    ```

## Tarea 6: Implementar health checks automatizados

Cree health checks para verificar el estado de la aplicación.

18. **Cree un endpoint de health check**:
    ```python
    # health_check.py
    from flask import Flask, jsonify
    import boto3
    import psutil
    import time
    from datetime import datetime, timedelta
    
    app = Flask(__name__)
    cloudwatch = boto3.client('cloudwatch')
    
    class HealthChecker:
        def __init__(self):
            self.last_check = None
            self.health_status = {}
    
        def check_system_health(self):
            """Verificar salud del sistema"""
            health = {
                'timestamp': datetime.utcnow().isoformat(),
                'status': 'healthy',
                'checks': {}
            }
            
            # CPU usage
            cpu_percent = psutil.cpu_percent(interval=1)
            health['checks']['cpu'] = {
                'status': 'healthy' if cpu_percent < 80 else 'unhealthy',
                'value': cpu_percent,
                'threshold': 80
            }
            
            # Memory usage
            memory = psutil.virtual_memory()
            health['checks']['memory'] = {
                'status': 'healthy' if memory.percent < 85 else 'unhealthy',
                'value': memory.percent,
                'threshold': 85
            }
            
            # Disk usage
            disk = psutil.disk_usage('/')
            disk_percent = (disk.used / disk.total) * 100
            health['checks']['disk'] = {
                'status': 'healthy' if disk_percent < 90 else 'unhealthy',
                'value': disk_percent,
                'threshold': 90
            }
            
            # Overall health
            unhealthy_checks = [check for check in health['checks'].values() 
                              if check['status'] == 'unhealthy']
            
            if unhealthy_checks:
                health['status'] = 'unhealthy'
                health['unhealthy_count'] = len(unhealthy_checks)
            
            # Enviar métricas a CloudWatch
            self.send_health_metrics(health)
            
            return health
    
        def send_health_metrics(self, health):
            """Enviar métricas de salud a CloudWatch"""
            try:
                # Métrica de estado general
                cloudwatch.put_metric_data(
                    Namespace='MLApplication/Health',
                    MetricData=[
                        {
                            'MetricName': 'SystemHealth',
                            'Value': 1 if health['status'] == 'healthy' else 0,
                            'Unit': 'Count'
                        }
                    ]
                )
                
                # Métricas específicas
                for check_name, check_data in health['checks'].items():
                    cloudwatch.put_metric_data(
                        Namespace='MLApplication/Health',
                        MetricData=[
                            {
                                'MetricName': f'{check_name.title()}Usage',
                                'Value': check_data['value'],
                                'Unit': 'Percent'
                            }
                        ]
                    )
            except Exception as e:
                print(f"Error enviando métricas de salud: {e}")
    
    health_checker = HealthChecker()
    
    @app.route('/health')
    def health_check():
        """Endpoint de health check"""
        health = health_checker.check_system_health()
        status_code = 200 if health['status'] == 'healthy' else 503
        return jsonify(health), status_code
    
    @app.route('/health/deep')
    def deep_health_check():
        """Health check profundo incluyendo dependencias"""
        health = health_checker.check_system_health()
        
        # Verificar conectividad a AWS
        try:
            cloudwatch.describe_alarms(MaxRecords=1)
            health['checks']['aws_connectivity'] = {'status': 'healthy'}
        except Exception as e:
            health['checks']['aws_connectivity'] = {
                'status': 'unhealthy',
                'error': str(e)
            }
            health['status'] = 'unhealthy'
        
        status_code = 200 if health['status'] == 'healthy' else 503
        return jsonify(health), status_code
    
    if __name__ == '__main__':
        app.run(host='0.0.0.0', port=8080, debug=False)
    ```

## Tarea 7: Configurar automatización con Systems Manager

Use AWS Systems Manager para automatizar respuestas a incidentes.

19. **Cree un documento de Systems Manager para reinicio automático**:
    ```json
    {
        "schemaVersion": "2.2",
        "description": "Restart ML application on high error rate",
        "parameters": {
            "serviceName": {
                "type": "String",
                "description": "Name of the service to restart",
                "default": "ml-app"
            }
        },
        "mainSteps": [
            {
                "action": "aws:runShellScript",
                "name": "restartService",
                "inputs": {
                    "runCommand": [
                        "#!/bin/bash",
                        "echo 'Restarting ML application due to high error rate'",
                        "sudo systemctl restart {{serviceName}}",
                        "sleep 10",
                        "sudo systemctl status {{serviceName}}",
                        "echo 'Service restart completed'"
                    ]
                }
            }
        ]
    }
    ```

20. **Cree una función Lambda para automatización**:
    ```python
    # lambda_automation.py
    import boto3
    import json
    
    ssm = boto3.client('ssm')
    sns = boto3.client('sns')
    
    def lambda_handler(event, context):
        """
        Función Lambda para automatizar respuestas a alarmas
        """
        
        # Parsear mensaje de alarma SNS
        message = json.loads(event['Records'][0]['Sns']['Message'])
        alarm_name = message['AlarmName']
        new_state = message['NewStateValue']
        
        if new_state == 'ALARM':
            if 'High-Error-Rate' in alarm_name:
                # Reiniciar servicio automáticamente
                response = ssm.send_command(
                    InstanceIds=['i-1234567890abcdef0'],  # ID de su instancia
                    DocumentName='RestartMLApplication',
                    Parameters={
                        'serviceName': ['ml-app']
                    }
                )
                
                # Notificar acción tomada
                sns.publish(
                    TopicArn='arn:aws:sns:region:account:ml-app-alerts',
                    Subject='Automated Response: ML Service Restarted',
                    Message=f'Automatically restarted ML service due to {alarm_name}'
                )
        
        return {'statusCode': 200, 'body': 'Automation completed'}
    ```

## Tarea 8: Crear runbooks automatizados

Documente y automatice procedimientos de respuesta a incidentes.

21. **Cree runbooks en formato Markdown**:
    ```markdown
    # ML Application Incident Response Runbook
    
    ## High Latency Alert
    
    ### Symptoms
    - Prediction latency > 500ms for 2 consecutive periods
    - User complaints about slow responses
    
    ### Investigation Steps
    1. Check CloudWatch dashboard for system metrics
    2. Review application logs in CloudWatch Logs
    3. Check CPU and memory utilization
    4. Verify model loading status
    
    ### Automated Actions
    - Scale up instance size if CPU > 80%
    - Restart application if memory > 85%
    - Switch to cached predictions if latency > 1s
    
    ### Manual Escalation
    - Contact ML team if issue persists > 30 minutes
    - Consider rolling back recent deployments
    ```

22. **Implemente runbook automatizado**:
    ```python
    # automated_runbook.py
    import boto3
    import json
    import time
    from datetime import datetime, timedelta
    
    class IncidentResponseSystem:
        def __init__(self):
            self.cloudwatch = boto3.client('cloudwatch')
            self.ec2 = boto3.client('ec2')
            self.ssm = boto3.client('ssm')
            self.sns = boto3.client('sns')
    
        def handle_high_latency_incident(self, instance_id):
            """Manejar incidente de alta latencia"""
            print("🚨 Ejecutando runbook para alta latencia")
            
            # Paso 1: Recopilar métricas
            metrics = self.gather_system_metrics(instance_id)
            
            # Paso 2: Diagnóstico automático
            diagnosis = self.diagnose_issue(metrics)
            
            # Paso 3: Aplicar remediación
            actions_taken = self.apply_remediation(instance_id, diagnosis)
            
            # Paso 4: Verificar resolución
            resolution_status = self.verify_resolution(instance_id)
            
            # Paso 5: Generar reporte
            self.generate_incident_report(diagnosis, actions_taken, resolution_status)
    
        def gather_system_metrics(self, instance_id):
            """Recopilar métricas del sistema"""
            end_time = datetime.utcnow()
            start_time = end_time - timedelta(minutes=10)
            
            metrics = {}
            
            # CPU utilization
            cpu_response = self.cloudwatch.get_metric_statistics(
                Namespace='AWS/EC2',
                MetricName='CPUUtilization',
                Dimensions=[{'Name': 'InstanceId', 'Value': instance_id}],
                StartTime=start_time,
                EndTime=end_time,
                Period=300,
                Statistics=['Average']
            )
            
            if cpu_response['Datapoints']:
                metrics['cpu_avg'] = sum(dp['Average'] for dp in cpu_response['Datapoints']) / len(cpu_response['Datapoints'])
            
            return metrics
    
        def diagnose_issue(self, metrics):
            """Diagnosticar problema basado en métricas"""
            diagnosis = {'issues': [], 'severity': 'low'}
            
            if metrics.get('cpu_avg', 0) > 80:
                diagnosis['issues'].append('high_cpu')
                diagnosis['severity'] = 'high'
            
            if metrics.get('memory_percent', 0) > 85:
                diagnosis['issues'].append('high_memory')
                diagnosis['severity'] = 'high'
            
            return diagnosis
    
        def apply_remediation(self, instance_id, diagnosis):
            """Aplicar acciones de remediación"""
            actions = []
            
            if 'high_cpu' in diagnosis['issues']:
                # Escalar instancia
                actions.append(self.scale_instance(instance_id))
            
            if 'high_memory' in diagnosis['issues']:
                # Reiniciar aplicación
                actions.append(self.restart_application(instance_id))
            
            return actions
    
        def scale_instance(self, instance_id):
            """Escalar instancia a tipo más grande"""
            try:
                # En un escenario real, implementaría lógica de escalado
                print(f"🔧 Escalando instancia {instance_id}")
                return {'action': 'scale_up', 'status': 'success'}
            except Exception as e:
                return {'action': 'scale_up', 'status': 'failed', 'error': str(e)}
    
        def restart_application(self, instance_id):
            """Reiniciar aplicación ML"""
            try:
                response = self.ssm.send_command(
                    InstanceIds=[instance_id],
                    DocumentName='AWS-RunShellScript',
                    Parameters={
                        'commands': [
                            'sudo systemctl restart ml-app',
                            'sleep 10',
                            'sudo systemctl status ml-app'
                        ]
                    }
                )
                return {'action': 'restart_app', 'status': 'success', 'command_id': response['Command']['CommandId']}
            except Exception as e:
                return {'action': 'restart_app', 'status': 'failed', 'error': str(e)}
    ```

## Desafío opcional: Distributed tracing

Si completa las tareas principales, implemente distributed tracing.

23. **Configure AWS X-Ray para tracing**:
    ```python
    # xray_tracing.py
    from aws_xray_sdk.core import xray_recorder
    from aws_xray_sdk.core import patch_all
    import boto3
    import time
    
    # Patch AWS SDK calls
    patch_all()
    
    @xray_recorder.capture('ml_prediction')
    def traced_prediction(model, features):
        """Predicción con tracing distribuido"""
        
        # Crear subsegmento para preprocessing
        subsegment = xray_recorder.begin_subsegment('preprocessing')
        try:
            # Simular preprocessing
            processed_features = preprocess_features(features)
            subsegment.put_metadata('feature_count', len(features))
        finally:
            xray_recorder.end_subsegment()
        
        # Crear subsegmento para predicción
        subsegment = xray_recorder.begin_subsegment('model_inference')
        try:
            prediction = model.predict([processed_features])[0]
            confidence = model.predict_proba([processed_features])[0].max()
            
            subsegment.put_metadata('prediction', int(prediction))
            subsegment.put_metadata('confidence', float(confidence))
        finally:
            xray_recorder.end_subsegment()
        
        return prediction, confidence
    ```

## Limpieza de recursos

Al finalizar el laboratorio:

24. Elimine las alarmas de CloudWatch creadas
25. Elimine el tema SNS y suscripciones
26. Detenga el agente de CloudWatch
27. Elimine los log groups si no los necesita

## Conclusión

En este laboratorio ha aprendido a:

- ✅ Configurar monitoreo completo con CloudWatch
- ✅ Implementar métricas personalizadas para aplicaciones ML
- ✅ Crear dashboards informativos y alertas proactivas
- ✅ Configurar logging estructurado para mejor observabilidad
- ✅ Automatizar respuestas a incidentes con Systems Manager
- ✅ Implementar health checks y runbooks automatizados
- ✅ Configurar distributed tracing para microservicios

Un sistema de monitoreo robusto es esencial para mantener aplicaciones de ML funcionando de manera confiable en producción.

---

## Recursos adicionales

- [Guía de CloudWatch](https://docs.aws.amazon.com/cloudwatch/)
- [AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/)
- [AWS X-Ray Developer Guide](https://docs.aws.amazon.com/xray/)
- [Mejores prácticas de observabilidad](https://aws.amazon.com/architecture/well-architected/)
