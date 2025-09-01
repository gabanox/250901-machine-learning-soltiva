# 🔐 Laboratorio 1.2: Gestión de Identidades y Accesos (IAM)

## 🎯 Objetivo
Fundamentos de seguridad en AWS. Creación y gestión de usuarios, grupos, roles y políticas de seguridad para controlar el acceso a recursos.

## ⏱️ Duración
60 minutos

## 🛠️ Servicios AWS
- AWS IAM
- Amazon EC2
- Amazon S3

## 🎓 Objetivo de Certificación
AWS Cloud Practitioner

---

## 🚀 Aprovisionamiento de Infraestructura

Antes de comenzar el laboratorio, necesitas aprovisionar la infraestructura base usando CloudFormation.

### 📋 Prerrequisitos
- AWS CLI configurado
- Permisos de CloudFormation en tu cuenta AWS
- Key Pair existente en EC2

### 🔧 Script de Aprovisionamiento

```bash
#!/bin/bash
# Script para aprovisionar infraestructura del laboratorio IAM

STACK_NAME="lab-iam-infrastructure"
TEMPLATE_FILE="lab.template"
REGION="us-east-1"
KEY_NAME="your-key-pair-name"  # Reemplaza con tu key pair

echo "🚀 Desplegando infraestructura del laboratorio IAM..."

aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://$TEMPLATE_FILE \
  --region $REGION \
  --parameters ParameterKey=KeyName,ParameterValue=$KEY_NAME \
  --capabilities CAPABILITY_IAM

echo "⏳ Esperando que se complete el despliegue..."

aws cloudformation wait stack-create-complete \
  --stack-name $STACK_NAME \
  --region $REGION

if [ $? -eq 0 ]; then
    echo "✅ Infraestructura desplegada exitosamente!"
    echo "📊 Puedes ver los recursos creados en la consola de CloudFormation"
    echo "👥 Se han creado usuarios IAM para el laboratorio"
else
    echo "❌ Error en el despliegue. Revisa los logs de CloudFormation"
fi
```

### 💻 Comandos de CLI

**1. Desplegar el stack (reemplaza YOUR_KEY_PAIR con tu key pair):**
```bash
aws cloudformation create-stack \
  --stack-name lab-iam-infrastructure \
  --template-body file://lab.template \
  --region us-east-1 \
  --parameters ParameterKey=KeyName,ParameterValue=YOUR_KEY_PAIR \
  --capabilities CAPABILITY_IAM
```

**2. Verificar el estado del despliegue:**
```bash
aws cloudformation describe-stacks \
  --stack-name lab-iam-infrastructure \
  --region us-east-1 \
  --query 'Stacks[0].StackStatus'
```

**3. Obtener información de usuarios creados:**
```bash
aws cloudformation describe-stacks \
  --stack-name lab-iam-infrastructure \
  --region us-east-1 \
  --query 'Stacks[0].Outputs'
```

**4. Limpiar recursos al finalizar:**
```bash
aws cloudformation delete-stack \
  --stack-name lab-iam-infrastructure \
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
| [⬅️ 📖 Lab 1.1: EC2](../introduccion-a-amazon-ec2/README.md) | [🏠 Inicio](../../README.md) | [🌐 Sesión 2: Redes ➡️](../../sesion-02/README.md) |

---

## 📞 Soporte
Para dudas sobre este laboratorio, contacta: **operaciones@bootcamp.institute**
