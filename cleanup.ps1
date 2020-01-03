param(
    [switch]$DeleteMe = $false,
    [string]$Tag = ""
)

Write-Host "Azure Cleanup Script."
Write-Host "  delete 'deleteme': " -NoNewline
Write-Host "$DeleteMe" -ForegroundColor Green
Write-Host "  tag: " -NoNewline
Write-Host "$Tag" -ForegroundColor Green
Write-Host ""

$rgs = Get-AzResourceGroup

foreach($rg in $rgs) {
    $name = $rg.ResourceGroupName

    Write-Host "$name... " -NoNewline

    $delete = $false

    if($DeleteMe -and ($name -match "delete")) {
        $delete = $true
        Write-Host " !name " -NoNewline
    }

    if(($null -ne $rg.Tags) -and $rg.Tags.ContainsKey($Tag)) {
        $delete = $true
        Write-Host " !tag " -NoNewline
    }

    if($delete) {
        Write-Host "deleting... " -NoNewline -ForegroundColor Red
        
        $t = Remove-AzResourceGroup -Name $name -Force

        Write-Host "OK" -ForegroundColor Green
    } else {
        Write-Host "skipping" -ForegroundColor Green
    }
}

