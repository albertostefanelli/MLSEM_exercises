options(scipen=999)

# PACKAGE INSTALLING AND UPGRADING #
# install and load defined list of packages
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE,repos = c(
      CRAN = 'https://cran.rstudio.com',
      CRANextra = 'https://macos.rbind.io'
    )
    )
  sapply(pkg, require, character.only = TRUE)
}

list_of_required_pkg <- c(
  "dplyr",
  #'fastDummies',
  #"MplusAutomation",
  "naniar"
)

ipak(list_of_required_pkg)


#### WVS WAVE 7 ###

wvs7 <- readRDS("World_Values_Survey_Wave_7_Inverted_R_v1_6.rds", refhook = NULL)
wvs7$Country <-  sjlabelled::as_label(wvs7$B_COUNTRY)

wvs7na <- wvs7 %>% 
  replace_with_na_at("Q260", ~.x <0) %>%
  replace_with_na_at("Q31P", ~.x <0) %>% 
  replace_with_na_at("Q33P", ~.x <0)

wvs7na$female <- wvs7na$Q260

wvs7_mplus <- wvs7na %>% select(Country,
                              v2x_gender, 
                              female,
                              Q33P, # redistribution
                              Q31P # claiming benefit 
)

write_csv(wvs7_mplus, "wvs7_ex_1.csv")

## EX 2 ##

wvs7na <- wvs7 %>% 
  replace_with_na_at("Q182", ~.x <0) %>%
  replace_with_na_at("Q184", ~.x <0) %>% 
  replace_with_na_at("Q185", ~.x <0) %>% 
  replace_with_na_at("Q186", ~.x <0) %>% 
  replace_with_na_at("Q188", ~.x <0) %>% 
  replace_with_na_at("Q275", ~.x <0) %>% 
  replace_with_na_at("Q172P", ~.x <0)
  

wvs7_mplus <- wvs7na %>% select(Country,
                                #clfhrat,
                                Q182, # homo
                                #Q183, # prosti
                                Q184, # abortion 
                                Q185, # Divorce
                                Q186, # sex before 
                                Q188, # euthanasia 
                                Q275, # edu 
                                Q172P # often pray 
                                #Q193  # casual sex 
                                
)

wvs7_mplus$Country <- as.factor(wvs7_mplus$Country)

write_csv(wvs7_mplus, "wvs7_ex_2.csv")

