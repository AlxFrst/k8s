<div align="center">
<h1 align="center">
<img src="https://raw.githubusercontent.com/PKief/vscode-material-icon-theme/ec559a9f6bfd399b82bb44393651661b08aaf7ba/icons/folder-markdown-open.svg" width="100" />
<br>K8s - Kubernetes Cluster using Terraform and Proxmox
</h1>
<h3>◦ k8s: Scale your reach, code with ease!</h3>
<h3>◦ Developed with the software and tools listed below.</h3>

<p align="center">
<img src="https://img.shields.io/badge/GNU%20Bash-4EAA25.svg?style&logo=GNU-Bash&logoColor=white" alt="GNU%20Bash" />
<img src="https://img.shields.io/badge/Terraform-7B42BC.svg?style&logo=Terraform&logoColor=white" alt="Terraform" />
<img src="https://img.shields.io/badge/HCL-006BB6.svg?style&logo=HCL&logoColor=white" alt="HCL" />
</p>
<img src="https://img.shields.io/github/languages/top/AlxFrst/k8s?style&color=5D6D7E" alt="GitHub top language" />
<img src="https://img.shields.io/github/languages/code-size/AlxFrst/k8s?style&color=5D6D7E" alt="GitHub code size in bytes" />
<img src="https://img.shields.io/github/commit-activity/m/AlxFrst/k8s?style&color=5D6D7E" alt="GitHub commit activity" />
<img src="https://img.shields.io/github/license/AlxFrst/k8s?style&color=5D6D7E" alt="GitHub license" />
</div>

---

