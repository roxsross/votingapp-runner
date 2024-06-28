#!/bin/bash

# Variables
DYNAMODB_JSON_FILE="dynamodb/dynamodb.json"
DYNAMODB_COMMAND="aws dynamodb batch-write-item --request-items file://$DYNAMODB_JSON_FILE"

# Verificar si el archivo JSON de DynamoDB existe
if [[ ! -f $DYNAMODB_JSON_FILE ]]; then
    echo "Error: $DYNAMODB_JSON_FILE no encontrado." >&2
    exit 1
fi

# Ejecutar el comando de DynamoDB en segundo plano
echo "Ejecutando DynamoDB batch write en segundo plano..."
$DYNAMODB_COMMAND &
DYNAMODB_PID=$!

# Mensaje de éxito
echo "Ejecución del script completada exitosamente."

# Opcional: Esperar la finalización del proceso en segundo plano
# wait $DYNAMODB_PID

# Salida exitosa
exit 0
