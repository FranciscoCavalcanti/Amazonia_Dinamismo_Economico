############################################################
##
##
############################################################

# call packages
library(tidyverse)
library(haven)
library(tibble)
library(zoo)
library(datazoom.social)
library(ggplot2)
library(plotly)

#################################################
## Ocupações na Amazônia Legal
## Ouput data from:
## Dinamismo Economico na Amazonia
## github: https://github.com/FranciscoCavalcanti/Amazonia_Dinamismo_Economico
#################################################

# set path to raw data
user_folder_path <- "C:/Users/Francisco/Dropbox/Datazoom/" # set actual user data path
github_folder_path <- "Amazonia_Dinamismo_Economico/build/output/"  # set github structure path 

# call raw data
base1 <- read_dta(paste0(user_folder_path, github_folder_path, "_amz_ac_numero_ocupados_por_ocupacao_2digitos.dta"))
base1 <- base1 %>% mutate(UF = "AC")
base2 <- read_dta(paste0(user_folder_path, github_folder_path, "_amz_am_numero_ocupados_por_ocupacao_2digitos.dta"))
base2 <- base2 %>% mutate(UF = "AM")
base3 <- read_dta(paste0(user_folder_path, github_folder_path, "_amz_ap_numero_ocupados_por_ocupacao_2digitos.dta"))
base3 <- base3 %>% mutate(UF = "AP")
base4 <- read_dta(paste0(user_folder_path, github_folder_path, "_amz_ma_numero_ocupados_por_ocupacao_2digitos.dta"))
base4 <- base4 %>% mutate(UF = "MA")
base5 <- read_dta(paste0(user_folder_path, github_folder_path, "_amz_mt_numero_ocupados_por_ocupacao_2digitos.dta"))
base5 <- base5 %>% mutate(UF = "MT")
base6 <- read_dta(paste0(user_folder_path, github_folder_path, "_amz_pa_numero_ocupados_por_ocupacao_2digitos.dta"))
base6 <- base6 %>% mutate(UF = "PA")
base7 <- read_dta(paste0(user_folder_path, github_folder_path, "_amz_ro_numero_ocupados_por_ocupacao_2digitos.dta"))
base7 <- base7 %>% mutate(UF = "RO")
base8 <- read_dta(paste0(user_folder_path, github_folder_path, "_amz_rr_numero_ocupados_por_ocupacao_2digitos.dta"))
base8 <- base8 %>% mutate(UF = "RR")
base9 <- read_dta(paste0(user_folder_path, github_folder_path, "_amz_to_numero_ocupados_por_ocupacao_2digitos.dta"))
base9 <- base9 %>% mutate(UF = "TO")
base10 <- read_dta(paste0(user_folder_path, github_folder_path, "_numero_ocupados_por_ocupacao_2digitos.dta"))
base10 <- base10 %>% mutate(UF = "TOTAL")

# append all data 
temp <- rbind(base1, base2, base3,base4,base5,base6,base7,base8,base9, base10)

# remove rows with missing data 
temp <- na.omit(temp)
temp <- temp %>%
  filter(titulo !="")

# convert time data to quarterly
temp <- temp %>% 
  mutate(time = paste0(temp$Ano, "-",temp$Trimestre))
temp$time <- as.Date(as.yearqtr(temp$time))
temp$Trimestre <- NULL
temp$Ano <- NULL

# groups at the level: Estado e Ocupações
temp$group <- paste0(temp$UF," - ", temp$titulo)

# change column order
temp <-  temp %>% 
  relocate(group, time)

# Paleta de cores
pallete_discrete <- c("#fcff84","#ffcf48" ,"#c3ff83","#007e47","#00596d","#4fdf94","#99b0c8","#261c4e","#000098","#c368b1","#60458c","#757575")
pallete_continuous <- c("#440154","#481567" ,"#453781","#404788","#39568c","#33638d","#287d8e","#238a8d","#1f968b","#20a387","#29af7f","#3cbb75","#55c667","#73d055","#95d840","#b8de29","#dce319","#fde725") # Viridis

# Define paleta de cores
pallete <- pallete_discrete

# Fontes
f1 <- list(family = "Roboto", size = 14, color = "rgb(0, 0, 0)")
f2 <- list(family = "Roboto", size = 13, color = "rgb(0, 0, 0)")


# Fontes
f1 <- list(family = "Roboto", size = 14, color = "rgb(0, 0, 0)")
f2 <- list(family = "Roboto", size = 13, color = "rgb(0, 0, 0)")


inst1 <- temp %>%
  group_by(temp$group) %>%
  filter(group == temp$group[2] | group == temp$group[3]) %>%
  mutate(aux1 = first(n_ocu_cod),
         y_option = (n_ocu_cod/aux1)*100)  %>%
  select(time, y_option, group)
  

fig_p <- plot_ly(inst1, 
        x = inst1$time, 
        y = inst1$y_option,
        color = inst1$group,
        type = "scatter",
        mode = "lines",
        colors = pallete #maybe delete
        )

# Layout eixos
x_axis_layout <- list(
  title = "asdasd",
  titlefont = f1,
  tickfont = f2,
  automargin = FALSE,
  autorange = TRUE,
  showgrid = FALSE,
  zeroline = FALSE
)

y_axis_layout <- list(
  title =  "asdasd",
  titlefont = f1,
  tickfont = f2,
  automargin = FALSE,
  autorange = TRUE,
  showgrid = FALSE,
  zeroline = FALSE
)
    
# Aplica layout
fig_p <- fig_p %>% 
  layout(
    title = "Variação Trimestral",
    font = f1,
    xaxis = x_axis_layout,
    yaxis = y_axis_layout,
    showlegend = TRUE
  )

fig_p