
# just run this if we want latest util function.  Really just an example here
staticimports::import()

{
  rmarkdown::render(input = 'safety_plan.Rmd', output_file = 'docs/index.html')
  pagedown::chrome_print(input = 'safety_plan.Rmd', output = 'docs/safety_plan_sern-peace-fish-passage.pdf')

}
