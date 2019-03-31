library(shiny)
library(magrittr)
library(rapRegTemplate)

server <- function(input, output, session) {

  # html rendering function for re-use
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
  output$formFarge <- renderUI({
    htmlRenderRmd("formOgFarge.Rmd")
  })

  # Figur og tabell
  ## Figur
  output$distPlot <- renderPlot({
    makeHist(df = mtcars, var = input$var, bins = input$bins)
  })

  ## Table
  output$distTable <- renderTable({
    makeHist(df = mtcars, var = input$var, bins = input$bins, makeTable = TRUE)
  })

  ## Vurdering
  output$vurdering2niva <- renderUI({
    htmlRenderRmd("vurdering2niva.Rmd")
  })

  # Samlerapport
  output$samlerapport <- renderUI({
    htmlRenderRmd(srcFile = "samlerapport.Rmd",
                  params = list(var = input$varS, bins = input$binsS))
  })


  # Abonnement
  ## reactive values to track subscriptions changes
  rv <- reactiveValues(subscriptionTab = rapbase::makeUserSubscriptionTab(session))

  ## render current subscriptions
  output$activeSubscriptions <- DT::renderDataTable(
    rv$subscriptionTab, server = FALSE, escape = FALSE, selection = 'none',
    options = list(dom = 't')
  )

  ## do not render a table when no subscriptions
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

  ## new subscription
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

  ## remove existing subscription
  observeEvent(input$del_button, {
    selectedRepId <- strsplit(input$del_button, "_")[[1]][2]
    rapbase::deleteAutoReport(selectedRepId)
    rv$subscriptionTab <- rapbase::makeUserSubscriptionTab(session)
  })
}
