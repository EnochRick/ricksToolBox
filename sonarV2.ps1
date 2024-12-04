param(
    [switch]$V, #allows verbose mode for debuging with -V flag on script call in CLI
    [string]$csvPath
)

#REQUIRES -Version 2.0
<#
.SYNOPSIS
    This script will take a CSV in with all the IP addresses listed that we want to check visibility to via a Test-Connection command.
.DESCRIPTION
    
    .\sonarV2.ps1 <csvPath> -V(optional) 

    This script will iterate through the entire list, and create an output list of devices that responded to pings as a subset set given on the input list. It will dump out a list as a text file.
    Todo: I probably dont need the $Header Variable, i copied that in from Microsoft examples.

    Makes heavy use of Test-Connection: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/test-connection?view=powershell-7.4
.PARAMETER <-V>
    Verbose Mode
.PARAMETER <csvPath>
    the CSV containing a single column of IP addresses
.NOTES
    File Name      : sonarV2.ps1
    Author         : Rick Stehmeyer (hstehmeyer@albireoenergy.com)
    Prerequisite   : PowerShell V2 upper.
.EXAMPLE
    Run the script with verbose output
    .\sonarV2.ps1 .\testCSV.csv -V 
     
.EXAMPLE
    Run the script with normal output
    .\sonarV2.ps1 .\testCSV.csv
#>

#!!!!!!!!!!!!!!!!!! Script Code !!!!!!!!!!!!!!!!!!!!!!!!!
$Header = 'IP'                                                              #this is the string of the header we'll look at in the csv
$listOfSites = @()                                                          #creates an array we're going to poulate later
$sitesResponding = @()                                                      #creates an array of successful tests
$simpleResponses = @()

$ipAddresses = Import-Csv -Path $csvPath -Delimiter ',' -Header $Header     #import the csv file, tell it to iterate on commas
    foreach ($row in $ipAddresses) {                                        #iterate through each row
        $listOfSites += $row.IP                                             #pull the IP out of the CSV, append it to our array
    }

if ($V){                                                                    #if Debug, 
    foreach ($row in $listOfSites){                                             #iterate through and test connection   
    Write-Host "Found this IP in the array $row"                                #Tell the user whats in the array
    }
}# ends Debug Check

foreach ($row in $listOfSites) {                                            #iterate through each item
    if (Test-Connection $row -Quiet -Count 2) {                             #ping twice to see if we get a response
        $sitesResponding += Test-Connection $row                            #If we get a response, add it to our list of sites that responded
        Write-Host "Response at $row"                                        #Dump "success" to console
        $simpleResponses += "Response at $row"                               #append response to array for simple file out
    }else{
        Write-Host "No Response at $row"                                     #Dump "Failure" to console
    }
}

$simpleResponses | Out-File -FilePath .\SitesResponding.txt


if ($V){                                                                    
    foreach ($row in $sitesResponding){                                     #iterate through and test connection   
        Write-Host "$row"                                                       #Tell the user whats in the array of TestConnection Results (Verbose dump)
    }
    $sitesResponding | Out-File -FilePath .\fullTrace.txt
}