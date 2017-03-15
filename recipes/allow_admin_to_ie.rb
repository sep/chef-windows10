  
powershell_script 'Giving a local admin access to IE' do 
  code <<-EOH 
    
    # Thanks to 
    # https://gallery.technet.microsoft.com/scriptcenter/How-to-switch-UAC-level-0ac3ea11
    # https://blogs.technet.microsoft.com/heyscriptingguy/2015/04/02/update-or-add-registry-key-value-with-powershell/

    Function Set-RegistryValue($key, $name, $value, $type="Dword") {  
      If ((Test-Path -Path $key) -Eq $false) { New-Item -ItemType Directory -Path $key | Out-Null }  
           Set-ItemProperty -Path $key -Name $name -Value $value -Type $type  
    }

    $Key = "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System" 
    $ConsentPromptBehaviorAdmin_Name = "ConsentPromptBehaviorAdmin" 
    $PromptOnSecureDesktop_Name = "PromptOnSecureDesktop" 
    $ConsentPromptBehaviorUser_Name = "ConsentPromptBehaviorUser" 
    $EnableLUA_Name = "EnableLUA" 

    Function Set-UACLevel() { 
        Param([int]$Level= 2) 
     
        New-Variable -Name PromptOnSecureDesktop_Value 
        New-Variable -Name ConsentPromptBehaviorAdmin_Value 
        New-Variable -Name ConsentPromptBehaviorUse_Value 
        New-Variable -Name EnableLUA_Value 
     
        If($Level -In 0, 1, 2, 3) { 
            $ConsentPromptBehaviorAdmin_Value = 5 
            $PromptOnSecureDesktop_Value = 1 
            Switch ($Level)  
            {  
              0 { 
                  $ConsentPromptBehaviorAdmin_Value = 0  
                  $PromptOnSecureDesktop_Value = 0 
                  $ConsentPromptBehaviorUse_Value = 0
                  $EnableLUA_Value = 1
              }  
              1 { 
                  $ConsentPromptBehaviorAdmin_Value = 5  
                  $PromptOnSecureDesktop_Value = 0 
                  $ConsentPromptBehaviorUse_Value = 3
                  $EnableLUA_Value = 1
              }  
              2 { 
                  $ConsentPromptBehaviorAdmin_Value = 5  
                  $PromptOnSecureDesktop_Value = 1 
                  $ConsentPromptBehaviorUse_Value = 3
                  $EnableLUA_Value = 1
              }  
              3 { 
                  $ConsentPromptBehaviorAdmin_Value = 2  
                  $PromptOnSecureDesktop_Value = 1 
                  $ConsentPromptBehaviorUse_Value = 3
                  $EnableLUA_Value = 1
              }  
            } 
            Set-RegistryValue -Key $Key -Name $ConsentPromptBehaviorAdmin_Name -Value $ConsentPromptBehaviorAdmin_Value 
            Set-RegistryValue -Key $Key -Name $PromptOnSecureDesktop_Name -Value $PromptOnSecureDesktop_Value 
            Set-RegistryValue -Key $Key -Name $ConsentPromptBehaviorUser_Name -Value $ConsentPromptBehaviorUse_Value 
            Set-RegistryValue -Key $Key -Name $EnableLUA_Name -Value $EnableLUA_Value        
        } 
        Else{ 
            "No supported level" 
        } 
    }

    Function Get-RegistryValue($key, $value) {  
       (Get-ItemProperty $key $value).$value  
    }  

    Set-RegistryValue -Key "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System" -Name "FilterAdministratorToken" -Value "1"
    Set-RegistryValue -Key "HKLM:\\HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System\\UIPI\\" -Name "Default"  -Value "0x00000001(1)" -Type String
    Set-UACLevel 2
  EOH
end
