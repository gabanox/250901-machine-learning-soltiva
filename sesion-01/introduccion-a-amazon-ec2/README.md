# 📖 Laboratorio 1.1: Introducción a Amazon EC2

## 🎯 Objetivo
Introducción a la computación en la nube con Amazon Elastic Compute Cloud (EC2). Los estudiantes aprenderán a lanzar, configurar y gestionar instancias virtuales.

## ⏱️ Duración
45 minutos

## 🛠️ Servicios AWS
- Amazon EC2

## 🎓 Objetivo de Certificación
AWS Cloud Practitioner

---

## 🚀 Aprovisionamiento de Infraestructura

Antes de comenzar el laboratorio, necesitas aprovisionar la infraestructura base usando CloudFormation.

### 📋 Prerrequisitos
- AWS CLI configurado
- Permisos de CloudFormation en tu cuenta AWS
- Key Pair existente en EC2 (opcional, según el template)

### 🔧 Script de Aprovisionamiento

```bash
#!/bin/bash
# Script para aprovisionar infraestructura del laboratorio EC2

STACK_NAME="lab-ec2-infrastructure"
TEMPLATE_FILE="lab.template"
REGION="us-east-1"

echo "🚀 Desplegando infraestructura del laboratorio EC2..."

aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://$TEMPLATE_FILE \
  --region $REGION \
  --capabilities CAPABILITY_IAM

echo "⏳ Esperando que se complete el despliegue..."

aws cloudformation wait stack-create-complete \
  --stack-name $STACK_NAME \
  --region $REGION

if [ $? -eq 0 ]; then
    echo "✅ Infraestructura desplegada exitosamente!"
    echo "📊 Puedes ver los recursos creados en la consola de CloudFormation"
else
    echo "❌ Error en el despliegue. Revisa los logs de CloudFormation"
fi
```

### 💻 Comandos de CLI

**1. Desplegar el stack:**
```bash
aws cloudformation create-stack \
  --stack-name lab-ec2-infrastructure \
  --template-body file://lab.template \
  --region us-east-1 \
  --capabilities CAPABILITY_IAM
```

**2. Verificar el estado del despliegue:**
```bash
aws cloudformation describe-stacks \
  --stack-name lab-ec2-infrastructure \
  --region us-east-1 \
  --query 'Stacks[0].StackStatus'
```

**3. Obtener los outputs del stack:**
```bash
aws cloudformation describe-stacks \
  --stack-name lab-ec2-infrastructure \
  --region us-east-1 \
  --query 'Stacks[0].Outputs'
```

**4. Limpiar recursos al finalizar:**
```bash
aws cloudformation delete-stack \
  --stack-name lab-ec2-infrastructure \
  --region us-east-1
```

---

## 📚 Contenido del Laboratorio

Una vez aprovisionada la infraestructura, continúa con el laboratorio:

### [📄 Guía del Laboratorio](./lab-guide.md)

---

## 🧭 Navegación

| Anterior | Inicio | Siguiente |
|----------|--------|-----------|
| [⬅️ Sesión 1](../README.md) | [🏠 Inicio](../../README.md) | [🔐 Lab 1.2: IAM ➡️](../introduccion-a-la-gestion-de-identidades-y-accesos-iam/README.md) |

---

## 📞 Soporte
Para dudas sobre este laboratorio, contacta: **operaciones@bootcamp.institute**
