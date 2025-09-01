# 🚀 Machine Learning en AWS - Guía de Laboratorios
## 250901-MACHINE-LEARNING-SOLTIVA

### 📋 Descripción General

Esta guía de laboratorios está diseñada para proporcionar una experiencia de aprendizaje práctica y progresiva en Amazon Web Services (AWS), con un enfoque específico en Machine Learning. A través de 7 sesiones estructuradas, los estudiantes desarrollarán competencias desde los fundamentos de la nube hasta arquitecturas avanzadas de ML.

### 🎯 Objetivos de Certificación

Los laboratorios están alineados con múltiples rutas de certificación AWS:
- **AWS Cloud Practitioner**: Fundamentos de la nube
- **AWS Certified Machine Learning - Associate**: Servicios de ML y análisis de datos
- **AWS Certified Machine Learning - Specialty**: Arquitecturas avanzadas de ML

### 📚 Hilo Conductor del Aprendizaje

El programa sigue una progresión lógica:
1. **Fundamentos**: Servicios básicos de AWS (EC2, IAM)
2. **Redes**: Configuración de infraestructura (VPC)
3. **Almacenamiento**: Gestión de datos (S3, CLI)
4. **Bases de Datos**: Almacenamiento estructurado (RDS, DynamoDB)
5. **Computación Serverless**: Funciones Lambda
6. **Programación**: Python para ML
7. **Arquitecturas Avanzadas**: Escalado y monitoreo

---

## 📅 Sesiones y Laboratorios

### 🔰 Sesión 1: Fundamentos de AWS
**Duración Total**: 120 minutos  
**Enfoque**: Introducción a servicios básicos de AWS

#### [📖 Laboratorio 1.1: Introducción a Amazon EC2](./sesion-01/introduccion-a-amazon-ec2/)
- **Duración**: 45 minutos
- **Servicios AWS**: EC2
- **Objetivo de Certificación**: Cloud Practitioner
- **Descripción**: Introducción a la computación en la nube con Amazon Elastic Compute Cloud (EC2). Los estudiantes aprenderán a lanzar, configurar y gestionar instancias virtuales.

#### [🔐 Laboratorio 1.2: Gestión de Identidades y Accesos (IAM)](./sesion-01/introduccion-a-la-gestion-de-identidades-y-accesos-iam/)
- **Duración**: 60 minutos
- **Servicios AWS**: IAM, EC2, S3
- **Objetivo de Certificación**: Cloud Practitioner
- **Descripción**: Fundamentos de seguridad en AWS. Creación y gestión de usuarios, grupos, roles y políticas de seguridad para controlar el acceso a recursos.

#### Sesión de Discusión y Q&A
- **Duración**: 15 minutos
- **Objetivo**: Consolidación de conceptos fundamentales

---

### 🌐 Sesión 2: Redes y VPC
**Duración Total**: 120 minutos  
**Enfoque**: Configuración de infraestructura de red

#### [🌐 Laboratorio 2.1: Configuración de Amazon VPC](./sesion-02/configuracion-de-una-amazon-vpc/)
- **Duración**: 45 minutos
- **Servicios AWS**: VPC, EC2
- **Objetivo de Certificación**: Cloud Practitioner + ML
- **Descripción**: Creación de redes virtuales privadas en AWS. Configuración de subredes, tablas de enrutamiento y gateways de internet.

#### [🖥️ Laboratorio 2.2: Creación de VPC y Servidor Web](./sesion-02/creacion-de-una-vpc-y-lanzamiento-de-un-servidor-web/)
- **Duración**: 45 minutos
- **Servicios AWS**: EC2, VPC
- **Objetivo de Certificación**: Cloud Practitioner + ML
- **Descripción**: Implementación práctica de una VPC completa con lanzamiento de un servidor web, integrando conceptos de redes y computación.

#### [🔗 Laboratorio 2.3: Recursos de Red para VPC](./sesion-02/recursos-de-red-para-una-vpc/)
- **Duración**: 30 minutos
- **Servicios AWS**: EC2, VPC
- **Objetivo de Certificación**: Cloud Practitioner + ML
- **Descripción**: Configuración avanzada de recursos de red, incluyendo grupos de seguridad, ACLs de red y conectividad entre subredes.

---

### 💾 Sesión 3: Almacenamiento y CLI
**Duración Total**: 120 minutos  
**Enfoque**: Gestión de datos y herramientas de línea de comandos

#### [🪣 Laboratorio 3.1: Trabajo con Amazon S3](./sesion-03/trabajo-con-amazon-s3/)
- **Duración**: 90 minutos
- **Servicios AWS**: S3, SNS, IAM
- **Objetivo de Certificación**: Cloud Practitioner + ML
- **Descripción**: Almacenamiento de objetos en la nube. Creación de buckets, carga de archivos, configuración de permisos y notificaciones automáticas.

#### [⚡ Laboratorio 3.2: Instalación y Configuración de AWS CLI](./sesion-03/instalar-y-configurar-la-aws-cli/)
- **Duración**: 30 minutos
- **Servicios AWS**: EC2, IAM
- **Objetivo de Certificación**: Cloud Practitioner + ML
- **Descripción**: Configuración de la interfaz de línea de comandos de AWS para automatizar tareas y gestionar recursos programáticamente.

---

### 🗄️ Sesión 4: Bases de Datos
**Duración Total**: 120 minutos  
**Enfoque**: Almacenamiento y gestión de datos estructurados

#### [📊 Laboratorio 4.1: Migración a Amazon RDS](./sesion-04/migracion-a-amazon-rds/)
- **Duración**: 60 minutos
- **Servicios AWS**: RDS, EC2, Systems Manager, CloudWatch
- **Objetivo de Certificación**: Cloud Practitioner + ML
- **Descripción**: Migración de bases de datos relacionales a la nube. Configuración de RDS, backup automático y monitoreo de rendimiento.

