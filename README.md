
## AVD TF with Modules
#### Make changes to module variables as necessary.  

##### *Note*: In the root main.tf you'll find variable declarations in module blocks.  These link to the same variables declared in each module’s ```variables.tf```.  Specify them in the root to change what the defaults are set to.  *

“Terraform apply" is looking at the root ```main.tf```, then reading each of the child modules' configurations to decide which resources to build.  

Anywhere you find a declaration like ```module.rg.rg_name```, for example, it links to the ```outputs.tf``` file stored with the module.  

In this example, in ./Modules/RG/outputs.tf, there's an object named ```"rg_name"```.  

The value of this object is coming right from the ```main.tf``` of ./modules/rg where I specify the configuration for the resource.

Comment out the modules you aren’t going to need/use.  Do not delete in case we will use them in the future.

Customer information is required to use blocks: *AADDS*, *Peerings*, and *VPN*, and items needed map to variables that start with ```“client…”```

## Deployment Considerations
#### These are all commented in the root ```main.tf```, as well.

```backend``` Block: 
---
- Remember to update this per your environment, however you end up wanting to managing state.  Here, it's stored in BlobStorage in the subscription where the Terraform SP has permissions.

```random_string``` Block:
---
- For VM Boot Diagnostics storage.

```pw``` Block:
---
- Service Account Password, can be used in other modules though, like ```vpn``` for a Pre-shared Key.

Module ```svcacct```:
---
- Deploys to Azure AD, initial password will have to be changed in order to login to Desktops bound to AADDS domain, but they should have Domain Admin privileges in AADDS domain to run RSAT on the VM.

Module ```rg```:
---
- ```count=2```Deploys a second Resource Group that also has VNETs.

Module ```nsg```:
---
- Deployed $NSG0 is associated to all $VNET0 subnets and VM0 NIC(s). And $NSG1 is associated to all $VNET1 subnets and VM1 NIC(s).

- NSG Inbound rules allow **5986** for psremoting for Azure Devops(not ours) to configure the serverless DCs. Does not deploy without it.

- NSG Inbound rules allow **3389** from personal IP Address: 24.119.52.203 and needs updated per needs.

- NSG Outbound rules allow **80** and **443**.  Inter-network(VNET to VNET) connectivity works regardless.

Module ```vnet```:
---
- Deploys $VNETS per the terraform.tfvars file with the below specified DNS Servers.  Core to pretty much everything.

Module ```aadds```:
---
- Regardless if you deploy AADDS via Terraform or Nerdio, it takes 60-75 minutes to deploy.

- Deployed domain is bound to $VNET0.

- Change 'aadds_sku' to 'Standard', 'Enterprise', or 'Premium'.

- All users from Azure Tenant will have to change their password to access AADDS domain bound desktops.

Module ```vm```:
---
- VM0 is bound to $VNET0 (avd_net0).

- VM1 is bound to $VNET1 (avd_net0)

Module ```natgw```:
---
- Binds only to $VNET0 (avd_net0).

Module ```peerings```:
---
- Peers $VNET0(avd_net0) and $VNET0(avd_net1)

Module ```storageacct```:
---
- Deploys both Storage Accounts to same Resource Group.

Module ```vpn```:
---
- GatewaySubnet is required to deploy a VPN and is configured in the main.tf.

- VPN Client Address Space is required to be in a different address space than GatewaySubnet.

- Default config will not work, update 'client_local_gw_pip' and 'client_internal_subnet'.

- Gateway Transit is configured on the tunnel(allow_gateway_transit=true).

Module ```alerts```:
---
- Uncomment after Nerdio is built up and Log Analytics Workspace has been deployed from console.

#end
