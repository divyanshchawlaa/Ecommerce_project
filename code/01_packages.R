# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Install if missing
install.packages(c("tidyverse","lubridate","skimr","janitor","rstatix","broom",
                   "ggpubr","caret","pROC","car","gridExtra"))

# Load packages
library(readr)
library(tidyverse)
library(lubridate)
library(skimr)
library(janitor)
library(rstatix)
library(broom)
library(ggpubr)
library(caret)
library(pROC)
library(car)
library(gridExtra)

