#!/bin/bash

#Var
NAME_APP=awsomeweb
ENV=develop

#copilot app init crea una nueva aplicación dentro del directorio que contendrá su(s) servicio(s).
copilot app init $NAME_APP

#copilot env init crea un nuevo entorno donde vivirán sus servicios.
copilot env init $NAME_APP --name $ENV

#copilot env deploy toma las configuraciones en el manifiesto de su entorno e implementa la infraestructura de su entorno.
copilot env deploy --app $NAME_APP --name $ENV

#copilot svc init crea un nuevo servicio para ejecutar su código por usted.
copilot svc init -n $NAME_APP-service -t "Load Balanced Web Service" -d Dockerfile --port 80

#copilot svc deploy toma su código y configuración locales y los implementa.
copilot svc deploy --app $NAME_APP --name $NAME_APP-service --env $ENV