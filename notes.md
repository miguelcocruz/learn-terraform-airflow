- Aprovisionar container registry
    - Escrever como output a forma de aceder ao registry
- Push image to container registry
    - Escrever forma de referenciar as imagens num ficheiro
- Aprovisionar infraestrutura
    - Usar -var-file=ficheiro com referencia às imagens


docker tag mgl-airflow:latest 204420314953.dkr.ecr.us-east-2.amazonaws.com/repo


docker push 204420314953.dkr.ecr.us-east-2.amazonaws.com/repo

