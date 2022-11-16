#!/bin/bash

echo "Criando as imagens......."
docker build -t filisteus/projeto-backend:1.0 backend/.
docker build -t filisteus/projeto-backend:1.0 database/.

echo "Realizando o push das imagens..."
docker push filisteus/projeto-backend:1.0
docker push filisteus/projeto-database:1.0

echo "criando os serviços do kubernets"
kubectl apply -f ./services.yml

echo "criando os deployments..."
kubectl apply -f ./deployment.yml

exit 0


exit 0


