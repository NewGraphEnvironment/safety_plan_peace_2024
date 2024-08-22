
# just run this if we want latest util function.  Really just an example here
staticimports::import()

{
  rmarkdown::render(input = 'safety_plan.Rmd', output_file = 'docs/safety_plan.html')
  pagedown::chrome_print(input = 'safety_plan.Rmd', output = 'docs/safety_plan.pdf')

  # we want to seperately attach a map and a list of sites for DFO
  #
  ## trim up the file.  We ditch the last page only when there are references.


  pdftools::pdf_subset(paste0(getwd(), "/docs/application_moe_dfo.pdf"),
                       pages = 4, output = paste0(getwd(), "/docs/application_dfo_map.pdf"))

  # trim up the file.  We ditch the last page only when there are references.
  pdftools::pdf_subset(paste0(getwd(), "/docs/application_moe_dfo.pdf"),
                       pages = 5:8, output = paste0(getwd(), "/docs/application_dfo_site_list.pdf"))
}
