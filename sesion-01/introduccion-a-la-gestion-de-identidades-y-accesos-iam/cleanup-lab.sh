#!/bin/bash
# Script para limpiar recursos del laboratorio IAM

STACK_NAME="lab-iam-infrastructure"
REGION="us-east-1"

echo "🧹 Limpiando recursos del laboratorio IAM..."

aws cloudformation delete-stack \
  --stack-name $STACK_NAME \
  --region $REGION

echo "⏳ Esperando que se complete la eliminación..."

aws cloudformation wait stack-delete-complete \
  --stack-name $STACK_NAME \
  --region $REGION

if [ $? -eq 0 ]; then
    echo "✅ Recursos eliminados exitosamente!"
    echo "👥 Usuarios IAM y recursos asociados han sido eliminados"
else
    echo "❌ Error en la eliminación. Revisa los logs de CloudFormation"
fi
