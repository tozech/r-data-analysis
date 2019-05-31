require(xlsx)
require(dplyr)
library(tidyr)

gathering = function(df){
  tmp_df = df %>% filter(!is.na(from...to..count.)) 
  rows = tmp_df %>% select(from...to..count.)
  colnames(tmp_df) = c('Stimulus', 'from', as.character(unlist(df[1,-c(1:2)])))
  df_gat = gather(tmp_df, Formel, Text, Bild, CoverStory, 'White Space', key="to", value="value")
  return(df_gat)
}

read_sheet = function(sheetName){
  fname = 'data/TransitionMatrix.xlsx'
  df = read.xlsx(fname, sheetName = sheetName)
  df_fil = df %>% filter(!is.na(from...to..count.)) #dplyr conform, with pipes
  grps = df %>% group_by(Stimulus) #%>% reshape(idvar = c(""))
  # Test case for one table
  df_fil = df %>% filter(Stimulus == 'BeispieleOhneAbweichung_Reihenfolgeirgendwie Page 2')
  df_gat = gathering(df_fil)
  # Try for all tables
  df_all = grps %>% gathering %>% mutate(sheetName)
return(df_all)
}

#Test case for one sheet
df_all_223 = read_sheet("223")

#For a list of cheets
sheetNames = c("223", "220")
data <- do.call("rbind", lapply(sheetNames, read_sheet))
                