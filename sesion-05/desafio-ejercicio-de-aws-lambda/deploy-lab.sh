#!/bin/bash
# Script para aprovisionar infraestructura del laboratorio Lambda Challenge

STACK_NAME="lab-lambda-challenge-infrastructure"
TEMPLATE_FILE="lab.template"
REGION="us-east-1"

echo "🚀 Desplegando infraestructura del laboratorio Lambda Challenge..."

aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://$TEMPLATE_FILE \
  --region $REGION \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

echo "⏳ Esperando que se complete el despliegue..."

aws cloudformation wait stack-create-complete \
  --stack-name $STACK_NAME \
  --region $REGION

if [ $? -eq 0 ]; then
    echo "✅ Infraestructura desplegada exitosamente!"
    echo "📊 Puedes ver los recursos creados en la consola de CloudFormation"
    echo "⚡ Se ha creado el rol IAM para el desafío Lambda"
    
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