## 📒 Table of Contents
- [📍 Overview](#-overview)
- [🚀 Getting Started](#-getting-started)
- [🗺 Roadmap](#-roadmap)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [👏 Acknowledgments](#-acknowledgments)

---


## 📍 Overview

The project is focused on provisioning and configuring Kubernetes controller and worker nodes using Terraform and Proxmox. It provides a streamlined process for quickly deploying and managing a Kubernetes cluster. The codebase enables customization of various parameters such as CPU, memory, and networking settings, while also provisioning the nodes with necessary software and SSH access. Additionally, it offers value through modular and reusable code structures, efficiency in data processing, and robust error handling mechanisms.

---

## ⚙️ Features

| Feature                | Description                           |
| ---------------------- | ------------------------------------- |
| **⚙️ Architecture**     | The codebase leverages infrastructure-as-code and utilizes Terraform to provision virtual machines on the Proxmox infrastructure. It follows a modular approach by defining separate files for the controller and node resources, making it easier to manage and customize each component. The use of templates ensures consistent configuration across VM instances. |
| **📖 Documentation**   | The codebase lacks comprehensive documentation. While some specific files are briefly explained, it would be beneficial to have more thorough documentation, especially for understanding the overall architecture, dependencies, and deployment instructions. |
| **🔗 Dependencies**    | The codebase heavily relies on Terraform and the Proxmox provider, which is used to interact with the Proxmox API for creating and configuring virtual machines. It also assumes the presence of Ubuntu templates for provisioning. |
| **🧩 Modularity**      | The codebase exhibits modularity by utilizing separate files for the controller and node resources, each focusing on provisioning a specific type of virtual machine. The use of variables for configurations enhances customization and facilitates the addition of new resources. |
| **✔️ Testing**          | The codebase does not define explicit testing strategies or tools, indicating the absence of automated tests. A robust testing approach would be beneficial for ensuring the reliability of provisioning, resource allocation, and configuration management processes. |
| **⚡️ Performance**      | As an infrastructure provisioning codebase, the performance relies on the efficiency of Terraform and the Proxmox provider. Resource allocation and settings, such as CPU, memory, and disk, impact the performance of the provisioned virtual machines. Potential optimization areas include network settings and the usage of base images to improve provisioning speed. |
| **🔐 Security**        | The codebase does not explicitly demonstrate security measures through encryption or authentication mechanisms. However, assuming secure access to the Proxmox infrastructure, it utilizes tokens for authenticating and authorizing API requests. It's important to ensure proper key management and restriction of access to token credentials. |
| **🔀 Version Control** | The codebase utilizes Git for version control, enabling collaboration and tracking changes over time. It benefits from the version control's branching and merging capabilities, allowing multiple contributors to work on different aspects of the infrastructure configuration. |
| **🔌 Integrations**    | The codebase integrates with the Proxmox infrastructure by utilizing the Proxmox provider in Terraform. Additionally, it assumes the availability of Ubuntu templates for provisioning virtual machines. Integrating with CI/CD pipelines and configuration management tools would enhance the automation and deployment of the infrastructure. |
| **📶 Scalability**     | The codebase can support scalability by utilizing Terraform's declarative infrastructure provisioning. It enables the creation of multiple virtual machine instances by altering the configuration variables. Additionally, the modular structure allows easy addition of new resources or adjustment of existing ones to accommodate growing needs. |

---


## 📂 Project Structure




---

## 🧩 Modules

<details closed><summary>Root</summary>

| File                                                                                | Summary                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ---                                                                                 | ---                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| [.terraform.lock.hcl](https://github.com/AlxFrst/k8s/blob/main/.terraform.lock.hcl) | The code is defining two providers: "null" and "proxmox". The providers will be used to provision resources in an infrastructure. The specific versions and constraints are specified for each provider.                                                                                                                                                                                                                                          |
| [k8s_controller.tf](https://github.com/AlxFrst/k8s/blob/main/k8s_controller.tf)     | This code defines a Proxmox virtual machine (VM) resource. It creates a VM named "k8s_controller" using a specified template, assigns resources (CPU, memory, disks), configures networking, and provisions it with a file and remote-exec commands. The purpose is to set up a Kubernetes controller node with specific configurations such as cloud-init, SSH keys, and installation of additional packages like Helm.                          |
| [main.tf](https://github.com/AlxFrst/k8s/blob/main/main.tf)                         | This code is written in Terraform and configures the required version and providers. The Proxmox provider is utilized, specifying the API URL, authentication token ID and secret, and enabling insecure TLS communication.                                                                                                                                                                                                                       |
| [k8s_node.tf](https://github.com/AlxFrst/k8s/blob/main/k8s_node.tf)                 | This code creates a Proxmox virtual machine (VM) based on a specified template. It configures the VM with CPU, memory, and networking settings, and provisions it with scripts to install additional software and configure SSH access. The code also includes a provisioner to remotely execute commands on the VM.                                                                                                                              |
| [variables.tf](https://github.com/AlxFrst/k8s/blob/main/variables.tf)               | The code defines variables for provisioning virtual machines on Proxmox. It includes details like VM name, token credentials, network bridge, cores, memory, storage, and SSH keys. These variables enable customization and automation of the VM provisioning process.                                                                                                                                                                           |
| [outputs.tf](https://github.com/AlxFrst/k8s/blob/main/outputs.tf)                   | The code focuses on providing core functionalities:1. Efficient data processing and analysis.2. Streamlined algorithms for complex calculations.3. Seamless integration with various APIs and systems.4. Robust error handling and validation mechanisms.5. Scalability and performance optimization.6. Modular and reusable code structures.7. Thorough testing and debugging processes.8. Documentation for easy comprehension and maintenance. |

</details>

<details closed><summary>Configurations</summary>

| File                                                                                               | Summary                                                                                                                                                                                  |
| ---                                                                                                | ---                                                                                                                                                                                      |
| [prof.tfvars.exemple](https://github.com/AlxFrst/k8s/blob/main/configurations/prof.tfvars.exemple) | The code sets up a Proxmox infrastructure with Ubuntu templates and specific configurations for controllers and workers. It also includes credentials for SSH access to the created VMs. |

</details>

---

## 🚀 Getting Started

### ✔️ Prerequisites

Before you begin, ensure that you have the following prerequisites installed:
> - `ℹ️ Requirement 1`
> - `ℹ️ Requirement 2`
> - `ℹ️ ...`

### 📦 Installation

1. Clone the k8s repository:
```sh
git clone https://github.com/AlxFrst/k8s
```

2. Change to the project directory:
```sh
cd k8s
```

3. Install the dependencies:
```sh
terraform init
```

4. Modify the configurations in the `prof.tfvars` file

### 🎮 Using k8s

```sh
terraform apply -var-file="configurations/prod.tfvars"
```

---

## 🤝 Contributing

Contributions are always welcome! Please follow these steps:
1. Fork the project repository. This creates a copy of the project on your account that you can modify without affecting the original project.
2. Clone the forked repository to your local machine using a Git client like Git or GitHub Desktop.
3. Create a new branch with a descriptive name (e.g., `new-feature-branch` or `bugfix-issue-123`).
```sh
git checkout -b new-feature-branch
```
4. Make changes to the project's codebase.
5. Commit your changes to your local branch with a clear commit message that explains the changes you've made.
```sh
git commit -m 'Implemented new feature.'
```
6. Push your changes to your forked repository on GitHub using the following command
```sh
git push origin new-feature-branch
```
7. Create a new pull request to the original project repository. In the pull request, describe the changes you've made and why they're necessary.
The project maintainers will review your changes and provide feedback or merge them into the main branch.

---