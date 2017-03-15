# # encoding: utf-8

# Inspec test for recipe windows10::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/


describe registry_key('System Policies','HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System') do
  its('ConsentPromptBehaviorAdmin') { should eq 5 }
  its('PromptOnSecureDesktop') { should eq 1 }
  its('ConsentPromptBehaviorUser') { should eq 3 }
  its('EnableLUA') { should eq 1 }
  its('FilterAdministratorToken') { should eq 1 } 
end

describe registry_key('System Policies UIPI','HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\UIPI') do 
  its('Default') { should eq "0x00000001(1)" } 
end