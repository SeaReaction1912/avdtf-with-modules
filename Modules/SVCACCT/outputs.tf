output "rr_svc_acct_username" {
  value = azuread_user.rr-svc-account.user_principal_name
  description = "Red River AVD Service Account UserName"
}

output "rr_svc_acct_pw" {
  value = azuread_user.rr-svc-account.password
  description = "Red River AVD Service Account Password"
}

output "object_id" {
  value = azuread_user.rr-svc-account.object_id
  description = "Red River AVD Service Account Object ID"
}