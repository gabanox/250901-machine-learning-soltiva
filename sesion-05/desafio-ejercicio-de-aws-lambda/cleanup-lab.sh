#!/bin/bash
# Script para limpiar recursos del laboratorio Lambda Challenge

STACK_NAME="lab-lambda-challenge-infrastructure"
REGION="us-east-1"

echo "🧹 Limpiando recursos del laboratorio Lambda Challenge..."

aws cloudformation delete-stack \
  --stack-name $STACK_NAME \
  --region $REGION

echo "⏳ Esperando que se complete la eliminación..."

aws cloudformation wait stack-delete-complete \
  --stack-name $STACK_NAME \
  --region $REGION

if [ $? -eq 0 ]; then
    echo "✅ Recursos eliminados exitosamente!"
else
    echo "❌ Error en la eliminación. Revisa los logs de CloudFormation"
fi
