# HelloWorld
Basic ASP.NET Core application 

## Resumen 

Este ejemplo muestra como:

1. Crear una aplicación ASP.NET Core
2. Crear una imagen de Docker que incluya la aplicación
3. Publicación de la imagen a un Docker Registry privado (Azure Container Registry)
4. Crear un cluster de Kubernetes (K8S) administrador por Azure (Azure Kubernetes Services)
5. Distribuir de la imagen en el cluster de Kubernetes

## Ejercicio 1 - Creación de una aplicación ASP.NET Core



Para crear una aplicación ASP.NET 
```
mkdir HelloWorld
cd HelloWorld
dotnet new mvc
```

Ejercutar localmente la aplicación

```
dotnet run
```

Para verificar que la aplicación esta corriendo localmente es necesario abrir el navegador e ir a la dirección: http://localhost:5000

## Ejercicio 2 - Creación de imagen Docker con la aplicacion y publicación a un Registry privado

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

Debe aparecer una imagen con el nombre helloworld.


## Ejercicio 3 - Publicación de imagen a un registry privado



## Ejercicio 4 - Creación de cluster Kubernetes

## Ejercicio 5 - Distribución de la imagen en el cluster Kubernetes

