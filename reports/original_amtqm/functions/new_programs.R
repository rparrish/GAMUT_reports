##
## new_programs.R
## 
## creates the .csv files for bulk importing new programs, users, and records
##
## Rollie Parrish
## 1/05/2014

## parameters
## Need to get the max of group_id automatically
start_group_id <- 20 # as.numeric(readline("What is the first group_id number:>>> "))
project_id <- 21 #as.numeric(readline("What is the project ID number:>>> "))
  
## get requests
new_requests <- rc_export("00B1E2A1A750DFFADAD2490B4B7F9345")

## remove apostrophe's from program_name
new_requests$program_name <- gsub("[^\\w\\s]", "", new_requests$program_name, perl = TRUE)

## redcap_data_access_groups.csv
redcap_data_access_groups <- data.frame(project_id="21",
                                        group_name=new_requests$program_name
                                        )


## redcap_user_rights.csv

redcap_user_rights <- data.frame(project_id=project_id, 
                                 username=new_requests$email,
                                 role_id=10,  # data entry
                                 group_id=seq(from=start_group_id,
                                              to=(start_group_id + length(new_requests$program_name) - 1),
                                                  by=1
                                              )
)

## UserImport.csv
UserImport <- data.frame(username=new_requests$email,
                         first_name=new_requests$first_name, 
                         last_name=new_requests$last_name, 
                         email=new_requests$email
)


## RecordImport.csv
redcap_dag <- function(x) {
  x <- tolower(x) # change to lowercase
  x <- gsub(" ", "_", x) # replace spaces with '_'
  x <- substr(x, 1, 18) # take the first 18 characters
  
  return(x)
}

RecordImport <- data.frame(program_name = new_requests$program_name,
                           redcap_event_name = "demographics_arm1",
                           redcap_data_access_group = redcap_dag(new_requests$program_name),
                           location = new_requests$city,
                           site_information_complete = 1
)


## Save .csv files

folder <- "../SOTMPQM_Demo/Data/New_Program_Import/"

## phpMyAdmin files
# write.csv2 uses a ';' for field separator character, which is the default for phpMyAdmin

write.csv2(redcap_data_access_groups, 
          file=paste0(folder,"phpMyAdmin/", "redcap_data_access_groups.csv"),
          row.names=FALSE
)

write.csv2(redcap_user_rights, 
           file=paste0(folder,"phpMyAdmin/", "redcap_user_rights.csv"),
           row.names=FALSE
)


## REDCap Control Center files
write.table(UserImport, 
           file=paste0(folder,"REDCap_CC/", "UserImport.csv"),
          col.names=c("Username", "First Name", "Last Name", "Email"),
          row.names=FALSE,
          sep=","
)


write.csv(RecordImport, 
          file=paste0(folder,"REDCap_CC/", "RecordImport.csv"),
          row.names=FALSE
)








                                 #
                                 ## default values                                 
#                                  expiration=NULL,
#                                  lock_record=0,
#                                  lock_record_multiform=0,
#                                  lock_record_customize=0,
#                                  data_export_tool=0,
#                                  data_import_tool=0,
#                                  data_comparison_tool=0,
#                                  data_logging=0,
#                                  file_repository=0,
#                                  double_data=0,
#                                  user_rights=0,
#                                  data_access_groups=0,
#                                  graphical=0,
#                                  reports=0,
#                                  design=0,
#                                  calendar=0,
#                                  data_entry=NULL,
#                                  api_token=NULL,
#                                  api_export=0,
#                                  api_import=0,
#                                  record_create=0,
#                                  record_rename=0,
#                                  record_delete=0,
#                                  dts=0,
#                                  participants=0,
#                                  data_quality_design=0,
#                                  data_quality_execute=1,
#                                  data_quality_resolution=1,
#                                  random_setup=0,
#                                  random_dashboard=0,
#                                  random_perform=0


