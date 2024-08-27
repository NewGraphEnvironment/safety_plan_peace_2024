my_kable <- function(dat, caption_text = '', font = font_set){
  dat %>%
    kable(caption = caption_text, booktabs = T) %>%
    kableExtra::kable_styling(c("condensed", "responsive"),
                              full_width = T,
                              font_size = font)
  # kableExtra::scroll_box(width = "100%", height = "500px")
}

##function to trim up sheet and get names (was previously source from altools package)
at_trim_xlsheet <- function(df, column_last = ncol(df)) {
  df %>%
    dplyr::select(1:column_last) %>% ##get rid of the extra columns.  should be more abstract
    # janitor::row_to_names(which.max(complete.cases(.))) %>%
    janitor::clean_names() %>%
    janitor::remove_empty(., which = "rows")
}



##this is for the pf projects - chooses the top row - untidy input!
at_trim_xlsheet2 <- function(df, column_last = ncol(df)) {
  df %>%
    dplyr::select(1:column_last) %>% ##get rid of the extra columns.  should be more abstract
    janitor::row_to_names(which.max(complete.cases(.))) %>%
    janitor::clean_names() %>%
    janitor::remove_empty(., which = "rows")
}

##function to import pscis info
import_pscis <- function(workbook_name = 'pscis_phase1.xlsm'){ ##new template.  could change file back to .xls
  sig_fig0 <- c('length_or_width_meters')
  sig_fig1 <- c('culvert_slope_percent', 'stream_width_ratio')
  sig_fig2 <- c('outlet_drop_meters')
  readxl::read_excel(path = paste0(getwd(),"/data/", workbook_name),
                     sheet = 'PSCIS Assessment Worksheet') %>%
    # purrr::set_names(janitor::make_clean_names(names(.))) %>%
    at_trim_xlsheet2() %>% ##recently added function above and pulled the altools package as it was a week link
    rename(date = date_of_assessment_yyyy_mm_dd) %>%
    mutate(date = janitor::excel_numeric_to_date(as.numeric(date))) %>%
    filter(!is.na(date)) %>%
    readr::type_convert() %>%  ##guess the type!!
    mutate(source = workbook_name) %>%
    mutate(across(all_of(sig_fig0), round, 0)) %>%
    mutate(across(all_of(sig_fig1), round, 1)) %>%
    mutate(across(all_of(sig_fig2), round, 2))
}

## add a line to the function to make the comments column wide enough
make_html_tbl <- function(df) {
  # df2 <- df %>%
  #   dplyr::mutate(`Image link` = cell_spec('crossing', "html", link = `Image link`))
  df2 <- select(df, -blue_line_key, -linear_feature_id, -lat, -long,
                -sub5, -name, -desc, -shape, -watershed_code_20k, watershed_code_50k,-color) %>%
    sf::st_drop_geometry() %>%
    janitor::remove_empty()
    #, -shape, -color, -label
  df %>%
    mutate(html_tbl = knitr::kable(df2, 'html', escape = F) %>%
             kableExtra::row_spec(0:nrow(df2), extra_css = "border: 1px solid black;") %>% # All cells get a border
             kableExtra::row_spec(0, background = "yellow") %>%
             kableExtra::column_spec(column = ncol(df2) - 1, width_min = '0.5in') %>%
             kableExtra::column_spec(column = ncol(df2), width_min = '4in')
    )
}


make_untidy_table <- function(d){
  d_prep <- d %>%
    tibble::rownames_to_column() %>%
    mutate(rowname = as.numeric(rowname),
           col_id = case_when(rowname <= ceiling(nrow(.)/2) ~ 1,
                              T ~ 2)) %>%
    select(-rowname)
  d1 <- d_prep %>%
    filter(col_id == 1) %>%
    select(-col_id)
  d1$row_match <- seq(1:nrow(d1))
  d2 <- d_prep %>%
    filter(col_id == 2) %>%
    select(-col_id) %>%
    purrr::set_names(nm = '-')
  d2$row_match <- seq(1:nrow(d2))
  ##join them together
  d_joined <- left_join(d1, d2, by = 'row_match') %>%
    select(-row_match)
}
