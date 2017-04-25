library(shiny)
library(XML)
library(RCurl)

server <- function(input, output) {
  output$view <- renderUI({
    data = list()
    i = 1
    # http://images.mangafreak.net/mangas/one_piece/one_piece_863/one_piece_863_19.jpg
    urlx = paste(
      "http://images.mangafreak.net/mangas/one_piece/one_piece_",
      input$n,
      "/one_piece_",
      input$n,
      "_",
      sep = ""
    )
    for (p in 1:30)
    {
      url = paste(urlx, p, ".jpg", sep = "")
      if (!url.exists(url))
      {
        # break
        # due to server restriction is better not check the exist url :sad
      }
      url.list = url
      data[[i]] = tags$img(src = url.list,
                           width = 600,
                           heigth = 600)
      i = i + 1
      data[[i]] = br()
      i = i + 1
    }
    data
  })
}

ui <- fluidPage(titlePanel("Baca Komik - One Piece"),
                sidebarLayout(
                  sidebarPanel(
                    sliderInput(
                      "n",
                      "Chapter:",
                      min = 700,
                      max = 863,
                      value = 853
                    ),
                    submitButton("Get Comics")
                    
                  ),
                  mainPanel(htmlOutput("view"))
                ))

shinyApp(ui = ui, server = server)
