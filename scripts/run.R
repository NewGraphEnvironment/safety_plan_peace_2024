
# just run this if we want latest util function.  Really just an example here
staticimports::import()


###!!!!!!!!!!!!!!!!! was getting a buid failyre with chrome print so need to create a dummy favicon.ico file in the main directory (`touch favicon.ico` in terminal)
{
  rmarkdown::render(input = 'safety_plan.Rmd', output_file = 'docs/index.html')
  pagedown::chrome_print(input = 'safety_plan.Rmd', output = 'docs/safety_plan_sern-peace-fish-passage.pdf')

}
