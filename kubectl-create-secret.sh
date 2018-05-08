ACR_SERVER=miregistry.azurecr.io
ACR_USER=miregistry
ACR_PWD=rAjhqfrZtY6TtjgReu4XyI=R0/1dprfq

kubectl create secret docker-registry acr-secret --docker-server=$ACR_SERVER --docker-username=$ACR_USER --docker-password=$ACR_PWD --docker-email=superman@heroes.com
