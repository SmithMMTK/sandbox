export TARGET_RG_NAME=$(terraform output -raw RESOURCE_GROUP_NAME)
az group delete -n $TARGET_RG_NAME --yes --no-wait
az group list -o table 

# Wait for press any key
read -p "Press any key to continue... " -n1 -s

rm -rf rm *.tfplan
rm -rf rm *.tfstate


# End of script