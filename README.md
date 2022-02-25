# terraform

# 1. az login
# 2. terraform init
# 3. terraform workspace add dev
# 4. terraform workspace add prev
# 5. terraform workspace add prod
# 6. terraform workspace select dev
# 7. terraform apply -var-file dev.tfvars
# 8. terraform workspace select prev
# 9. terraform apply -var-file prev.tfvars
# 10. terraform workspace select prod
# 11. terraform apply -var-file prod.tfvars