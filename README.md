# Terraform GKE
Instalar Google Kubernetes Engine con Terraform (Youtube Videotutorial)
- Videotutorial Parte 1: https://youtu.be/yWiawq_SVNY
- Videotutorial Parte 2: https://youtu.be/e7zaUCvx9U8
- Videotutorial Parte 3: https://youtu.be/kr6ssILn_lM



## Provision Google Cloud Plataform
#### Crear una cuenta de Google Cloud Plataform
* Acceder a https://console.cloud.google.com
* Click en el link crear una cuenta, y luego seleccionar "Para mi"
* Llenas tus datos personales, puedes usar un correo que no sea de google si es necesario.
* Sigues los pasos indicados y listo.
* Adicionalmente para obtener un credito gratuito de $300 por un año gratis, debes de
ingresar los datos de tu tarjeta de credito.


#### Crear proyecto
* Una vez habiendo creado la cuenta el siguiente paso es crear un proyecto, por defecto ya deberias tener uno,
pero puedes crear mas.
* En la parte superior izquierda al lado del logotipo de google cloud plataform se encuentran los proyectos,
al dar click sobre el proyecto actual se te desplega una ventana con todos los proyectos que has creado.
* Para crear un nuevo proyecto das click en la esquina superior derecha de la ventana de proyectos, colocas el nombre y listo,
ya tienes un nuevo pryecto.

#### Crear Service Account para el proyecto terraform
* En el menu de la izquierda busca la opcion IAM & admin.
* Dentro de IAM, en el menu de IAM seleccionar la service account
* Seleccionar la opcion create service account, llena los datos solicitados y adicionalmente 
le da los siguientes permisos al service account 
  - Compute Admin
  - Kubernetes Engine Admin
  - Service Account User
  - Service Networking Admin
  - Storage Admin
* Una vez creada el service account, le debe aparecer en la lista, da click en los tres puntitos de la seccion 
actions, y seleccionar create key, selecciona JSON y posteriormente se le descargara la llave que le 
permitira a terraform crear todos los recursos en Google Cloud Plataform

#### Activar las APIS de Google
* Para activar las Apis de Google de cada producto, debe acceder al menu principal y seleccionar 
APIs & Services
* En la parte super click en la opcion Enable APIS and Services.
* Buscar la API que necesita activar y listo.
* Para este proyecto las APIS que necesitan estar activadas son las siguientes:
  - fds

##  Terraform Install
#### Instalar terraform
* Instalar la version terraform 0.12.5
* Para facilitar el manejo de versiones instalar tfswitch
```shell script
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
```
* Luego llamar el comando tfswitch en consola, seleccionar la version y listo
* Manual de instalacion 
https://medium.com/@warrensbox/how-to-manage-different-terraform-versions-for-each-project-51cca80ccece

## Instalar GKE
#### Crear Bucket
* Crear un bucket en Storage con el nombre que deseas, el nombre debe ser unico.

#### Editar gke/backend.tf
* Abrir el archivo gke/backend.tf
* Editar la opcion bucket, por el nombre de bucket que creaste en el paso anterior.
* En la opcion credentials anadir la direccion del archivo de credenciales que te descargaste al
crear el service account.

#### Editar gke/main.tf
* Abrir el archivo gke/main.tf
* Editar la opcion credentials con lo mismo que colocaste en el archivo backend.tf
* Editar el nombre del proyecto, por el que hayas creado en los pasos anteriores.

#### Instalar Gcloud para obtener las credenciales
* En linux lo puedes instalar con
```shell script
apt-get install gcloud
```
* Autenticarse con el correo que creo la cuenta de Google Cloud Plataform
```shell script
gcloud auth login
```
* Una vez instalado colocarse dentro de la carpeta gke y ejecutar los siguientes comandos:
```shell script
sudo terraform init
```
```shell script
sudo terraform apply
```
* Despues del ultimo comando aceptar el apply colocando yes, y dejamos que magia de terraform haga su trabajo
* Luego de Instalar ejecutar el siguiente comando para traer las credenciales del Kubernertes creado
```shell script
gcloud container clusters get-credentials default-cloudgoec-course-gke --zone us-east4-a --project cloudgoec
```

#### Instalar Kubectl para acceder al cluster
* Para instalar el kubectl ejecutar los siguientes comandos
```shell script
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

#### Ver los nodos del cluster
```shell script
kubectl get nodes
```

#### Para eliminar todo lo creado con terraform ejecuta el siguiente comando
```shell script
sudo terraform destroy
```
