# 📖 Trabajo con Amazon S3

## 🎯 Objetivo
Trabajar con AWS S3. Los estudiantes aprenderan a: Utilizar los comandos de AWS CLI s3api y s3 para crear y configurar un bucket de S3, verificar los permisos de escritura para un usuario en un bucket de S3, configurar las notificaciones de eventos en un bucket de S3.

## ⏱️ Duración
90 minutos

## 🛠️ Servicios AWS
- Amazon EC2, Amazon S3

## 🎓 Objetivo de Certificación
AWS Cloud Practitioner

---

## 🚀 Aprovisionamiento de Infraestructura

Antes de comenzar el laboratorio, necesitas aprovisionar la infraestructura base usando CloudFormation.

### 📋 Prerrequisitos
- AWS CLI configurado
- Permisos de CloudFormation en tu cuenta AWS
- Key Pair existente en EC2 (según el template) llamada lab-key-pair

### 🔧 Script de Aprovisionamiento

```bash
#!/bin/bash
# Script para aprovisionar infraestructura del laboratorio EC2

STACK_NAME="lab-s3-work"
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
  --stack-name lab-s3-work \
  --template-body file://lab.template \
  --region us-east-1 \
  --capabilities CAPABILITY_IAM
```

**2. Verificar el estado del despliegue:**
```bash
aws cloudformation describe-stacks \
  --stack-name lab-s3-work \
  --region us-east-1 \
  --query 'Stacks[0].StackStatus'
```

**3. Obtener los outputs del stack:**
```bash
aws cloudformation describe-stacks \
  --stack-name lab-s3-work \
  --region us-east-1 \
  --query 'Stacks[0].Outputs'
```

**4. Limpiar recursos al finalizar:**
```bash
aws cloudformation delete-stack \
  --stack-name lab-s3-work \
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
| [⬅️ Sesión 3](../README.md) | [🏠 Inicio](../../README.md) | [🔐 Instalar y configurar la AWS CLI ➡️](../instalar-y-configurar-la-aws-cli/README.md) |

---

## 📞 Soporte
Para dudas sobre este laboratorio, contacta: **operaciones@bootcamp.institute**
