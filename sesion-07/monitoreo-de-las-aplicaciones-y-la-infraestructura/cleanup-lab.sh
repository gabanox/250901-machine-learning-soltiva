#!/bin/bash
# Script para limpiar recursos del laboratorio de Monitoreo

STACK_NAME="lab-monitoring-infrastructure"
REGION="us-east-1"

echo "🧹 Limpiando recursos del laboratorio de Monitoreo..."

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
