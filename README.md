# Bienvenido al Laboratorio de Contenedores

Este laboratorio muestra como crear un cluster de Kubernetes con AKS (Azure Kubernetes Service) y correr una aplicación basada en Docker en dicho cluster. 
 

## Resumen 

Este ejemplo muestra como:

1. Crear una aplicación ASP.NET Core
2. Crear una imagen de Docker que incluya la aplicación
3. Publicación de la imagen a un Docker Registry privado (Azure Container Registry)
4. Crear un cluster de Kubernetes (K8S) administrador por Azure (Azure Kubernetes Services)
5. Distribuir de la imagen en el cluster de Kubernetes

## Instalación y configuración

* Instalar .NET Core: https://www.microsoft.com/net/download/all
* Instalar Docker: https://www.docker.com/get-docker
* (Opcional) Instalar Azure Command Line Interface (CLI): https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
* (Opcional) GIT: https://git-scm.com/
* (Opcional) Visual Studio Code: https://code.visualstudio.com/


Para verificar que ya se instalaron los componentes anteriores, abrir una ventana de Powershell y usar los siguientes comandos:

.NET Core:
```
dotnet --version
```

Docker Community Edition
```
docker version
```

Azure Command Line Interface
```
az
```
 
GIT
```
git version
```

Visual Studio Code
``` 
code .
```


## Ejercicio 1 - Creación de una aplicación ASP.NET Core



Para crear una aplicación ASP.NET Model-View-Controller, primero se crea un directorio. El nombre de dicho directorio determina el nombre del proyecto y por lo tanto el nombre del archivo binario que se debe ejecutar en el contenedor. 

```
mkdir HolaMundo
cd HolaMundo
dotnet new mvc --no-https
```



Ejercutar localmente la aplicación

```
dotnet run
```

Para verificar que la aplicación esta corriendo localmente es necesario abrir el navegador e ir a la dirección: http://localhost:5000

## Ejercicio 2 - Creación de imagen Docker con la aplicación

Para empaquetar la aplicacion en una imagen de Docker es necesario crear el archivo Dockerfile en el directorio de la aplicación con las siguientes instrucciones de Docker:

```
FROM microsoft/aspnetcore-build:2.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/aspnetcore:2.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "HelloWorld.dll"]
```

El archivo Dockerfile le indica a Docker como debe construir la imagen, para construir la imagen es necesario el siguiente comando:

```
docker build -t helloworld:v1 . 
```

Para verificar que la imagen se generó adecuadamente 

```
docker images
```

Debe aparecer una imagen con el nombre **helloworld**.

Se puede ejecutar un contenedor con la aplicación usando:

```
docker run -p 4000:80 helloworld:v1
```

Para verificar que la aplicación esta corriendo localmente es necesario abrir el navegador e ir a la dirección: http://localhost:4000



## Ejercicio 3 - Publicación de imagen a un registry privado

Para crear un repositorio de imágenes Docker se utilizarán comandos de la interface de línea de comandos (CLI) de Azure.

Primero es necesario tener acceso a la suscripción de Azure

```
az login
```

Los recursos que se utilizarán durante este ejercicio se generarán dentro de un grupo de recursos de Azure para facilitar su eliminación al final del taller.

```
az group create -n Ejemplo-Contenedores -l eastus
```

El servicio Azure Container Registry es un repositorio privado de imágenes Docker, para crearlo se puede usar el siguiente comando:

```
ACR_NAME=<nombre del repositorio, sin comillas ni llaves>
az acr create -n $ACR_NAME -g Ejemplo-Contenedores --sku Basic --admin-enabled true
```

Una vez que el registry se ha creado Docker puede usarlo para almacenar imágenes, para ello es necesario etiquetar la imagen con el nombre del servidor del registry:

```
ACR_NAME=<nombre del repositorio, sin comillas ni llaves>
docker tag $ACR.azurecr.io/helloworld:v1 helloworld:v1 
```

Dado que el repositorio creado (ACR) es privado, antes de poder publicar una imagen es necesario que Docker se autentique con el ACR

```
ACR_NAME=<nombre del repositorio, sin comillas ni llaves>
az acr login -n $ACR_NAME -g Ejemplo-Contenedores
``` 

La publicación de la imagen se hace con el siguiente comando de Docker:

```
ACR_NAME=<nombre del repositorio, sin comillas ni llaves>
docker push $ACR_NAME.azurecr.io/helloworld:v1 
```


## Ejercicio 4 - Creación de cluster Kubernetes

Para crear un cluster de Kubernetes usando el servicio Azure AKS se utiliza el siguiente comando de Azure CLI:

```
az aks create -n ClusterK8s -g Sample-AKS --generate-ssh-keys
```

Una vez creado el cluster, es necesario obtener las credenciales de acceso al mismo antes de poder administrarlo

```
az aks get-credentials -n ClusterK8s -g Sample-AKS
```

El comando anterior obtiene las credenciales del cluster y las almacena en archivos de configuración que estan en el directorio ~/.kube con lo que ahora se puede administrar el cluster con el cliente de administración de kubernetes

El cliente de Kubernetes (kubectrl) puede instalarse localmente con el siguiente comando:

```
az aks install-cli 
```

A continuación algunos de los comandos más comunes para administrar el cluster de Kubernetes

```
kubectl get nodes
```

```
kubectl get pods
```

```
kubectl get services
```


## Ejercicio 5 - Distribución de la imagen en el cluster Kubernetes

```
ACR_SERVER=<nombre del ACR>.azurecr.io
ACR_USER=<nombre del ACR>
ACR_PWD=<clave del ACR>

kubectl create secret docker-registry acr-secret --docker-server=$ACR_SERVER --docker-username=$ACR_USER --docker-password=$ACR_PWD --docker-email=superman@heroes.com

```



```
kubectl apply -f hello.yml 

```

## Referencias

Cloud Design Patterns: https://docs.microsoft.com/en-us/azure/architecture/patterns/



