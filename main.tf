locals {
  enviroments = ["Prod", "Staging", "Test", "Dev"]
}

// resource "vault_mount" "application-per-enviroments" {
//   count = length(local.enviroments)
//   path  = "${var.appname}/${local.enviroments[count.index]}"
//   type  = "generic"
// }

resource "vault_mount" "application-root" {
  path  = var.appname
  type  = "generic"
}


resource "vault_generic_secret" "application-per-env" {
  count = length(local.enviroments)
  path = "${vault_mount.application-root.path}/${local.enviroments[count.index]}"

    data_json = <<EOT
{
  "Description": "Generic KV2 secrets for application $var.appname at enviroment ${local.enviroments[count.index]}"
}
EOT

}



resource "vault_policy" "admin" {
  count = length(local.enviroments)
  name  = "${var.appname}-${local.enviroments[count.index]}-admin"

  policy = <<EOT
path "${var.appname}/${local.enviroments[count.index]}/*" {
  capabilities = ["create", "update", "delete", "list"]
}
EOT
}

resource "vault_policy" "consumer" {
  count = length(local.enviroments)
  name  = "${var.appname}-${local.enviroments[count.index]}-consumer"

  policy = <<EOT
path "${var.appname}/${local.enviroments[count.index]}/*" {
  capabilities = ["read"]
}
EOT
}

resource "vault_policy" "superadmin" {
  name = "${var.appname}-superadmin"

  policy = <<EOT
path "${var.appname}/*" {
  capabilities = ["read","create", "update", "delete", "list"]
}
EOT
}