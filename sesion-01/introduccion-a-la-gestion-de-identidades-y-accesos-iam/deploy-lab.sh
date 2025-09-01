#!/bin/bash
# Script para aprovisionar infraestructura del laboratorio IAM

STACK_NAME="lab-iam-infrastructure"
TEMPLATE_FILE="lab.template"
REGION="us-east-1"

# Verificar si se proporcionó el key pair como parámetro
if [ -z "$1" ]; then
    echo "❌ Error: Debes proporcionar el nombre de tu Key Pair"
    echo "💡 Uso: ./deploy-lab.sh YOUR_KEY_PAIR_NAME"
    echo "📝 Ejemplo: ./deploy-lab.sh my-key-pair"
    exit 1
fi

KEY_NAME="$1"

echo "🚀 Desplegando infraestructura del laboratorio IAM..."
echo "🔑 Usando Key Pair: $KEY_NAME"

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
    
    # Mostrar outputs del stack
    echo "📋 Recursos creados:"
    aws cloudformation describe-stacks \
      --stack-name $STACK_NAME \
      --region $REGION \
      --query 'Stacks[0].Outputs' \
      --output table
else
    echo "❌ Error en el despliegue. Revisa los logs de CloudFormation"
fi
