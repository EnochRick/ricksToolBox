param(
    [switch]$V, #allows verbose mode for debuging with -V flag on script call in CLI
    [string]$skySparkPath
)
#REQUIRES -Version 2.0
<#
.SYNOPSIS
    Set Skyspark as Windows Service, pass the location of skyspark's folder to this command and it'll assume there is a /bin directory there and setup skyspark as a windows service. 

.DESCRIPTION
    
    .\CreateSkysparkService.ps1 <skysparkpath> -V(optional) 

    This script will setup skyspark as a service by finding the /bin directory and running the powershell sc.exe command to create the windows service. 
 
.NOTES
    Name: CreateSkysparkService.ps1
    Author: Rick Stehmeyer
    Version: 1.0
    DateCreated: 2025-April-8
    Prerequisite   : PowerShell V2 upper
 
.EXAMPLE
    CreateSkysparkService [location of skyspark directory]
    CreateSkysparkService C:\skyspark-3.1.11
.LINK
    https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/sc-create
#>
 
    BEGIN {}
    Write-Host "Path of skyspark resolved to: $skySparkPath"      
    PROCESS {}
    sc.exe create skyspark type=own start=auto error=normal binpath=$skySparkPath displayname=SkySpark
 
    END {}
}