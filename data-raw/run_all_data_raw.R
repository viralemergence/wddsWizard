#devtools::load_all()

for(i in fs::dir_ls("data-raw/")){
  print(i)
  if(i == "data-raw/run_all_data_raw.R"){
    next()
  }
  source(i)
}
