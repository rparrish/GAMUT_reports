

GAMUT_render <- function(format = "html_document") {
        program <- program_name
        filename <- gsub(" ", "_", program_name)
        dag <- program_name

        rmarkdown::render("GAMUT_template.Rmd",
                          output_format = format,
                          #intermediates_dir = "intermediate",
                          clean = TRUE,
                          #envir = new.env(),
                          output_file =paste0('GAMUT_2015Q4_', filename, '.html')
        )
}
