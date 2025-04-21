#devtools::load_all()
for(i in fs::dir_ls("data-raw/")){
  print(i)
  source(i)
}
