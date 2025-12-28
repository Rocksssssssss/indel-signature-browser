# ==============================================================================
# ID83 Display (83-Type Classification)
# This module handles the 83-type signature display rendering
# ==============================================================================

# Render the 83-type signature display
render_id83_display <- function(input, output, current_id83) {

  output$id83_display <- renderUI({
    if (is.null(current_id83())) {
      # Grid view - show all ID83 groups
      all_names <- names(id83_groups)
      if (length(all_names) == 0) {
        return(NULL)
      }

      # Group into rows of 4
      chunk_size <- 4
      id_chunks <- split(all_names, ceiling(seq_along(all_names) / chunk_size))

      tagList(
        lapply(id_chunks, function(chunk_names) {
          fluidRow(
            style = "margin-bottom: 20px;",
            lapply(chunk_names, function(id83_name) {
              id83_info <- id83_groups[[id83_name]]
              members_text <- paste(id83_info$members, collapse = ", ")
              thumbnail_path <- id83_info$thumbnail

              column(
                3,
                div(
                  class = "thumbnail-card",
                  style = "background: #fff; border: 1px solid #ddd; border-radius: 8px; padding: 15px; height: 280px; overflow-y: auto; box-shadow: 0 2px 5px rgba(0,0,0,0.05); transition: box-shadow 0.3s;",
                  onmouseover = "this.style.boxShadow='0 5px 15px rgba(0,0,0,0.2)'",
                  onmouseout = "this.style.boxShadow='0 2px 5px rgba(0,0,0,0.05)'",

                  actionLink(
                    inputId = paste0("show_id83_", id83_name),
                    label = tagList(
                      h4(
                        id83_name,
                        style = "color:#27ae60; margin-top:0; font-weight:700; text-align: center;"
                      ),

                      div(
                        style = "height: 150px; display: flex; align-items: center; justify-content: center; margin-bottom: 10px; background: #f9f9f9; border-radius: 4px;",
                        if (
                          !is.null(thumbnail_path) &&
                            length(thumbnail_path) > 0 &&
                            file.exists(file.path("www", thumbnail_path))
                        ) {
                          tags$img(
                            src = thumbnail_path,
                            style = "max-height: 100%; max-width: 100%; border-radius: 4px;"
                          )
                        } else {
                          div(
                            style = "color:#ccc; text-align: center;",
                            icon(
                              "image",
                              style = "font-size:32px; display: block;"
                            ),
                            tags$small("No Image")
                          )
                        }
                      ),

                      div(
                        style = "background:#f4f6f7; padding:8px; border-radius:4px; text-align:left;",
                        div(
                          style = "font-size:11px; color:#7f8c8d; margin-bottom:5px; font-weight:bold;",
                          "Corresponds to:"
                        ),
                        div(
                          style = "font-size:12px; color:#34495e; line-height:1.4;",
                          members_text
                        )
                      )
                    ),
                    style = "text-decoration: none; color: inherit; display: block;"
                  )
                )
              )
            })
          )
        })
      )
    } else {
      # Detail view - show selected ID83 group
      id83_info <- id83_groups[[current_id83()]]
      members <- id83_info$members
      id83_all_img <- id83_info$id83_all

      tagList(
        actionButton(
          "back_to_id83_list",
          "\u2190 Back to ID83 List",
          class = "btn-back",
          style = "margin-bottom:20px;"
        ),
        h2(
          paste("ID83:", current_id83()),
          style = "color:#27ae60; font-weight:600; margin-bottom:25px;"
        ),

        # ID83 Signature image
        div(
          class = "id83-section",
          div(class = "id83-label", icon("layer-group"), " Signature"),
          if (
            !is.null(id83_all_img) &&
              length(id83_all_img) > 0 &&
              file.exists(file.path("www", id83_all_img))
          ) {
            tags$img(
              src = id83_all_img,
              class = "signature-img",
              style = "max-width:700px; width:100%;",
              onclick = sprintf(
                "Shiny.setInputValue('%s', new Date().getTime());",
                paste0("img_", id83_all_img)
              )
            )
          } else {
            div(
              style = "color:#95a5a6; text-align:center; padding:40px;",
              icon("image", style = "font-size:48px;"),
              br(),
              "No image available"
            )
          }
        ),

        # Member details
        div(
          class = "id83-section",
          div(
            class = "id83-label",
            icon("dna"),
            " Corresponding 89-Type Signatures"
          ),
          lapply(members, function(member_name) {
            sig <- signature_groups[[member_name]]
            if (is.null(sig)) {
              return(NULL)
            }

            koh89_spectrum <- if (length(sig$imgs) >= 1) sig$imgs[1] else NULL
            koh89_sampleA <- if (length(sig$imgs) >= 2) sig$imgs[2] else NULL
            cosmic83_filtered <- if (length(sig$id83) >= 2) {
              sig$id83[2]
            } else {
              NULL
            }

            div(
              class = "member-section",
              div(
                class = "member-name",
                icon("chevron-right"),
                " ",
                member_name
              ),

              # Aetiology
              if (
                !is.null(sig$aetiology) &&
                  !is.na(sig$aetiology) &&
                  nchar(sig$aetiology) > 0
              ) {
                div(
                  style = "background:#fff3cd; padding:12px; border-radius:6px; margin-bottom:15px; border-left:3px solid #ffc107;",
                  tags$strong(
                    style = "color:#856404; font-size:12px;",
                    icon("lightbulb"),
                    " Proposed Aetiology: "
                  ),
                  tags$span(
                    style = "color:#856404; font-size:13px;",
                    sig$aetiology
                  )
                )
              },

              # Member images
              fluidRow(
                if (
                  !is.null(koh89_spectrum) &&
                    file.exists(file.path("www", koh89_spectrum))
                ) {
                  column(
                    4,
                    div(class = "img-label", "89-Type Signature"),
                    tags$img(
                      src = koh89_spectrum,
                      class = "signature-img",
                      style = "width:100%;",
                      onclick = sprintf(
                        "Shiny.setInputValue('%s', new Date().getTime());",
                        paste0("img_", koh89_spectrum)
                      )
                    )
                  )
                },
                if (
                  !is.null(koh89_sampleA) &&
                    file.exists(file.path("www", koh89_sampleA))
                ) {
                  column(
                    4,
                    div(class = "img-label", "Koh89 Sample A"),
                    tags$img(
                      src = koh89_sampleA,
                      class = "signature-img",
                      style = "width:100%;",
                      onclick = sprintf(
                        "Shiny.setInputValue('%s', new Date().getTime());",
                        paste0("img_", koh89_sampleA)
                      )
                    )
                  )
                },
                if (
                  !is.null(cosmic83_filtered) &&
                    file.exists(file.path("www", cosmic83_filtered))
                ) {
                  column(
                    4,
                    div(class = "img-label", "Sample A (83-Type)"),
                    tags$img(
                      src = cosmic83_filtered,
                      class = "signature-img",
                      style = "width:100%;",
                      onclick = sprintf(
                        "Shiny.setInputValue('%s', new Date().getTime());",
                        paste0("img_", cosmic83_filtered)
                      )
                    )
                  )
                }
              )
            )
          })
        )
      )
    }
  })
}
