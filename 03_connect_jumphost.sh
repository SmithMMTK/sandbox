export SSH_PRIVATE_KEY="$(terraform output -raw SSH_PRIVATE_KEY)"
export SSH_PUBLIC_IP="$(terraform output -raw PUBLIC_IP_ADDRESS_JUMPHOST)"
echo "$SSH_PRIVATE_KEY" > /tmp/private_key.pem
chmod 600 /tmp/private_key.pem
ssh -i /tmp/private_key.pem azureuser@"$SSH_PUBLIC_IP"

rm -f /tmp/private_key.pem