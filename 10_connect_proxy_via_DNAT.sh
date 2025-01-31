export SSH_PRIVATE_KEY="$(terraform output -raw SSH_PRIVATE_KEY)"
export FW_PUBLIC_IP="$(terraform output -raw AZUREFIREWALLPUBLICIP)"

printf "%s" "$SSH_PRIVATE_KEY" | pbcopy

# Save the private key to a file ./Downloads/private_key.pem
# printf "%s" "$SSH_PRIVATE_KEY" > ~/Downloads/private_key.pem
# chmod 600 ~/Downloads/privatekey.pem
# echo "Private key saved to ~/Downloads/private_key.pem"
#echo "Private key copied to clipboard"
# echo "You can now connect to the Azure VM using the private key"

# Save the private key to a file ./Downloads/private_key.pem
printf "%s" "$SSH_PRIVATE_KEY" > private_key.tfstate
chmod 600 private_key.tfstate
echo "Private key saved to private_key.tfstate"
echo "Private key copied to clipboard"
echo "You can now connect to the Azure VM using the private key"



# export SSH_PRIVATE_KEY="$(terraform output -raw SSH_PRIVATE_KEY)"
#export SSH_PUBLIC_IP="$(terraform output -raw PUBLIC_IP_ADDRESS_PROXY)"
#echo "$SSH_PRIVATE_KEY" > /tmp/private_key.pem
#chmod 600 /tmp/private_key.pem
ssh -i  private_key.tfstate azureuser@"$FW_PUBLIC_IP"

rm private_key.tfstate