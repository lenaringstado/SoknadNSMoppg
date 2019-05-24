library(shiny)
library(rapbase)

addResourcePath('rap', system.file('www', package='rapbase'))
regTitle = "rapRegTemplate"

ui <- tagList(
  navbarPage(
    title = div(img(src="rap/logo.svg", alt="Rapporteket", height="26px"),
                regTitle),
    windowTitle = regTitle,
    theme = "rap/bootstrap.css",

    tabPanel("Veiledning",
      mainPanel(width = 12,
        htmlOutput("veiledning", inline = TRUE),
        appNavbarUserWidget(user = uiOutput("appUserName"),
                            organization = uiOutput("appOrgName"))
      )
    ),
    tabPanel("Figur og tabell"
      # ,
      # sidebarLayout(
      #   sidebarPanel(width = 3,
      #     selectInput(inputId = "var",
      #                 label = "Variabel:",
      #                 c("mpg", "disp", "hp", "drat", "wt", "qsec")),
      #     sliderInput(inputId = "bins",
      #                 label = "Antall grupper:",
      #                 min = 1,
      #                 max = 10,
      #                 value = 5)
      #   ),
      #   mainPanel(
      #     tabsetPanel(
      #       tabPanel("Figur", plotOutput("distPlot")),
      #       tabPanel("Tabell", tableOutput("distTable"))
      #     )
      #   )
      # )
    ),
    tabPanel("Samlerapport"
        # ,
        # tabPanel("Fordeling av mpg",
        #   sidebarLayout(
        #     sidebarPanel(width = 3,
        #       selectInput(inputId = "varS",
        #                   label = "Variabel:",
        #                   c("mpg", "disp", "hp", "drat", "wt", "qsec")),
        #       sliderInput(inputId = "binsS",
        #                   label = "Antall grupper:",
        #                   min = 1,
        #                   max = 10,
        #                   value = 5),
        #       downloadButton("downloadSamlerapport", "Last ned!")
        #     ),
        #     mainPanel(
        #       uiOutput("samlerapport")
        #     )
        #   )
        # )
      ),
    tabPanel("Abonnement"
      # ,
      # sidebarLayout(
      #   sidebarPanel(width = 3,
      #     selectInput("subscriptionRep", "Rapport:", c("Samlerapport1", "Samlerapport2")),
      #     selectInput("subscriptionFreq", "Frekvens:",
      #                 list(Årlig="year", Kvartalsvis="quarter", Månedlig="month", Ukentlig="week", Daglig="DSTday"),
      #                 selected = "month"),
      #     actionButton("subscribe", "Bestill!")
      #   ),
      #   mainPanel(
      #     uiOutput("subscriptionContent")
      #   )
      # )
    )

  ) # navbarPage
) # tagList
