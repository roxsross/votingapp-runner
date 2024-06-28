#!/bin/bash

# Variables
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="459137896070"
ECR_REPO_NAME="votingapp"
TAG="latest"

# Verificar si el repositorio ECR ya existe
echo "Verificando si el repositorio ECR '$ECR_REPO_NAME' ya existe..."
if aws ecr describe-repositories --repository-names $ECR_REPO_NAME --region $AWS_REGION > /dev/null 2>&1; then
    echo "El repositorio ECR '$ECR_REPO_NAME' ya existe. Continuando..."
else
    echo "El repositorio ECR '$ECR_REPO_NAME' no existe. Creándolo..."
    aws ecr create-repository --repository-name $ECR_REPO_NAME --region $AWS_REGION
    echo "Repositorio ECR '$ECR_REPO_NAME' creado exitosamente."
fi

# Construir la imagen Docker
docker build -t $ECR_REPO_NAME:$TAG .

# Iniciar sesión en ECR y subir la imagen
echo "Iniciando sesión en ECR y subiendo la imagen Docker..."
if aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com; then
    docker tag $ECR_REPO_NAME:$TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$TAG
    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$TAG
    echo "¡Imagen Docker subida exitosamente a ECR!"
else
    echo "Error: no se pudo iniciar sesión en ECR. Verifica las credenciales y permisos."
fi

# Limpieza: eliminar imágenes locales
docker rmi $ECR_REPO_NAME:$TAG
docker rmi $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME:$TAG

echo "Proceso completado."
