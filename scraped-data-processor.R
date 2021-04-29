#' ---
#' title: "scraped-data-processor"
#' author: "JJayes"
#' date: "29/04/2021"
#' output: html_document
#' ---
#' 
## ----setup, include=FALSE-----------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

library(tidyverse)
library(glue)
library(janitor)

# knitr::purl("code/scraped-data-processor.Rmd", documentation = 2)


#' 
## -----------------------------------------------------------------------------------------------------------
df <- read.csv("data/latest/ads_latest.csv")

df <- df %>% 
  as_tibble() %>% 
  janitor::clean_names()

#' 
#' What do we need?
#' 
## -----------------------------------------------------------------------------------------------------------
df <- df %>% 
  mutate(make_model = glue("{make} {model}"),
         price = round(price),
         year = round(year)) %>% 
  select(title,
         price,
         make_model,
         province,
         kilometers,
         colour,
         year,
         ad_url,
         text)

#' 
#' Processing province
#' 
## -----------------------------------------------------------------------------------------------------------
df <- df %>% 
  mutate(province = str_replace(province, "-", " "),
         province = str_replace(province, "\\+", "-"),
         province = str_to_title(province))

#' 
#' 
## -----------------------------------------------------------------------------------------------------------
write.csv(df, "data/latest/ads_latest_clean.csv")

#' 
