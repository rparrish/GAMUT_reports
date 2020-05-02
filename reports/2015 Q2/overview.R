

## User status

library(redcapAPI)
library(dplyr)

source(".REDCap_config.R")

rcon <- redcapConnection(url = uri, token = GAMUT_token)

.GAMUT_users_raw <- exportUsers(rcon)

GAMUT_users <-
    .GAMUT_users_raw %>%
    filter(!is.na(data_access_group)) %>%
    select(email:data_access_group)


total_dags <-
    nlevels(as.factor(GAMUT_users$data_access_group))

total_expired <-
    sum(!is.na(GAMUT_users$expiration))


