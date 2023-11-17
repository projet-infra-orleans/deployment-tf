# Instruction

D'abord il faut se logger sur Azure :

```
az login
```

Ensuite il faut se connecter au state distant :

```
terraform init -backend-config="resource_group_name=groupe-1-infra-deploy" -backend-config="storage_account_name=gr1infradeploystock" -backend-config="container_name=tfstate" -backend-config="key=terraform.tfstate"
```

# Erreurs connues

Erreur :
A resource with the ID "/subscriptions/be9d3df9-b269-4941-b807-cd295ad6480e/resourceGroups/groupe-1-infra-deploy" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_resource_group" for more information.

Solution :
terraform import azurerm_resource_group.rg /subscriptions/be9d3df9-b269-4941-b807-cd295ad6480e/resourceGroups/groupe-1-infra-deploy

---

Pour récupérer l'IP après avoir déployer terraform apply :

```
kubectl get services -n ingress-basic
```
