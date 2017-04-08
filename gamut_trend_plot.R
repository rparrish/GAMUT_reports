
gamut_trend_plot <- function(metric = "AA-1c", freeze = 12) {
    legacy_programs <-
        runchart_data %>%
        #filter(adv_airway_tt_confirmed <= adv_airway_tt_cases) %>%
        #filter(alt_ment_bg_checks <= alt_ment_cases) %>%
        #filter(ped_adv_airway_capno <= ped_adv_airway_cases) %>%
        filter(intub_adult_no_hypoxia <= intub_adult_attempts) %>%
        group_by(program_name) %>%
        tally(sort = TRUE) %>%
        filter(n == 36)

    legacy_data <-
        runchart_data %>%
        semi_join(legacy_programs)
    #
    legacy_trend <-
        legacy_data %>%
        select(month, starts_with("intub_adult"))  %>%
        group_by(month) %>%
        dplyr::summarise(
            num = sum(intub_adult_no_hypoxia, na.rm = TRUE),
            den = sum(intub_adult_attempts, na.rm = TRUE),
            rate = round(num/den,2))

    results <- paste("hello", metric)
    return(results)
}
