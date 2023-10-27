# Terraform criando IaaS no AWS e fazendo deploy de Java 11 e MySQL 5.7

Pré-requisitos

- aws instalado e configurado
- Terraform instalado

Logar na AWS usando aws cli com o comando abaixo

```sh
aws configure sso
```

Gerar chave pública e privada para acessar a VM, com nome "id_rsa" na raiz do projeto

```sh
ssh-keygen -t rsa -b 4096
```

Inicializar o Terraform

```sh
terraform init
```

Executar o Terraform

```sh
terraform apply -auto-approve
```
