Add-AzureRmAccount
$Subs = Get-AzureRmSubscription | Select-Object Id, Name, TenantId | Out-GridView -Title "Select Subscriptions (use Ctrl/Shift for multiples)" -PassThru
$VMs = $null
foreach ($sub in $Subs) {
    Select-AzureRmSubscription -Subscription $sub.Id
    $SubId = $sub.Id
    $SubName = $sub.Name
    $VMs += Get-AzureRmVM -Status | Select-Object @{n="SubscriptionGuid";e={$SubId}},@{n="SubscriptionName";e={$SubName}},Name, ResourceGroupName, PowerState, Location, {$_.HardwareProfile.VmSize}, {$_.AvailabilitySetReference.Id}
    
}
$VMs | Export-Csv -Path "$($Env:Temp)\ARMVMs.csv" -NoTypeInformation
Invoke-Item "$($Env:Temp)\ARMVMs.csv"
