# Aviator Core - Infrastructure Audit Script
Write-Host "--- Starting Aviator Core Resource Audit ---" -ForegroundColor Cyan

# 1. Check Resource Group Status
$rg = Get-AzResourceGroup -Name "rg-aviator-core-prod" -ErrorAction SilentlyContinue
if ($rg) {
    Write-Host "[SUCCESS] Resource Group found: $($rg.ResourceGroupName) (Status: $($rg.ProvisioningState))" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Resource Group 'rg-aviator-core-prod' not found!" -ForegroundColor Red
}

# 2. Check AKS Cluster Health [cite: 396]
$aks = Get-AzAksCluster -ResourceGroupName "rg-aviator-core-prod" -Name "aks-aviator-core" -ErrorAction SilentlyContinue
if ($aks) {
    Write-Host "[SUCCESS] AKS Cluster: $($aks.Name) (Provisioning State: $($aks.ProvisioningState))" -ForegroundColor Green
} else {
    Write-Host "[WARNING] AKS Cluster not found or still deploying." -ForegroundColor Yellow
}

# 3. Check VNet Connectivity [cite: 414]
$vnet = Get-AzVirtualNetwork -Name "vnet-hub-aviator" -ResourceGroupName "rg-aviator-core-prod" -ErrorAction SilentlyContinue
if ($vnet) {
    $peering = $vnet.VirtualNetworkPeerings | Where-Object { $_.Name -eq "hub-to-spoke" }
    if ($peering.PeeringState -eq "Connected") {
        Write-Host "[SUCCESS] VNet Peering 'hub-to-spoke' is Connected." -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Peering state is: $($peering.PeeringState)" -ForegroundColor Yellow
    }
}

Write-Host "--- Audit Complete ---" -ForegroundColor Cyan