module aadds {
  source = "../AADDS"
}

resource "azuread_user" "rr-svc-account" {
  user_principal_name = var.rr_svc_acct_username
  display_name        = "Red River Service Account"
  password            = var.rr_svc_acct_pw
}

resource "azuread_group_member" "admins" {
  group_object_id  = module.aadds.group_ob_id
  member_object_id = azuread_user.rr-svc-account.object_id
}