##
## rc_export_test.R
## 
## Get Data Access Group data from REDCap
##
## Rollie Parrish
## 1/02/2014

longitudinal <- "47D50FDA4D1174D34FA40082614DA2B4"
SOTM <- "8AF5E3F08388B1CE55EA9B1A0BD7AA15"
CCTM_QM <- "B8DE7826A4579D94DA345C16934FF834"

rc_export_test <- function(token=CCTM_QM)
  
{
  
  require(bitops)
  require(RCurl)
  
  # load the token
  # load(token)
  
  # Set the url to the api (ex. https://YOUR_REDCAP_INSTALLATION/api/)
  api_url = 'https://ampa.org/redcap/api/'
  
  curl_handle = getCurlHandle()
  # http://www.statsravingmad.com/blog/statistics/a-tiny-rcurl-headache/
  cert <- system.file("CurlSSL/cacert.pem", package = "RCurl")
  curlSetOpt(ssl.verifypeer = TRUE, curl = curl_handle, cainfo = cert)

  fields <- c('jan_2013_arm_1', 'feb_2013_arm_1')

  ## Read all data from REDCap
  x <- postForm(api_url,
                token = token,
                content = 'record',
                format = 'csv',
                type = 'flat',
                exportDataAccessGroups = TRUE,
  #              rawOrLabel = "label",
                rawOrLabel = "raw",
                curl = curl_handle)
  
  
  # Use the output from postForm() to create a data frame of the exported data
  x <- read.table(file = textConnection(x), header = TRUE, sep = ",", na.strings = "",
                  stringsAsFactors = FALSE)
  
  ## Read event data from REDCap
  y <- postForm(api_url,
                token = token,
                content = 'user',
                format = 'csv',
                returnFormat = 'csv',
#                type = 'flat',
#                exportDataAccessGroups = TRUE,
#                rawOrLabel = "label",
                curl = curl_handle)
  
  
  # Use the output from postForm() to create a data frame of the exported data
  #y <- read.table(file = textConnection(y), header = TRUE, sep = ",", na.strings = "",
  #                stringsAsFactors = FALSE)
  
  #rm(token, x, y)
  
  results <- x

  #write.csv(x, file="../Data/SOTMPediatricQuality_raw.csv", row.names=FALSE)

  return(results)
}

