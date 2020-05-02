


library(httr)


#curl -v -X POST --ciphers TLSv1 -o output   -H "Content-Type: multipart/form-data" -F "username=admin" -F "password=ucubu5tQAsdJ" -F "loc=1" -F "id=0" -F "recipients=rollie.parrish@gmail.com" -F "subject=testing curl" -F "message=testing curl gmail" -F "emailFrom=1" -F "expireDays=3" -F "file=AMPA Quality Metric DEFINITIONS V1.27.14.pdf" -F "submit=Send+It%21"   https://ampa.org/redcap/redcap_v6.2.2/SendIt/upload.php

url <- "https://ampa.org/redcap/plugins/sendit_api/sendit.php"
url <- "http://httpbin.org/post"

body <- list(username = "admin",
             password = "ucubu5tQAsdJ",
             loc = 1,
             id = 0,
             emailFrom = 1,
             recipients = "rollie.parrish@gmail.com",
             subject = "testing httr",
             message = "testing httr",
             expireDays = 1,
             file = upload_file("reports/2014 Q4/GAMUT_2014_Akron_Childrens.pdf"),
             submit = "Send+It%21"
            )
 r <- POST(url = url, body = body, encode = "multipart")

 content(r, "parsed")




 sendit <- function(recipients, filename, subject, message,
                    expireDays=7, emailFrom=1, url="http://httpbin.org/post",
                    username, password) {

     body <- list(username = username,
                  password = password,
                  id = 0,
                  emailFrom = 1,
                  recipients = recipients,
                  subject = subject,
                  message = message,
                  expireDays = 1,
                  file = upload_file(filename),
                  submit = "Send+It%21"
     )
     response <- POST(url = url, body = body, encode = "multipart")

     results <- content(response, as="text")#, type = "application/json")##, as = "json")
     results

 }


url <- "https://ampa.org/redcap/plugins/sendit_api/sendit.php"
username <- "admin"
password <- "ucubu5tQAsdJ"
subject  <- "testing sendit API"
message  <- "testing API"


test <- data.frame(emails = c("rollie.parrish@gmail.com", "rparrish@flightweb.com"),
                   file = c("GAMUT_2014_Akron_Childrens.pdf", "GAMUT_summary_AEL.pdf"))

log <- list()
for (row in 1:length(test$emails)) {
        response <-  sendit(username=username, password=password, subject=subject, message = message,
            recipient =  test$emails[row],
            expireDays = 1,
            file = paste0("reports/2014 Q4/", test$file[row]),
            url = url
            )
        log[[row]] <- fromJSON(response)
        cat(paste("Sent to:", test$emails[row]), "\n")
        Sys.sleep(60)

}

sendit_log <- as.data.frame(do.call(rbind, log))
sendit_log

