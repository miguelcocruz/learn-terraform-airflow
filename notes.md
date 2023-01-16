- Aprovisionar container registry
    - Escrever como output a forma de aceder ao registry
- Push image to container registry
    - Escrever forma de referenciar as imagens num ficheiro
- Aprovisionar infraestrutura
    - Usar -var-file=ficheiro com referencia às imagens




Aprendizagens:
- Image ID é diferente de region para region. Se usar um Image ID de us-east-1 não vai funcionar em us-east-2
- Heredoc string. Começa com << (ou <<- para indented blocks). Posso colocar o identifier que quiser, desde que não apareça no texto em si. Tem de aparecer no final para marcar o fim. Convencionalmente, começa com EO (end of). EOT, EOF.
- O comando seguinte:
    ssh -i "tf-key-pair.pem" ubuntu@$$(terraform output -raw ec2_dns_public_name)
    Se usar dentro do Makefile tem de ser ubuntu@$$(...)
    Se usar na shell tem de ser ubuntu@$(..)
- Se o security group tiver apenas ingress rules que permitam o meu IP não é possível instalar o docker nem outros packages
- Para ver os logs da ec2 instance (para analisar porque é que user data deu erro) pode-se consultar o ficheiro /var/log/cloud-init-output.log
 - Estava a dar erro porque não tinha posto o shebang a informar que é para executar como bash script.
- Apt-get pergunta se confirmamos o download/instalação. Adicionar flag -y para confirmar automaticamente no user data.

Questões:
- Se der erro a criar um resource, elimina os resources que criou? Reverte todas as alterações que fez?


Ideias:
- Testar várias formas de deployment do airflow:
    - Tudo no EC2 e docker (como start data engineering)
    - EC2 para webserver, EC2 para scheduler e correr jobs na mesma instance do scheduler
    - EC2 para webserver, EC2 para scheduler e fargate (docker operator?)
    - Managed Airflow?
    - Astronomer?
- Construir ETL básico e aplicar deployments anteriores. Ir refazendo o mesmo ETL mas com outras ferramentas (AWS Glue, AWS Step functions?)