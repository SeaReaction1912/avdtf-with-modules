resource "azuread_user" "rr-svc-account" {
  user_principal_name = var.rr_svc_acct_username
  display_name        = "Red River Service Account"
  password            = var.rr_svc_acct_pw
}