
export sqlvm_password="$(terraform output -raw admin_password)"
printf "%s" "$sqlvm_password" | pbcopy

