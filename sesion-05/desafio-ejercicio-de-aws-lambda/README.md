# Ejercicio de AWS Lambda (Desafío)

## Información general del laboratorio

En este laboratorio de desafío, creará una función de AWS Lambda para contar el número de palabras en un archivo de texto.



## Objetivos

Después de completar este laboratorio, podrá hacer lo siguiente:


-	Crear una función de AWS Lambda para contar el número de palabras en un archivo de texto.

-	Configurar un bucket de Amazon Simple Storage Service (Amazon S3) para invocar una función de Lambda cuando un archivo de texto se carga en un bucket de S3.

-	Crear un tema de Amazon Simple Notification Service (Amazon SNS) para informar el recuento de palabras en un correo electrónico.



## Duración

El tiempo estimado para completar este laboratorio es de **90 minutos**.



## Iniciar el entorno de laboratorio

1. En la parte superior de estas instrucciones, elija <span id="ssb_voc_grey">Start Lab</span> (Comenzar laboratorio) para iniciar el laboratorio.

	Se abrirá el panel **Start Lab** (Comenzar laboratorio), donde se muestra el estado del laboratorio.

2. Espere hasta que aparezca el mensaje “Lab status: ready” (Estado de la sesión de laboratorio: listo) y, a continuación, elija la **X** para cerrar el panel **Start Lab** (Comenzar laboratorio).

   Este laboratorio aprovisiona una nueva cuenta de Amazon Web Services (AWS) para usted donde creará la función de Lambda y los recursos necesarios para completar el desafío.



## El desafío

3. Crear una función de AWS Lambda para contar el número de palabras en un archivo de texto. Los pasos generales son los siguientes:

   - Utilice la Consola de administración de AWS para desarrollar una función de Lambda en Python y crear los recursos necesarios.

   
   - Informe el recuento de palabras en un correo electrónico usando un tema de SNS. Opcionalmente, envíe también el resultado en un mensaje SMS (texto).

   
   - Dé formato al mensaje de respuesta de la siguiente manera:
   
     ```
     The word count in the <textFileName> file is nnn. 
     ```
   
     Reemplace *\<textFileName>* por el nombre del archivo.

   
   - Ingrese el siguiente texto como asunto del correo electrónico: `Word Count Result`

   
     - Invoque de forma automática la función cuando el archivo de texto se cargue en un bucket de S3.

4. Pruebe la función cargando algunos archivos de texto de muestra con diferentes recuentos de palabras en el bucket de S3.

5. Reenvíe a su instructor el correo electrónico que produce una de sus pruebas y una captura de pantalla de la función de Lambda.



**Sugerencias **

* Cree todos sus recursos en la misma región de AWS.

* Necesitará un rol de AWS Identity and Access Management (AWS IAM) para que la función de Lambda acceda a otros servicios de AWS. Debido a que la política del laboratorio no permite la creación de un rol de IAM, utilice el rol **LambdaAccessRole**. El rol LambdaAccessRole proporciona los siguientes permisos:

   * AWSLambdaBasicExecutionRole

     Esto es una política administrada de AWS que proporciona permisos de escritura a Registros de Amazon CloudWatch.

   * AmazonSNSFullAccess

     Esto es una política administrada de AWS que proporciona acceso completo a Amazon SNS a través de la Consola de administración de AWS.

   * AmazonS3FullAccess

     Esto es una política administrada de AWS que proporciona acceso completo a todos los buckets a través de la Consola de administración de AWS.

   * CloudWatchFullAccess

     Esto es una política administrada de AWS que proporciona acceso completo a Amazon CloudWatch.

* Consulte el siguiente laboratorio para obtener orientación adicional:
  * Trabajo con AWS Lambda



## Conclusión

¡Felicitaciones! Realizó correctamente lo siguiente:


-	Creó una función de Lambda para contar el número de palabras en un archivo de texto.

-	Configuró un bucket de S3 para invocar una función de Lambda cuando un archivo de texto se cargó en un bucket de S3.

-	Creó un tema de Amazon SNS para informar el recuento de palabras en un correo electrónico.



## Laboratorio completado

Cuando termine el laboratorio, siga estos pasos para finalizarlo:

6. En la parte superior de esta página, seleccione <span id="ssb_voc_grey">End Lab</span> (Finalizar laboratorio) y, a continuación, elija <span id="ssb_blue">Yes</span> (Sí) para confirmar que desea finalizarlo.  

    Aparecerá un panel que indica “You may close this message box now. Lab resources are terminating.” (Ya puede cerrar este cuadro de mensaje. Los recursos del laboratorio se están cerrando).

7. Para cerrar el panel **End lab** (Finalizar laboratorio), seleccione la **X** en la esquina superior derecha. 



## Recursos adicionales


- [¿Qué es AWS Lambda?](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)


- [Uso de un desencadenador de Amazon S3 para invocar una función de Lambda](https://docs.aws.amazon.com/lambda/latest/dg/with-s3-example.html)


- [Política administrada de AWS](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html#aws-managed-policies)


Para obtener más información sobre AWS Training and Certification, consulte [AWS Training and Certification](http://aws.amazon.com/training/).

*Sus comentarios son bienvenidos y valorados.*

Si desea compartir alguna sugerencia o corrección, ingrese los detalles en nuestro [Formulario de contacto de AWS Training and Certification](https://support.aws.amazon.com/#/contacts/aws-training).

*© 2023, Amazon Web Services, Inc. o sus filiales. Todos los derechos reservados. Este contenido no puede reproducirse ni redistribuirse, total ni parcialmente, sin el permiso previo por escrito de Amazon Web Services, Inc. Queda prohibida la copia, el préstamo o la venta de carácter comercial.*
