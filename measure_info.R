

measure_ID <- c("AAM-1", "AAM-2", "AAM-3",
                "INT-1a", "INT-2a",
                "INT-1b", "INT-2b",
                "INT-1c", "INT-2c",
                "INT-3")

measure_short <- c("Mechanical Ventilation - All",
                   "Waveform Capnography - All",
                   "Confirmed Tracheal Tube Placement - All",
                   "First intubation attempt success - Neonatal",
                   "DASH-1A - Neonatal",
                   "First intubation attempt success - Pediatric",
                   "DASH-1A - Pediatric",
                   "First intubation attempt success - Adult",
                   "DASH-1A - Adult",
                   "RSI Protocol Compliance"
                   )

measure_numerator <- c("adv_airway_ventilator",
                       "adv_airway_wave_capno",
                       "adv_airway_tt_confirmed",
                       "intub_neo_first_success",
                       "intub_neo_no_hypoxia",
                       "intub_ped_first_success",
                       "intub_ped_no_hypoxia",
                       "intub_adult_first_success",
                       "intub_adult_no_hypoxia",
                       "intub_rsi_compliant"
                       )

measure_denominator <- c("adv_airway_cases",
                         "adv_airway_cases",
                         "adv_airway_cases",
                         "intub_neo_attempts",
                         "intub_neo_attempts",
                         "intub_ped_attempts",
                         "intub_ped_attempts",
                         "intub_adult_attempts",
                         "intub_adult_attempts",
                         "intub_rsi_cases"
                         )


measure_info <- data_frame(measure_ID,
                           measure_short,
                           measure_numerator,
                           measure_denominator)

write.csv(measure_info, file="data/measure_info.csv", row.names=FALSE)
