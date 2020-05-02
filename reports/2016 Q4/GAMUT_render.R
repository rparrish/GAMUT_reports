

GAMUT_render <- function(format = "pdf_document", program_name) {
        program <- program_name
        filename <- gsub(" ", "_", program_name)
        dag <- program_name

        rmarkdown::render("GAMUT_template.Rmd",
                          output_format = format,
                          #intermediates_dir = "intermediate",
                          clean = TRUE,
                          envir = new.env(),
                          output_file =paste0('GAMUT_2016Q4_', filename, '.pdf')

        )
        # remove figures
        unlink("figures/*.pdf")
}
