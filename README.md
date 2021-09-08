# terraform-vault-kv-for-application
Terraform module that creates kv2 secrets engine for application per enviroment, along with secrets provider/consumer/admin policies.


## Usage
```terraform
module "vault_app_module_APP000001" {
    source  = "ausmartway/terraform-vault-kv-for-application"
    version = "0.4.0"
    appname = "APP000001"
    enviroments=["production","dev","test","sit","svt"]
}
```
