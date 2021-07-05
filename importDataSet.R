library(readxl)
path <- "rugbyData.xlsx"
sheetnames <- excel_sheets(path)
mylist <- lapply(excel_sheets(path), read_excel, path = path)

# name the dataframes
names(mylist) <- sheetnames

rc14 <- read_excel(path = path, sheet = "RC14")
sixn1415 <- read_excel(path = path, sheet = "6N14-15")
euro1415 <- read_excel(path = path, sheet = "ECC14-15")
hc1314 <- read_excel(path = path, sheet = "HC13-14")
sr15 <- read_excel(path = path, sheet = "SR15")
