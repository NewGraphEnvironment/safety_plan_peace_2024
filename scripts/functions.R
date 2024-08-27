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


