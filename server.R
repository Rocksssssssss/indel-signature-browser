# ==============================================================================
# Server Definition for Indel Signature Browser
# This file orchestrates the server logic by sourcing modular components
# ==============================================================================

# Load all dependencies from central location
source("R/dependencies.R")
load_dependencies()

# Shiny options
options(shiny.fullstacktrace = TRUE)
options(shiny.error = function() {
  traceback(2)
})

# ==============================================================================
# Source modules in dependency order
# ==============================================================================

# 1. Configuration (no dependencies)
source("config.R")

# 2. Logging (depends on config)
source("server/logging.R")
init_logging(CONFIG)

# 3. Validation (depends on config, logging)
source("server/validation.R")

# 4. Helper functions (depends on config)
source("server/helpers.R")

# 5. Data loading (depends on config, logging, validation)
source("server/data_loading.R")

# 6. UI handlers (depend on data, helpers)
source("server/search_handlers.R")
source("server/signature_display.R")
source("server/id83_display.R")
source("server/event_handlers.R")

# Log startup
log_app_start(
  signature_count = length(signature_groups),
  id83_count = length(id83_groups)
)

# ==============================================================================
# Server Function
# ==============================================================================

server <- function(input, output, session) {
  log_info("New session started")

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

  # Log session end
  session$onSessionEnded(function() {
    log_info("Session ended")
  })
}
