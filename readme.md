

### Combination of based / modules
| File                    | Base | Single VM | Sentinel | AzFw with UDR | App and Postgres | AKS |
|-------------------------|------|-----------|----------|---------------|------------------|-----|
| main.tf                | x    | x         | x        | x             | x                | x   |
| az_monitor.tf          | x    | x         | x        | x             | x                | x   |
| az_sentinel.tf         |      |           | x        |               |                  |     |
| az_ssh_key.tf          | x    | x         |          | x             |                  | x   |
| az_vnet.tf             | x    | x         |          | x             |                  | x   |
| az_linux_vm.tf         | x    | x         |          |               | x                | x   |
| az_linux_jumphost.tf   |      |           |          |               |                  |     |
| az_routetable.tf       |      |           |          | x             |                  |     |
| az_firewall.tf         |      |           |          | x             |                  |     |
| az_postgres_flex.tf    |      |           |          |               | x                |     |
| az_aks.tf              |      |           |          |               |                  | x   |


- 00_deploy.sh : Initialize terraform, Plan and Apply
- 01_increamental_deploy.sh : Increamental Update and Deploy
- 02_connect_workload.sh : Get SSH Key and Connect to Workload VM
- 03_connect_jumphost.sh : Get SSH Key and Connect to Jumphost VM
- 04_connect_proxy.sh : Get SSH Key and Connect to Proxy VM
- 05_connect_aks.sh : Connect to AKS
- 99_clearAll.sh : Delete all resources and .tfstage file

```bash
### Get Private Key from terraform output
terraform output -raw SSH_PRIVATE_KEY
```
