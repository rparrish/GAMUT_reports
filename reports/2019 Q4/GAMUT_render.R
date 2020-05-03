

GAMUT_render <- function(format = "pdf_document", program_name, quarter = "2019 Q4") {
        program <- program_name
        filename <- gsub(" ", "_", program_name)
        dag <- program_name

        rmarkdown::render("GAMUT_template.Rmd",
                          output_format = format,
                          #knit_root_dir = fs::path("reports", quarter),
                          output_dir = fs::path(here::here("reports", quarter, "output")),
                          #intermediates_dir = "intermediate",
                          clean = TRUE,
                          quiet = TRUE,
                          envir = new.env(),
                          output_file = paste0(filename, '.pdf')

        )
        # remove figures
        unlink("figures/*.pdf")
}
