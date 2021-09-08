//create mount point for the application per enviroment.
resource "vault_mount" "application-root-per-env" {
  count = length(var.enviroments)
  path  = "${var.appname}/${var.enviroments[count.index]}"
  type  = "kv-v2"
}

//create a policy that allows create/update/delete/list of secret for the application per enviroment. identity with this policy can create/delete/update the secrets but can't read.
resource "vault_policy" "secretprovider" {
  count = length(var.enviroments)
  name  = "${var.appname}-${var.enviroments[count.index]}-secret-provider"

  policy = <<EOT
path "${var.appname}/${var.enviroments[count.index]}/*" {
  capabilities = ["create", "update", "delete", "list"]
}
EOT
}

//create a policy that allows read of secret for the application per enviroment. identities with this policy can read the secrets but can't write.
resource "vault_policy" "secretconsumer" {
  count = length(var.enviroments)
  name  = "${var.appname}-${var.enviroments[count.index]}-secret-consumer"

  policy = <<EOT
path "${var.appname}/${var.enviroments[count.index]}/*" {
  capabilities = ["read","list"]
}


EOT
}

//create a policy that allows both read/write permission for the application per enviroment. 
resource "vault_policy" "secretadmin" {
  count = length(var.enviroments)
  name  = "${var.appname}-${var.enviroments[count.index]}-secret-admin"

  policy = <<EOT
path "${var.appname}/*" {
  capabilities = ["read","create", "update", "delete", "list"]
}
EOT
}

//Approle is intended when there is no better/native authentication method, eg, aws/gcp/azure/k8s/ldap.
//create approle role that uses secret-provider policy
resource "vault_approle_auth_backend_role" "secret-provider-approle" {
  count = var.enable_approle ? length(var.enviroments) : 0
  backend        = var.approle_path
  role_name      = "${var.appname}-${var.enviroments[count.index]}-secret-provider"
  token_policies = ["${var.appname}-${var.enviroments[count.index]}-secret-provider"]
}

//create approle role that uses secret-consumer policy
resource "vault_approle_auth_backend_role" "secret-consumer-approle" {
  count = var.enable_approle ? length(var.enviroments) : 0
  backend        = var.approle_path
  role_name      = "${var.appname}-${var.enviroments[count.index]}-secret-consumer"
  token_policies = ["${var.appname}-${var.enviroments[count.index]}-secret-consumer"]
}

//create approle role that uses secret-admin policy
resource "vault_approle_auth_backend_role" "secret-admin-approle" {
  count = var.enable_approle ? length(var.enviroments) : 0
  backend        = var.approle_path
  role_name      = "${var.appname}-${var.enviroments[count.index]}-secret-admin"
  token_policies = ["${var.appname}-${var.enviroments[count.index]}-secret-admin"]
}