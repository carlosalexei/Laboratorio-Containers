# HelloWorld
Basic ASP.NET Core application 

## Resumen 

Este ejemplo muestra como:

1. Crear una aplicación ASP.NET Core
2. Crear una imagen de Docker que incluya la aplicación y como guardarla en un Docker Registry privado (Azure Container Registry)
3. Crear un cluster de Kubernetes (K8S) administrador por Azure (Azure Kubernetes Services) y distribuir la aplicacion en dicho cluster

## ** Ejercicio 1 ** - Creación de una aplicación ASP.NET Core



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

