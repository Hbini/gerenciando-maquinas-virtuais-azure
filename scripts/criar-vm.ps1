# Script PowerShell para criar Máquinas Virtuais no Azure
# Laboratório DIO - Gerenciamento de Máquinas Virtuais no Azure

<#
.DESCRIPTION
    Script para automatizar a criação de máquinas virtuais no Microsoft Azure
    Criado como parte do laboratório de certificação AZ-104

.PARAMETER ResourceGroupName
    Nome do grupo de recursos onde a VM será criada

.PARAMETER VirtualMachineName
    Nome da máquina virtual

.PARAMETER Location
    Região do Azure onde criar a VM

.EXAMPLE
    .\criar-vm.ps1 -ResourceGroupName "meu-rg" -VirtualMachineName "minha-vm" -Location "eastus"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$VirtualMachineName,
    
    [Parameter(Mandatory=$true)]
    [string]$Location,
    
    [string]$VirtualNetworkName = "vnet-default",
    [string]$SubnetName = "subnet-default",
    [string]$NSGName = "nsg-default",
    [string]$VMSize = "Standard_B2s"
)

# Função para verificar conexão com Azure
function Connect-ToAzure {
    try {
        $context = Get-AzContext
        if (-not $context) {
            Write-Host "Conectando ao Azure..."
            Connect-AzAccount
        } else {
            Write-Host "Já conectado ao Azure: $($context.Account)"
        }
    }
    catch {
        Write-Error "Erro ao conectar ao Azure: $_"
        exit 1
    }
}

# Função para criar grupo de recursos
function New-ResourceGroupIfNotExists {
    param([string]$RGName, [string]$Loc)
    
    $rg = Get-AzResourceGroup -Name $RGName -ErrorAction SilentlyContinue
    
    if (-not $rg) {
        Write-Host "Criando grupo de recursos: $RGName em $Loc"
        New-AzResourceGroup -Name $RGName -Location $Loc
    } else {
        Write-Host "Grupo de recursos já existe: $RGName"
    }
}

# Função para criar rede virtual
function New-VirtualNetworkIfNotExists {
    param([string]$RGName, [string]$VNetName, [string]$Loc)
    
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $RGName -Name $VNetName -ErrorAction SilentlyContinue
    
    if (-not $vnet) {
        Write-Host "Criando rede virtual: $VNetName"
        $subnetConfig = New-AzVirtualNetworkSubnetConfig -Name "subnet-default" -AddressPrefix "10.0.1.0/24"
        New-AzVirtualNetwork -ResourceGroupName $RGName -Location $Loc -Name $VNetName `
            -AddressPrefix "10.0.0.0/16" -Subnet $subnetConfig
    } else {
        Write-Host "Rede virtual já existe: $VNetName"
    }
}

# Script principal
try {
    Connect-ToAzure
    New-ResourceGroupIfNotExists -RGName $ResourceGroupName -Loc $Location
    New-VirtualNetworkIfNotExists -RGName $ResourceGroupName -VNetName $VirtualNetworkName -Loc $Location
    
    Write-Host "Configuração concluída! Próximo passo: criar a VM com New-AzVM"
}
catch {
    Write-Error "Erro durante a execução: $_"
    exit 1
}
