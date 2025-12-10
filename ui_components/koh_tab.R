# Koh ID89 Browser Tab Component
create_koh_tab <- function() {
  tabPanel(
    "Koh89 Classification",
    icon = icon("dna"),
    # 主内容
    uiOutput("signature_display")
  )
}
