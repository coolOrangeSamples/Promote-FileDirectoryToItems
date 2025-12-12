#JobEntityType = FILE

#region Settings
#names of files to be input into Quickstart
$fileDirectory = "C:\Users\smfto\Downloads\Boxermotor"
#endRegion

$ErrorActionPreference = "Continue"
if (-not $IamRunningInJobProcessor){
	Import-Module powerVault
	Import-Module powerJobs

	Open-VaultConnection -Server "localhost" -Vault "PDMC-Sample" -User "Administrator" -Password ""
	
}
Get-ChildItem -Path $fileDirectory -file -Recurse | ForEach-Object{
	foreach ($fname in $fileNames){
		$file = Get-VaultFile -Properties @{"Name"=$fname}
		try{
			$autoAssignDuplicate = $true
			$assignAll = [Autodesk.Connectivity.WebServices.ItemAssignAll]::Default #Default = Use admin child assignment behavior server setting
			$vault.ItemService.AddFilesToPromote(@($file.Id),$assignAll,$autoAssignDuplicate)
			$time = New-Object DateTime
			$promotedItems = $vault.ItemService.GetPromoteComponentOrder([ref]$time)
			if ($promotedItems.PrimaryArray) {
				$vault.ItemService.PromoteComponents($time,$promotedItems.PrimaryArray)
				Write-Host "Promoted primary components!"    
			}
			if ($promotedItems.NonPrimaryArray) {
				$vault.ItemService.PromoteComponentLinks($promotedItems.NonPrimaryArray)
				Write-Host "Promoted component link (e.g. secondary component)!"
			}
			$result = $vault.ItemService.GetPromoteComponentsResults($time)
		
			$editedItems = $vault.ItemService.EditItems($result.ItemRevArray.RevId)
			$vault.ItemService.UpdateAndCommitItems($editedItems)
			Write-Host "Successfully assigned/updated item '$($editedItems[0].ItemNum)'"
		}
		catch{
			$vault.ItemService.DeleteUncommittedItems($false)
			$ex = $_.Exception
			$errorCode = $ex.InnerException.ErrorCode
			$restrictionCode = ""
			if($null -ne $ex.InnerException.Detail){
				$restrictionCode = $ex.InnerException.Detail.sldetail.restrictions.restriction.code
			}
			$message = "$errorCode [$restrictionCode]: $($ex.Message)"
			throw("Failed to assign/update item for file '$($file._Name)'! Please run manually! $message")
		}
		finally {
			$vault.ItemService.DeleteUncommittedItems($false)
			Write-Host "Deleted uncommitted items"
		}
	}
}
