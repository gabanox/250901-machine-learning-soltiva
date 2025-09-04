# Instalar y configurar la AWS CLI

## Información general del laboratorio

La interfaz de línea de comandos de AWS (AWS CLI) es una herramienta unificada para administrar los servicios de AWS. Con solo una herramienta para descargar y configurar, puede controlar múltiples servicios de AWS desde la línea de comandos y automatizar tareas mediante scripts.

En este laboratorio, instalará y configurará AWS CLI en una instancia EC2, y aprenderá a usar comandos básicos para interactuar con diversos servicios de AWS. Este es un skill fundamental para administradores de sistemas y desarrolladores que trabajan con AWS.

## Objetivos

Al finalizar este laboratorio, podrá realizar lo siguiente:

- Instalar AWS CLI en una instancia Linux de Amazon EC2
- Configurar AWS CLI con credenciales y configuración regional
- Usar comandos básicos de AWS CLI para interactuar con servicios
- Automatizar tareas comunes usando scripts de AWS CLI
- Gestionar perfiles de configuración múltiples
- Implementar mejores prácticas de seguridad con AWS CLI

## Duración

El tiempo estimado para completar este laboratorio es de **30 minutos**.

## Tarea 1: Conectarse a la instancia EC2

En esta tarea, se conectará a la instancia EC2 proporcionada donde instalará AWS CLI.

1. En la **Consola de administración de AWS**, navegue a **EC2**.

2. En el panel de EC2, seleccione **Instancias**.

3. Seleccione la instancia llamada **CLI Host** o similar.

4. Elija **Conectar**.

5. Use **EC2 Instance Connect** o **SSH** para conectarse a la instancia.

6. Una vez conectado, verifique la información del sistema:
   ```bash
   cat /etc/os-release
   uname -a
   ```

## Tarea 2: Instalar AWS CLI

AWS CLI ya puede estar preinstalado en instancias de Amazon Linux. Verificaremos y actualizaremos si es necesario.

7. Verifique si AWS CLI está instalado:
   ```bash
   aws --version
   ```

8. Si no está instalado o necesita actualización, instale la versión más reciente:
   ```bash
   # Descargar el instalador
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   
   # Instalar unzip si no está disponible
   sudo yum install unzip -y
   
   # Descomprimir el instalador
   unzip awscliv2.zip
   
   # Ejecutar el instalador
   sudo ./aws/install
   
   # Verificar la instalación
   aws --version
   ```

## Tarea 3: Configurar AWS CLI

En esta tarea, configurará AWS CLI con las credenciales necesarias.

9. Inicie la configuración de AWS CLI:
    ```bash
    aws configure
    ```

10. Cuando se le solicite, ingrese la información de configuración:
    - **AWS Access Key ID**: Use las credenciales del laboratorio
    - **AWS Secret Access Key**: La clave secreta correspondiente
    - **Default region name**: `us-east-1`
    - **Default output format**: `json`

11. Verifique la configuración:
    ```bash
    aws configure list
    ```

12. Pruebe la configuración listando los buckets de S3:
    ```bash
    aws s3 ls
    ```

## Tarea 4: Comandos básicos de AWS CLI

Explore comandos fundamentales para diferentes servicios de AWS.

### Trabajar con Amazon S3

13. Crear un bucket de prueba:
    ```bash
    aws s3 mb s3://mi-bucket-cli-test-$(date +%Y%m%d)
    ```

14. Cargar un archivo al bucket:
    ```bash
    echo "Hola desde AWS CLI" > test-file.txt
    aws s3 cp test-file.txt s3://mi-bucket-cli-test-$(date +%Y%m%d)/
    ```

15. Listar contenido del bucket:
    ```bash
    aws s3 ls s3://mi-bucket-cli-test-$(date +%Y%m%d)/
    ```

### Trabajar con Amazon EC2

16. Listar instancias EC2:
    ```bash
    aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType]' --output table
    ```

17. Describir grupos de seguridad:
    ```bash
    aws ec2 describe-security-groups --query 'SecurityGroups[*].[GroupName,GroupId]' --output table
    ```

## Tarea 5: Crear scripts de automatización

Desarrolle scripts para automatizar tareas comunes.

18. Crear un script para backup de archivos a S3:
    ```bash
    cat > backup-script.sh << 'EOF'
    #!/bin/bash
    
    BUCKET_NAME="mi-bucket-cli-test-$(date +%Y%m%d)"
    BACKUP_DIR="/tmp/backup"
    DATE=$(date +%Y%m%d_%H%M%S)
    
    mkdir -p $BACKUP_DIR
    echo "Backup creado el $(date)" > $BACKUP_DIR/backup_$DATE.txt
    
    aws s3 sync $BACKUP_DIR s3://$BUCKET_NAME/backups/
    echo "Backup completado en s3://$BUCKET_NAME/backups/"
    EOF
    ```

19. Hacer el script ejecutable y ejecutarlo:
    ```bash
    chmod +x backup-script.sh
    ./backup-script.sh
    ```

## Tarea 6: Cleanup y verificación

Limpie los recursos creados durante el laboratorio.

20. Eliminar archivos de prueba del bucket:
    ```bash
    aws s3 rm s3://mi-bucket-cli-test-$(date +%Y%m%d)/ --recursive
    ```

21. Eliminar el bucket:
    ```bash
    aws s3 rb s3://mi-bucket-cli-test-$(date +%Y%m%d)
    ```

## Conclusión

En este laboratorio ha aprendido a:

- ✅ Instalar y configurar AWS CLI en Linux
- ✅ Usar comandos básicos para múltiples servicios de AWS
- ✅ Crear scripts de automatización para tareas comunes
- ✅ Implementar mejores prácticas de seguridad

AWS CLI es una herramienta poderosa que permite automatizar prácticamente cualquier tarea en AWS.

---

## Recursos adicionales

- [Guía del usuario de AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/)
- [Referencia de comandos de AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/)