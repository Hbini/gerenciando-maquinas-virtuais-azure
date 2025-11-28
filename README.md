# Gerenciando Máquinas Virtuais no Azure

## Resumo do Laboratório

Este repositório contém resumos, anotações, dicas e scripts práticos do laboratório da **DIO** sobre Gerenciamento de Máquinas Virtuais no **Microsoft Azure**. O projeto foi desenvolvido como parte do programa de certificação **AZ-104 (Azure Administrator)**.

## 📚 Conteúdo

### 1. Implantação de Máquinas Virtuais

**Conceitos principais:**
- Criação e configuração de VMs no Azure Portal
- Escolha de imagens e tamanhos de máquinas virtuais
- Configuração de redes e grupos de segurança
- Seleção de discos e opções de armazenamento

**Dicas Importantes:**
- Usar o Azure Resource Manager (ARM) para automação
- Implementar templates Bicep para infraestrutura como código
- Sempre definir grupos de segurança (NSG) para controlar tráfego
- Configurar backup e recuperação de desastres desde o início

### 2. Desanexando Disco da Máquina

**Procedimento:**
1. Parar a máquina virtual antes de desanexar discos
2. Acessar a seção de discos da VM
3. Selecionar o disco a ser desanexado
4. Remover e confirmar a operação

**Considerações:**
- Dados no disco não serão deletados
- Possibilidade de anexar o disco em outra VM
- Manter backups do disco antes de operações críticas

## 🎯 Objetivos de Aprendizagem

- ✅ Aplicar conceitos de gerenciamento de VMs em ambiente prático
- ✅ Documentar processos técnicos de forma clara e estruturada
- ✅ Utilizar GitHub como ferramenta de compartilhamento de documentação técnica
- ✅ Compreender ciclo de vida completo de máquinas virtuais no Azure

## 🛠 Ferramentas e Tecnologias

- Microsoft Azure Portal
- Azure CLI
- Azure PowerShell
- Azure Resource Manager (ARM)
- Bicep Templates
- GitHub para versionamento

## 📁 Estrutura do Repositório

```
.
├── README.md                    # Este arquivo
├── docs/
│   ├── 01-implantacao-vm.md    # Documentação detalhada sobre implantação
│   ├── 02-desanexacao-disco.md # Documentação sobre desanexação de discos
│   └── 03-boas-praticas.md     # Boas práticas de gerenciamento
├── scripts/
│   ├── criar-vm.ps1            # Script PowerShell para criar VM
│   ├── criar-vm.sh             # Script Bash para criar VM
│   └── gerenciar-discos.ps1    # Script para gerenciar discos
├── templates/
│   ├── vm-template.bicep       # Template Bicep para VM
│   ├── vm-parameters.json      # Arquivo de parâmetros
│   └── rg-template.bicep       # Template para Resource Group
└── images/                      # Capturas de tela do processo
    ├── portal-01.png
    ├── portal-02.png
    └── ...
```

## 🚀 Como Usar

### Criar uma VM com PowerShell

```powershell
$resourceGroupName = "meu-rg"
$vmName = "minha-vm"
$location = "eastus"
$vmSize = "Standard_B2s"

# Criar grupo de recursos
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Criar VM
New-AzVM -ResourceGroupName $resourceGroupName `
  -Name $vmName `
  -Location $location `
  -VirtualNetworkName "minha-vnet" `
  -SubnetName "minha-subnet" `
  -SecurityGroupName "meu-nsg" `
  -PublicIpAddressName "meu-pip" `
  -Image "UbuntuLTS" `
  -Size $vmSize
```

### Criar uma VM com Bicep

```bicep
param location string = 'eastus'
param vmName string = 'minha-vm'
param vmSize string = 'Standard_B2s'

resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: 'azureuser'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}
```

### Desanexar um Disco

```powershell
$resourceGroupName = "meu-rg"
$vmName = "minha-vm"
$diskName = "disco-para-desanexar"

# Parar VM
Stop-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Force

# Remover disco
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
$vm = Remove-AzVMDataDisk -VM $vm -DataDiskNames @($diskName)

# Atualizar VM
Update-AzVM -ResourceGroupName $resourceGroupName -VM $vm
```

## 💡 Boas Práticas

1. **Segurança:**
   - Sempre usar grupos de segurança de rede (NSG)
   - Configurar Azure Security Center
   - Usar Azure Key Vault para senhas e certificados
   - Implementar MFA (Autenticação Multi-Fator)

2. **Performance:**
   - Usar SSD Premium para melhor desempenho
   - Escolher regiões próximas aos usuários
   - Monitorar com Azure Monitor
   - Usar auto-scaling quando apropriado

3. **Custo:**
   - Usar instâncias reservadas
   - Implementar políticas de backup
   - Monitorar despesas com Azure Cost Management
   - Desligar VMs não utilizadas

4. **Gerenciamento:**
   - Usar tags para organização
   - Implementar políticas com Azure Policy
   - Manter documentação atualizada
   - Usar IaC (Infraestrutura como Código)

## 📋 Certificação AZ-104

Este laboratório está alinhado com os objetivos da certificação **Azure Administrator (AZ-104)**, cobrindo:
- Manage Azure subscriptions and governance
- Manage identities and governance
- Manage storage
- Manage compute resources
- Manage virtual networking

## 🔗 Recursos Úteis

- [Documentação Azure VMs](https://docs.microsoft.com/pt-br/azure/virtual-machines/)
- [Azure CLI Documentation](https://docs.microsoft.com/pt-br/cli/azure/)
- [Azure PowerShell Documentation](https://docs.microsoft.com/pt-br/powershell/azure/)
- [Bicep Documentation](https://docs.microsoft.com/pt-br/azure/azure-resource-manager/bicep/)
- [Cursos DIO](https://www.dio.me/)

## 📞 Suporte

Para dúvidas ou contribuições, entre em contato ou abra uma issue neste repositório.

## 📄 Licença

Este projeto está licenciado sob a MIT License - veja o arquivo LICENSE para detalhes.

---

**Criado como parte do laboratório de certificação AZ-104 da DIO**
**Última atualização:** 28 de Novembro de 2025
