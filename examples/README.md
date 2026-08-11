# Azure Key Vault with Terraform/OpenTofu - Training Examples

This directory contains progressive examples used with the **terraform-az-fk-key-vault** module.
The examples are designed as **incremental building blocks**, starting from a basic Key Vault and growing toward private network-first secret, key, and certificate management patterns.

These examples are part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and are used to show how Azure Key Vault fits into broader infrastructure designs.

---

## 🧭 Example Overview

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| 01 | **Basic Key Vault** | resource group, Key Vault, Azure RBAC authorization |
| 02 | **Key Vault With Network ACLs** | public endpoint ACLs, Azure trusted services bypass, deny-by-default access |
| 03 | **Private Key Vault With Private Endpoint** | VNet, Private DNS, Private Endpoint, disabled public access |

Examples will be added progressively to cover scenarios such as:

- private workload integration with Azure Container Instances, AKS, Container Apps, and VMs
- Key Vault RBAC composition with managed identities
- private endpoint validation from workload networks

Each example should stay focused on **one architectural goal** and remain runnable on its own.

---

## ⚙️ How to Use

Each example directory should contain:

- Terraform/OpenTofu configuration (`.tf`)
- A focused `README.md` explaining the goal of the example
- A `terraform.tfvars.example` file with minimal runnable defaults

Typical workflow:

```bash
cd examples/<example-directory>
cp terraform.tfvars.example terraform.tfvars
tofu init
tofu plan
tofu apply
```

The recommended learning path is sequential:

```text
01 -> 02 -> 03
```

---

## 🧩 Design Principles

- One example = one architectural concept
- Key Vault authorization is Azure RBAC by default
- Access policy mode is available but intentionally explicit
- Private Endpoint, Private DNS, Managed Identity, and RBAC stay in their dedicated FoggyKitchen modules
- Fully private Key Vault access uses `terraform-az-fk-private-endpoint` and `terraform-az-fk-private-dns`
- Examples avoid hardcoded secrets, credentials, and tenant-specific object IDs
- OpenTofu is the primary runtime used in the examples

---

## 🧩 Related Resources

- [FoggyKitchen Azure Key Vault Module](../)
- [FoggyKitchen Azure VNet Module](https://github.com/foggykitchen/terraform-az-fk-vnet)
- [FoggyKitchen Azure Private DNS Module](https://github.com/foggykitchen/terraform-az-fk-private-dns)
- [FoggyKitchen Azure Private Endpoint Module](https://github.com/foggykitchen/terraform-az-fk-private-endpoint)
- [FoggyKitchen Azure Managed Identity Module](https://github.com/foggykitchen/terraform-az-fk-managed-identity)
- [FoggyKitchen Azure RBAC Module](https://github.com/foggykitchen/terraform-az-fk-rbac)
- [FoggyKitchen Azure Container Instance Module](https://github.com/foggykitchen/terraform-az-fk-container-instance)

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
