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
  name  = "${var.appname}-${var.enviroments[count.index]}-secretadmin"

  policy = <<EOT
path "${var.appname}/*" {
  capabilities = ["read","create", "update", "delete", "list"]
}
EOT
}