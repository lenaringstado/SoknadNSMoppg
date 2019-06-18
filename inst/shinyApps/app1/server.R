library(shiny)
library(magrittr)
library(rapRegTemplate)

server <- function(input, output, session) {

  # Last inn data
  # regData <- getFakeRegData()

  # Gjenbrukbar funksjon for å bearbeide Rmd til html
  htmlRenderRmd <- function(srcFile, params = list()) {
    # set param needed for report meta processing
    # params <- list(tableFormat="html")
    system.file(srcFile, package="rapRegTemplate") %>%
      knitr::knit() %>%
      markdown::markdownToHTML(.,
                               options = c('fragment_only',
                                           'base64_images',
                                           'highlight_code')) %>%
      shiny::HTML()
  }



  # Veiledning
  output$veiledning <- renderUI({
    htmlRenderRmd("veiledning.Rmd")
  })


  # Figur og tabell
  ## Figur
  # output$distPlot <- renderPlot({
  #   makeHist(df = regData, var = input$var, bins = input$bins)
  # })

  ## Tabell
  # output$distTable <- renderTable({
  #   makeHist(df = regData, var = input$var, bins = input$bins, makeTable = TRUE)
  # })


  # Samlerapport
  ## vis
  output$samlerapport <- renderUI({
    htmlRenderRmd(srcFile = "samlerapport.Rmd",
                  params = list(var = input$varS, bins = input$binsS))
  })

  ## last ned
  output$downloadSamlerapport <- downloadHandler(
    filename = function() {
      "rapRegTemplateSamlerapport.html"
    },
    content = function(file) {
      srcFile <- normalizePath(system.file("samlerapport.Rmd",
                                           package = "rapRegTemplate"))
      tmpFile <- "tmpSamlerapport.Rmd"
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(srcFile, tmpFile, overwrite = TRUE)
      out <- rmarkdown::render(tmpFile,
                               output_format =  rmarkdown::html_document(),
                               params = list(var = input$varS,
                                             bins = input$binsS),
                               output_dir = tempdir())
      file.rename(out, file)
    }
  )


  # Abonnement
  ## rekative verdier for å holde rede på endringer som skjer mens
  ## applikasjonen kjører
  rv <- reactiveValues(
    subscriptionTab = rapbase::makeUserSubscriptionTab(session))

  ## lag tabell over gjeldende status for abonnement
  output$activeSubscriptions <- DT::renderDataTable(
    rv$subscriptionTab, server = FALSE, escape = FALSE, selection = 'none',
    options = list(dom = 't')
  )

  ## lag side som viser status for abonnement, også når det ikke finnes noen
  output$subscriptionContent <- renderUI({
    userName <- rapbase::getUserName(session)
    if (length(rv$subscriptionTab) == 0) {
      p(paste("Ingen aktive abonnement for", userName))
    } else {
      tagList(
        p(paste0("Aktive abonnement som sendes per epost til ", userName, ":")),
        DT::dataTableOutput("activeSubscriptions")
      )
    }
  })

  ## nye abonnement
  observeEvent (input$subscribe, {
    package <- "rapRegTemplate"
    owner <- getUserName(session)
    runDayOfYear <- rapbase::makeRunDayOfYearSequence(
      interval = input$subscriptionFreq
    )
    email <- "test@test.no" # need new function i rapbase
    if (input$subscriptionRep == "Samlerapport1") {
      synopsis <- "Automatisk samlerapport1"
      fun <- "samlerapport1Fun"
      paramNames <- c("p1", "p2")
      paramValues <- c("Alder", 1)

    }
    if (input$subscriptionRep == "Samlerapport2") {
      synopsis <- "Automatisk samlerapport2"
      fun <- "samlerapport2Fun"
      paramNames <- c("p1", "p2")
      paramValues <- c("BMI", 2)
    }
    rapbase::createAutoReport(synopsis = synopsis, package = package,
                              fun = fun, paramNames = paramNames,
                              paramValues = paramValues, owner = owner,
                              email = email, runDayOfYear = runDayOfYear)
    rv$subscriptionTab <- rapbase::makeUserSubscriptionTab(session)
  })

  ## slett eksisterende abonnement
  observeEvent(input$del_button, {
    selectedRepId <- strsplit(input$del_button, "_")[[1]][2]
    rapbase::deleteAutoReport(selectedRepId)
    rv$subscriptionTab <- rapbase::makeUserSubscriptionTab(session)
  })
}
