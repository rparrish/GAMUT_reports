
# Load needed libraries
# --> NOTE: RCurl is dependent on bitops
library(bitops)
library(RCurl)

# Set secret token specific to your REDCap project
secret_token = 'C212EB36C4A8347D35690465E350E6C3'

# Set the url to the api (ex. https://YOUR_REDCAP_INSTALLATION/api/)
api_url = 'https://ampa.org/redcap/api/'

curl_handle = getCurlHandle()
curlSetOpt(ssl.verifypeer = FALSE, curl = curl_handle)
## Read all data from REDCap
y <- postForm(api_url,
              token = secret_token,
              content = 'user',
              format = 'csv',
              returnFormat = 'csv',
              curl = curl_handle)


# Use the output from postForm() to create a data frame of the exported data
x <- read.table(file = textConnection(y), header = TRUE, sep = ",", na.strings = "",
                stringsAsFactors = FALSE)
rm(secret_token, y)

## Alternative code:
write(y, file = "data_file.csv");
x <- read.csv("data_file.csv", sep = ",", header = TRUE, na.strings = "")



user2 <- c(NA,1,1,1,1,1,1,1,1,1,1,1,1,1)
user3 <- c(NA,2,1,1,1,1,1,1,1,1,1,1,1)
