##
## rc_export.R
## 
## Get data from REDCap
##
## Rollie Parrish
## 12/27/2013


rc_export <- function(token="missing", rawOrLabel=NULL, exportDataAccessGroups=NULL, file="")
  
{
  
  require(bitops)
  require(RCurl)
  
  # load the token
  # load(token)
  
  # Set the url to the api (ex. https://YOUR_REDCAP_INSTALLATION/api/)
  api_url = 'https://ampa.org/redcap_sandbox/api/'
  
  curl_handle = getCurlHandle()
  curlSetOpt(ssl.verifypeer = FALSE, curl = curl_handle)
  ## Read all data from REDCap
  y <- postForm(api_url,
                token = token,
                content = 'record',
                format = 'csv',
                type = 'flat',
                foo = "bar",
                exportDataAccessGroups = exportDataAccessGroups,
                rawOrLabel = rawOrLabel,
                curl = curl_handle)
  
  
  # Use the output from postForm() to create a data frame of the exported data
  x <- read.table(file = textConnection(y), header = TRUE, sep = ",", na.strings = "",
                  stringsAsFactors = FALSE)
  rm(token, y)
  
  
  results <- x
  
  if(file != "") {
    write.csv(x, file=paste0("../Data/",file), row.names=FALSE)
  }
  return(results)
}

