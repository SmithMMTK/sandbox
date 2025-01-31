export psql_admin_password="$(terraform output -raw psql_admin_password)"
printf "%s" "$psql_admin_password" | pbcopy