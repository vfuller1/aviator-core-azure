resource "azurerm_federated_identity_credential" "aviator_federated_credential" {
  name                = "fic-aviator-core-trust"
  resource_group_name = "rg-aviator-core-prod"
  audience            = ["api://AzureADTokenExchange"]
  
  # This matches the output you just retrieved
  issuer              = "https://eastus2.oic.prod-aks.azure.com/3246f21f-4c75-481d-8284-80c8ce2b36d1/8c35f38b-7102-4418-aaef-1095d44166cb/"
  
  # Link to your id-aviator-core-prod Managed Identity
  parent_id           = "/subscriptions/04115ecf-1b57-4dc2-823c-99c085023938/resourceGroups/rg-aviator-core-prod/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-aviator-core-prod"
  
  # This must match your ServiceAccount in the deployment.yaml
  subject             = "system:serviceaccount:default:aviator-service-account"
}