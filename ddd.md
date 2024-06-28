# Deploying Application with AWS App Runner

In this tutorial, you will build and deploy a voting application built with Python 3 using AWS App Runner. The main objective of this tutorial is to help you understand steps that you need to do to deploy application and integrating with AWS services using AWS App Runner.

aws dynamodb list-tables --endpoint-url http://localhost:8000 --region us-east-1 --access-key-id "fakeMyKeyId" --secret-access-key "fakeSecretAccessKey"

aws dynamodb create-table --endpoint-url http://localhost:8000 \
    --table-name apprunner-demo-data \
    --attribute-definitions AttributeName=ID,AttributeType=S \
    --key-schema AttributeName=ID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST

aws dynamodb delete-table --endpoint-url http://localhost:8000 --table-name apprunner-demo-data2


aws dynamodb put-item --endpoint-url http://localhost:8000 \
    --table-name apprunner-demo-data2 \
    --item '{
        "Items": {"S": "Item4"},
        "Attribute1": {"S": "roxs4"}
    }'

aws dynamodb put-item --endpoint-url http://localhost:8000 \
    --table-name apprunner-demo-data \
    --item '{
        "ID": {"S": "1"},
        "image": {"S": "/static/ecs.jpg"},
        "image_copyright": {"S": "Photo by <a href=\"https://aws.amazon.com/es/ecs/\">AWS</a> on <a href=\"https://aws.amazon.com/es/ecs/getting-started/?pg=ln&cp=bn\">getting-started</a>"},
        "name": {"S": "AWS ECS"},
        "votes": {"N": "0"}
    }'


aws dynamodb put-item --endpoint-url http://localhost:8000 \
    --table-name apprunner-demo-data \
    --item '{
        "ID": {"S": "2"},
        "image": {"S": "/static/eks.jpg"},
        "image_copyright": {"S": "Photo by <a href=\"https://aws.amazon.com/es/eks/\">AWS</a> on <a href=\"https://aws.amazon.com/es/eks/features/\">getting-started</a>"},
        "name": {"S": "AWS EKS"},
        "votes": {"N": "0"}
    }'

