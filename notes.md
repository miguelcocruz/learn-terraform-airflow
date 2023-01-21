Próximos passos:
- Criar S3 bucket usando terraform, conceder permissões
- Criar ETL que copie ficheiro para S3
- Testar vários deployments
    - Webserver e scheduler no mesmo EC2
    - Webserver num EC2 e scheduler noutro EC2
    - Ver livro de DPwAA
    - Ver blog post AWS DataOps
- Criar ETL mais complexo



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
- Em security groups: ingress é quando existe inbound traffic. Se eu (do meu computador) faço um request à instance (que está no security group), esse request conta como inbound. A response a esse request não está limitada pelas regras de outbound.
- Para conceder que uma EC2 instance tenha permissão a uma S3 storage (por exemplo) encontrei 2 alternativas:
    A) Vista no livro Terraform Up and Running:
        1. Criar IAM Policy "assume role policy" que indica quem ou o quê pode assumir o IAM Role -> criar data "aws_iam_policy_document"
        2. Criar IAM Role e atribuir a "assume role policy" -> criar resource "aws_iam_role"
        3. Criar IAM Policy (consistem com as permissões que pretendemos dar) -> criar data "aws_iam_policy_document"
        4. Atribuir IAM Policy ao IAM Role -> criar resource "aws_iam_role_policy"
        5. Criar instância do IAM Role -> criar resource "aws_iam_role_instance"
        6. Atribuir instância do IAM Role ao resource que pretendemos
    B) Visto no startdataengineering:
        1. Criar IAM Role com os seguintes atributos:
            assume_role_policy = jsonencode(escrever aqui a "assume role policy")
            managed_policy_arns = [em vez de definirmos nós uma IAM Policy, usamos uma managed da AWS]
        2. Criar instância do IAM Role
        3. Atribuir instância do IAM Role ao resource que pretendemos

    IAM Policies são escritas em json. Criar data "aws_iam_policy_document" ou usar json_encode diretamente é igual

    Portanto, atribuir permissões pode ser visto como:
        - Criar IAM Role
            - Explicitar quem pode assumir esse IAM Role
            - Explicitir permissões desse role
        - Criar instância do IAM Role
        - Atribuir instância do IAM Role ao resource que pretendemos




Questões:
- Se der erro a criar um resource, elimina os resources que criou? Reverte todas as alterações que fez?
- O pipeline funciona depois de ter feito o deployment. Como testar?


Ideias:
- Testar várias formas de deployment do airflow:
    - Tudo no EC2 e docker (como start data engineering)
    - EC2 para webserver, EC2 para scheduler e correr jobs na mesma instance do scheduler
    - EC2 para webserver, EC2 para scheduler e fargate (docker operator?)
    - Managed Airflow?
    - Astronomer?
- Construir ETL básico e aplicar deployments anteriores. Ir refazendo o mesmo ETL mas com outras ferramentas (AWS Glue, AWS Step functions?)