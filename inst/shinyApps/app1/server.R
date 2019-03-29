library(shiny)
library(magrittr)
library(raptools)

server <- function(input, output, session) {

  # html rendering function for re-use
  htmlRenderRmd <- function(srcFile) {
    # set param needed for report meta processing
    params <- list(tableFormat="html")
    system.file(srcFile, package="raptools") %>%
      knitr::knit() %>%
      markdown::markdownToHTML(.,
                               options = c('fragment_only',
                                           'base64_images',
                                           'highlight_code')) %>%
      shiny::HTML()
  }

  makeHist <- function(var, bins, makeTable = FALSE) {
    x    <- mtcars[[var]]
    bins <- seq(min(x), max(x), length.out = bins +1)
    t <- hist(x, breaks = bins, col = '#154ba2', border = 'white',
              main = paste("Fordeling av", var), xlab = var,
              ylab = "Antall")
    if (makeTable) {
      data.frame(GruppeMin=t$breaks[1:length(t$mids)],
                 GruppeMax=t$breaks[2:(length(t$mids)+1)], Antall=t$counts)
    } else {
      t
    }
  }

  output$formFarge <- renderUI({
    htmlRenderRmd("formOgFarge.Rmd")
  })

  output$sampleUcControl <- renderUI({
    selectInput(inputId = "sampleUc", label = "Sample user ctrl",
                choices = c("How", "it", "will", "look"))
  })

  output$distPlot <- renderPlot({
    makeHist(var = input$var, bins = input$bins)
  })

  output$distTable <- renderTable({
    makeHist(var = input$var, bins = input$bins, makeTable = TRUE)
  })

  output$vurdering2niva <- renderUI({
    htmlRenderRmd("vurdering2niva.Rmd")
  })

  output$distPlotMpg <- renderPlot({
    makeHist(var = "mpg", bins = input$binsMpg)
  })

  output$distTableMpg <- renderTable({
    makeHist(var = "mpg", bins = input$binsMpg, makeTable = TRUE)
  })

  output$distPlotHp <- renderPlot({
    makeHist(var = "hp", bins = input$binsHp)
  })

  output$distTableHp <- renderTable({
    makeHist(var = "hp", bins = input$binsHp, makeTable = TRUE)
  })

  output$distPlotWt <- renderPlot({
    makeHist(var = "wt", bins = input$binsWt)
  })

  output$distTableWt <- renderTable({
    makeHist(var = "wt", bins = input$binsWt, makeTable = TRUE)
  })

  output$vurdering3niva <- renderUI({
    htmlRenderRmd("vurdering3niva.Rmd")
  })
}