#### [⚡ Laboratorio 4.2: Introducción a Amazon DynamoDB](./sesion-04/introduccion-a-amazon-dynamodb/)
- **Duración**: 35 minutos
- **Servicios AWS**: DynamoDB
- **Objetivo de Certificación**: ML Associate
- **Descripción**: Base de datos NoSQL para aplicaciones de alto rendimiento. Creación de tablas, índices y operaciones CRUD básicas.

#### [🔗 Laboratorio 4.3: Servidor de Base de Datos con Aplicación](./sesion-04/cree-su-servidor-de-base-de-datos-e-interactue-con-su-base-de-datos-usando-una-aplicacion/)
- **Duración**: 25 minutos
- **Servicios AWS**: RDS, EC2
- **Objetivo de Certificación**: ML Associate
- **Descripción**: Integración de bases de datos con aplicaciones. Conexión entre una aplicación web y una base de datos RDS.

---

### ⚡ Sesión 5: Computación Serverless
**Duración Total**: 120 minutos  
**Enfoque**: Funciones Lambda y arquitecturas event-driven

#### [⚡ Laboratorio 5.1: Trabajo con AWS Lambda](./sesion-05/trabajo-con-aws-lambda/)
- **Duración**: 60 minutos
- **Servicios AWS**: Lambda, VPC, EventBridge, IAM, Systems Manager, EC2, SNS
- **Objetivo de Certificación**: ML Associate + Specialty
- **Descripción**: Introducción a la computación serverless. Creación de funciones Lambda, triggers de eventos y integración con otros servicios AWS.

#### [🏆 Laboratorio 5.2: [Desafío] Ejercicio de AWS Lambda](./sesion-05/desafio-ejercicio-de-aws-lambda/)
- **Duración**: 60 minutos
- **Servicios AWS**: Lambda, SNS, S3
- **Objetivo de Certificación**: ML Associate + Specialty
- **Descripción**: Desafío práctico para implementar una solución completa usando Lambda, integrando procesamiento de archivos y notificaciones.

---

### 🐍 Sesión 6: Programación Python
**Duración Total**: 120 minutos  
**Enfoque**: Desarrollo en Python para Machine Learning

#### [🐍 Laboratorio 6.1: [Reto] Ejercicio Python](./sesion-06/reto-ejercicio-python/)
- **Duración**: 40 minutos
- **Servicios AWS**: EC2
- **Objetivo de Certificación**: ML Associate + Specialty
- **Descripción**: Desafío de programación en Python aplicado a casos de uso de Machine Learning, ejecutado en instancias EC2.

#### [📚 Laboratorio 6.2: Práctica Adicional de Python](./sesion-06/practica-adicional-de-python-y-revision-de-conceptos/)
- **Duración**: 80 minutos
- **Objetivo de Certificación**: ML Associate + Specialty
- **Descripción**: Sesión práctica intensiva de Python, revisión de conceptos fundamentales para ML y resolución de ejercicios aplicados.

---

### 🏗️ Sesión 7: Arquitecturas Avanzadas
**Duración Total**: 120 minutos  
**Enfoque**: Escalabilidad, monitoreo y arquitecturas de producción

#### [📊 Laboratorio 7.1: Monitoreo de Aplicaciones e Infraestructura](./sesion-07/monitoreo-de-las-aplicaciones-y-la-infraestructura/)
- **Duración**: 60 minutos
- **Servicios AWS**: CloudWatch, EC2, Systems Manager, EventBridge, Config
- **Objetivo de Certificación**: ML Specialty
- **Descripción**: Implementación de monitoreo completo de aplicaciones y infraestructura. Configuración de métricas, alarmas y automatización de respuestas.

#### [🏗️ Laboratorio 7.2: Escalado y Balanceo de Carga](./sesion-07/escalado-y-balanceo-de-carga-de-una-arquitectura/)
- **Duración**: 45 minutos
- **Servicios AWS**: EC2, ELB, ASG, CloudWatch
- **Objetivo de Certificación**: Cloud Practitioner + ML
- **Descripción**: Implementación de arquitecturas escalables con balanceadores de carga y grupos de auto escalado para aplicaciones de ML.

#### Revisión General y Q&A
- **Duración**: 15 minutos
- **Objetivo**: Consolidación de todos los conceptos y preparación para certificaciones

---



## 📊 Servicios AWS Cubiertos

| Servicio | Sesiones | Descripción |
|----------|----------|-------------|
| **EC2** | 1, 2, 3, 4, 6, 7 | Computación elástica en la nube |
| **IAM** | 1, 3, 5 | Gestión de identidades y accesos |
| **VPC** | 2, 5 | Redes virtuales privadas |
| **S3** | 1, 3, 5 | Almacenamiento de objetos |
| **RDS** | 4 | Bases de datos relacionales |
| **DynamoDB** | 4 | Base de datos NoSQL |
| **Lambda** | 5 | Computación serverless |
| **CloudWatch** | 4, 7 | Monitoreo y métricas |
| **ELB/ASG** | 7 | Balanceo de carga y escalado automático |

---

## 🛠️ Requisitos Técnicos

- Cuenta AWS (se proporcionará acceso al laboratorio)
- Navegador web moderno
- Conexión a internet estable
- Conocimientos básicos de programación (recomendado)

## 📞 Soporte

Para dudas y consultas sobre los laboratorios, utilizar los espacios de Q&A al final de cada sesión o contactar a: **operaciones@bootcamp.institute**

---

*Última actualización: Enero 2025*