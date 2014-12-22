##
##
## send_email.R
## 
## Send an individual report by email
##
## Rollie Parrish
## 4/12/2014

## references
# http://stackoverflow.com/questions/4236368/how-to-apply-a-function-to-every-row-of-a-matrix-or-a-data-frame-in-r
# http://stackoverflow.com/questions/5330146/apply-a-function-to-each-row-in-a-data-frame-in-r?rq=1

install.packages("mailR", dep = T)

library(mailR)


old.recipients <- data.frame(Name = c("Apple", "Banana"),
                         Code = c("A", "B"),
                         Email = c("rollie.parrish@providence.org", "rparrish@flightweb.com")
                         
)


recipients <- read.csv("SOTMPQM_Demo/Data/provider_codes.csv")


email.body <- paste("Dear Dr. ", to.name, "\n\n",
"On behalf of the Providence Spokane Heart Institute Quality Committee, please see attached for the blinded PCI  Mortality & Bleeding Report by provider for Providence Sacred Heart.\n\n You are physician ", 
to.ID, 
".\n\n",

"This report was based on your 3 year PCI volume at PSHMC only and specifically does not include your cases at Deaconess Medical Center or any other hospital. If you interested in your PCI volumes and outcomes at any other facilities, you may access your ACC-NCDR Registry Data through the ACC Cardiosource Portal. 

This 5 page report consists of:

 - Pg 1. Definition of the cases examined (from all PHS hospitals 2009 Q3 – 2013 Q2)  
 - Pg.2  Variables and weight of ACC-NCDR risk model for mortality  
 - Pg.3  Variables and weight of ACC-NCDR risk model for bleeding (note that many of variables are similar to mortality)  
 - Pg.4  Risk-adjusted Observed/Expected mortality rates for each PSHMC PCI operator. Note that volume of cases for each operator is also listed.
 - Pg.5  Risk-adjusted Observed/Expected bleeding rates for each PSHMC PCI operator.  Bleeding complications include all patients who received blood or needed a procedure to repair a vascular complication as well as GI, retroperitoneal, GI, GU or other bleeding within 72 hours of the PCI.

Please let me or Dr. Ring know if you have any questions.

--
Rollie Parrish, RN, BSN
Clinical Effectiveness Coordinator | Performance Improvement
Providence Sacred Heart Medical Center | Spokane, WA
509.474.6542
")

mail <- function (to.address, to.name, to.ID) {
  send.mail(from = "rollie.parrish@providence.org",
            to = to.address,
            #to = c("undisclosed"),
            bcc = c("rollie.parrish@providence.org"),
            
            subject = "PCI  Mortality & Bleeding Report",
            body = email.body,
            #body = "test",
            smtp = list(host.name = "mail.ampa.org", port = 587, user.name = "rollie.parrish@ampa.org", passwd = "2wrzPdWyZkB8", ssl = TRUE),
            authenticate = TRUE,
            #attach.files = c("c:/Users/Rollie/Documents/AMPA/Projects/AMTQM/SOTMPQM_Demo/reports/PSHMC Individual PCI Operator Mortality and Bleeding Complication Report.pdf"),
            #file.names = c("PCI Mortality & Bleeding Complication Report.pdf"), # optional parameter
            #file.descriptions = c("PCI Mortality & Bleeding Complication Report.pdf"),
            send = TRUE)
}





x <- function(x) {
  #cat("Hello Mr", x["name"], "\nEmail is:", x["email"], "\n Your ID is: ", x["ID"],"\n\n\n")
  mail(to.address=x["Email"], to.name=x["Name"], to.ID=x["Code"])
  
}

#for (row in recipients)) {
  apply(recipients, 1, x)
#}
