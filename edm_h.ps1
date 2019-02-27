
<#
  a market watch job, demonstrating web data scrape and analysis

#>


#####################################################################################################
# The main process
#####################################################################################################


$watch = getWatches
$dtt = getDateTime
$dd = [PSCustomObject]@{datetime = $dtt; daysnew = $watch.daysnew; listed = $watch.listed} 
#write-host $dd

appendWatches $dd
showWatches

#####################################################################################################


function getWatches{

  $daysnew_pattern = '<div class=\"si-market-stat__top-value\">(?<newlist>\d+)\D*New Today'
  $listed_pattern = '<div class=\"si-market-stat__top-value\">(?<listed>\d+)\D*Listed'


  $r = [System.Net.WebRequest]::Create("https://www.bestedmontonrealestate.com/market-statistics/")
  $resp = $r.GetResponse()
  $reqstream = $resp.GetResponseStream()
  $sr = new-object System.IO.StreamReader $reqstream
  $result = $sr.ReadToEnd()
  # write-host $result

  $m = $result -match $daysnew_pattern
  $daysnew_data = $Matches.newlist
  $m = $result -match $listed_pattern
  $listed_data = $Matches.listed

  return [PSCustomObject]@{daysnew = $daysnew_data; listed = $listed_data}

}



function getDateTime{
  return Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}


function appendWatches{
  <################### 
     append csv
  ####################>

  $path = '\\GOA\MyDocs\K\kevin.luan\my.works\edm_h.csv'
  # $args[0 is an object. e.g., [PSCustomObject]@{Name = 'daysnew'; value = '12345'}
  $args[0] | Export-Csv -Path $path -Append -NoTypeInformation -Force

}


function showWatches{
  $path = '\\GOA\MyDocs\K\kevin.luan\my.works\edm_h.csv'
  clear-host
  Import-Csv -Path $path

}
