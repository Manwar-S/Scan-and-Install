$appList = @(Get-Content -Path 'C:\Lab\Apps\Apps.txt' )
$installedApps = Get-ItemProperty @(
            'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
            'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*')
[bool]$installed = $false
$msiFile = "C:\Lab\Apps"
$msiArgs = "-qb"

foreach($app in $appList){
   foreach($installedApp in $installedApps){
      if($installedApp.DisplayName -like "*$app*"){
         $installed = $true
         echo "$app Already Installed"
      }   
   }
        if($installed -eq $false){
                echo "$app Isn't Installed"
                echo "Wait......" 
                $installer = @(Get-ChildItem $msiFile -Name)
                foreach($install in $installer){
                    if($install -like "*$app*"){
                        (Start-Process -FilePath "$install" -WorkingDirectory $msiFile -ArgumentList $msiArgs -Wait -Passthru).ExitCode
                        echo "$app Installed!!!"    
                    }                             
                }                
        }
   $installed = $false
}