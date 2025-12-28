# ==============================================================================
# Signature Display (89-Type Classification)
# This module handles the 89-type signature display rendering
# ==============================================================================

# Render the 89-type signature display
render_signature_display <- function(input, output, current_group) {

  output$signature_display <- renderUI({
    if (is.null(current_group())) {
      # Grid view - show all signatures
      fluidRow(
        lapply(names(signature_groups), function(group_name) {
          if (is.null(signature_groups[[group_name]])) {
            return(NULL)
          }
          sig <- signature_groups[[group_name]]
          thumb <- sig$thumbnail

          column(
            3,
            div(
              class = "thumbnail-card",
              actionLink(
                inputId = paste0("show_", group_name),
                label = tagList(
                  h4(
                    group_name,
                    style = "color:#2c3e50;font-weight:bold;margin-top:0;"
                  ),
                  if (!is.null(thumb) && file.exists(file.path("www", thumb))) {
                    tags$img(
                      src = thumb,
                      style = "width:100%; max-width:200px; height:auto;border-radius:5px; transition: transform 0.2s;"
                    )
                  } else {
                    div(
                      style = "height:120px; line-height:120px; color:#95a5a6;",
                      icon("image", style = "font-size:48px;")
                    )
                  }
                ),
                style = "text-decoration: none;color: inherit; display: block; cursor:pointer;"
              )
            )
          )
        })
      )
    } else {
      # Detail view - show selected signature
      sig <- signature_groups[[current_group()]]
      show_types <- input$show_types %||% c("ID89", "ID83", "ID476")
      current_selection <- if (is.null(input$show_types)) {
        c("ID89", "ID83", "ID476")
      } else {
        input$show_types
      }

      id89_imgs <- if ("ID89" %in% show_types) sig$imgs else character(0)
      id83_imgs <- if ("ID83" %in% show_types) sig$id83 else character(0)
      id476_imgs <- if ("ID476" %in% show_types) sig$id476 else character(0)

      id89_imgs <- id89_imgs[!is.na(id89_imgs) & nzchar(id89_imgs)]
      id83_imgs <- id83_imgs[!is.na(id83_imgs) & nzchar(id83_imgs)]
      id476_imgs <- id476_imgs[!is.na(id476_imgs) & nzchar(id476_imgs)]

      tagList(
        actionButton(
          "back_to_list",
          "\u2190 Back to List",
          class = "btn-back",
          style = "margin-bottom:20px;"
        ),
        h2(
          current_group(),
          style = "color:#2c3e50; font-weight:600; margin-bottom:25px;"
        ),

        div(
          style = "margin-bottom: 20px; padding: 15px; background: #f8f9fa; border-radius:5px; border: 1px solid #e9ecef;",
          checkboxGroupInput(
            "show_types",
            "Select signature types to display:",
            choices = c(
              "Koh89" = "ID89",
              "83-Type" = "ID83",
              "476-type" = "ID476"
            ),
            selected = current_selection,
            inline = TRUE
          )
        ),

        if (
          !is.null(sig$aetiology) &&
            !is.na(sig$aetiology) &&
            nchar(sig$aetiology) > 0
        ) {
          div(
            style = "background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%); padding:20px; border-radius:12px; margin-bottom:25px; border-left:5px solid #2ecc71; box-shadow: 0 2px 8px rgba(0,0,0,0.1);",
            div(
              style = "display:flex; align-items:center; margin-bottom:10px;",
              icon(
                "lightbulb",
                style = "font-size:24px; color:#27ae60; margin-right:12px;"
              ),
              tags$span(
                style = "font-size:16px; color:#27ae60; font-weight:700; text-transform:uppercase; letter-spacing:1px;",
                "Proposed Aetiology"
              )
            ),
            tags$p(
              style = "font-size:16px; color:#2c3e50; line-height:1.8; margin:0;",
              sig$aetiology
            )
          )
        },

        # 89-Type Signature
        if (
          length(id89_imgs) >= 1 && file.exists(file.path("www", id89_imgs[1]))
        ) {
          div(
            class = "img-container",
            div(class = "img-section-title", "89-Type Signature"),
            div(class = "img-label", "Signature"),
            tags$img(
              src = id89_imgs[1],
              class = "signature-img",
              style = "max-width:700px; width:100%;",
              onclick = sprintf(
                "Shiny.setInputValue('%s', new Date().getTime());",
                paste0("img_", id89_imgs[1])
              )
            )
          )
        },

        # Sample Spectrums
        if (length(id89_imgs) > 1) {
          div(
            class = "img-container",
            div(
              class = "img-section-title",
              "Example tumor spectrum with this signature"
            ),
            p(
              class = "text-muted",
              style = "margin-top: -8px; margin-bottom: 12px; color:#6c757d; font-size: 12px;",
              "Click an image to view details. Samples A is the example tumor spectrum; Sample B is the partial spectrum contributed by all other signatures; Sample A-B is the difference."
            ),
            fluidRow(
              lapply(seq_along(id89_imgs[-1]), function(i) {
                nm <- c("A", "B", "A-B")[i]
                imgnm <- id89_imgs[-1][i]
                column(
                  4,
                  div(class = "img-label", paste("Sample", nm)),
                  tags$img(
                    src = imgnm,
                    class = "signature-img",
                    style = "max-width:100%; width:100%;",
                    onclick = sprintf(
                      "Shiny.setInputValue('%s', new Date().getTime());",
                      paste0("img_", imgnm)
                    )
                  )
                )
              })
            )
          )
        },

        # 83-Type
        if (length(id83_imgs) > 0) {
          div(
            class = "img-container",
            div(class = "img-section-title", "83-Type Signature"),
            if (
              length(id83_imgs) >= 1 &&
                file.exists(file.path("www", id83_imgs[1]))
            ) {
              tagList(
                div(class = "img-label", "Siganture Spectrum"),
                tags$img(
                  src = id83_imgs[1],
                  class = "signature-img",
                  style = "max-width:700px; width:100%; margin-bottom:25px;",
                  onclick = sprintf(
                    "Shiny.setInputValue('%s', new Date().getTime());",
                    paste0("img_", id83_imgs[1])
                  )
                )
              )
            },
            if (
              length(id83_imgs) >= 2 &&
                file.exists(file.path("www", id83_imgs[2]))
            ) {
              tagList(
                div(class = "img-label", "Sample A in 83-Type representation"),
                tags$img(
                  src = id83_imgs[2],
                  class = "signature-img",
                  style = "max-width:700px; width:100%;",
                  onclick = sprintf(
                    "Shiny.setInputValue('%s', new Date().getTime());",
                    paste0("img_", id83_imgs[2])
                  )
                )
              )
            }
          )
        },

        # 476-type
        if (
          length(id476_imgs) >= 1 &&
            file.exists(file.path("www", id476_imgs[1]))
        ) {
          div(
            class = "img-container",
            div(class = "img-section-title", "476-type Signature"),
            div(class = "img-label", "Extended Signature Set"),
            p(
              style = "font-size: 13px; color: #7f8c8d; margin-top: -5px; margin-bottom: 10px;",
              icon("mouse-pointer"),
              " Right-click and open in new tab for full view"
            ),
            tags$img(
              src = id476_imgs[1],
              class = "signature-img",
              style = "max-width:100%; width:100%;",
              onclick = sprintf(
                "Shiny.setInputValue('%s', new Date().getTime());",
                paste0("img_", id476_imgs[1])
              )
            )
          )
        },

        if (!is.null(sig$desc)) {
          div(
            style = "background:#fff3cd; border-left:4px solid #ffc107; padding:15px; border-radius:8px; margin-top:20px;",
            icon("info-circle"),
            " ",
            sig$desc
          )
        }
      )
    }
  })
}
