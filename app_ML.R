# app.R 
library(shiny)
library(shinydashboard)
library(shinyjs)

# ---------------- 数据定义 ----------------


# ---------------- UI ----------------
source("./ui.R")

# ---------------- Server ----------------
source("./server.R")

shinyApp(ui, server)