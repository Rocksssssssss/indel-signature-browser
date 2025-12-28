# ==============================================================================
# Server Definition for Indel Signature Browser
# This file orchestrates the server logic by sourcing modular components
# ==============================================================================

library(shiny)
library(shinyjs)
library(shinydashboard)
library(readxl)
library(dplyr)
library(tidyr)
library(data.table)

options(shiny.fullstacktrace = TRUE)
options(shiny.error = function() {
  traceback(2)
})

# Source all server modules
source("server/data_loading.R")
source("server/search_handlers.R")
source("server/signature_display.R")
source("server/id83_display.R")
source("server/event_handlers.R")

# ==============================================================================
# Server Function
# ==============================================================================

server <- function(input, output, session) {
  # Remove active class from sidebar menu
  observe({
    runjs("$('.sidebar-menu li').removeClass('active');")
  })

  # Reactive values for current selections
  current_group <- reactiveVal(NULL)
  current_id83 <- reactiveVal(NULL)

  # Initialize all handlers
  init_search_handlers(input, output, session, current_group, current_id83)
  init_event_handlers(input, output, session, current_group, current_id83)

  # Render displays
  render_signature_display(input, output, current_group)
  render_id83_display(input, output, current_id83)
}
