export sqlvm_user="$(terraform output -raw admin_username)"
export sqlvm_ip="$(terraform output -raw SQLVM_PUBLIC_IP)"
export sqlvm_password="$(terraform output -raw admin_password)"

# Generate RDP file for SQLVM with password
cat <<EOF > /tmp/sqlvm.rdp
full address:s:$sqlvm_ip
username:s:$sqlvm_user
EOF

printf "%s" "$sqlvm_password" | pbcopy

# Open SQLVM in Remote Desktop
open /tmp/sqlvm.rdp


# Remove RDP file
rm -f /tmp/sqlvm.rdp