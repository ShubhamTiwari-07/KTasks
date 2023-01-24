$result = @()
$VMs = get-azVm
foreach ($VM in $Vms)
{
  $NICs = Get-AzNetworkInterface -ResourceId $Vm.NetworkProfile.NetworkInterfaces.id

  foreach ($NIC in $NICs){
   $ipconfig = Get-AzNetworkInterfaceIpConfig -NetworkInterface $NIC  

  }
    $Status = Get-AzVM -Name $vm.Name -Status 
    $Output = New-Object -TypeName psobject 
    $Output | Add-Member NoteProperty -Name VMName -Value $Vm.Name
    $Output | Add-Member NoteProperty -Name VMLocation -value $VM.Location
    $Output | Add-Member NoteProperty -Name PrivateIp -value $ipconfig.PrivateIpAddress
    $Output | Add-Member NoteProperty -Name PrivateIpAllocation -value $ipconfig.PrivateIpAllocationMethod
    $Output | Add-Member NoteProperty -Name OSType -Value $Vm.StorageProfile.ImageReference.Offer
    $Output | Add-Member NoteProperty -Name OSName -Value $Vm.StorageProfile.ImageReference.Sku
    $Output | Add-Member NoteProperty -Name VMStatus -Value $status.PowerState 
    
    $result += $Output
}
$result | ConvertTo-Json | Out-File C:\result.json -Encoding ascii