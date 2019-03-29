
library(shiny)
library(rapbase)

addResourcePath('rap', system.file('www', package='rapbase'))
regTitle = "rapRegTemplate"

# Define UI for application that draws a histogram
ui <- tagList(
  navbarPage(
    title = div(img(src="rap/logo.svg", alt="Rapporteket", height="26px"),
                regTitle),
    windowTitle = regTitle,
    theme = "rap/bootstrap.css",

    tabPanel("Veiledning",
      sidebarLayout(
        sidebarPanel(width = 3,
          textInput(inputId="test", label="Eksempel", value = "Hvasomhelst")
        ),
        mainPanel(
          htmlOutput("formFarge", inline = TRUE)
        )
      )
    ),
    tabPanel("Figur og tabell",
      sidebarLayout(
        sidebarPanel(width = 3,
          selectInput(inputId = "var",
                      label = "Variabel:",
                      c("mpg", "disp", "hp", "drat", "wt", "qsec")),
          sliderInput(inputId = "bins",
                      label = "Antall grupper:",
                      min = 1,
                      max = 10,
                      value = 5)
        ),
        mainPanel(
          tabsetPanel(
            tabPanel("Figur", plotOutput("distPlot")),
            tabPanel("Tabell", tableOutput("distTable")),
            tabPanel("Vurdering",
                     htmlOutput("vurdering2niva", inline = TRUE))
          )
        )
      )
    ),
    tabPanel("Samlerapport",
        tabPanel("Fordeling av mpg",
          sidebarLayout(
            sidebarPanel(width = 3,
              sliderInput(inputId = "binsMpg",
                          label = "Antall grupper:",
                          min = 1,
                          max = 10,
                          value = 5)
            ),
            mainPanel(
              tabsetPanel(
                tabPanel("Figur", plotOutput("distPlotMpg")),
                tabPanel("Tabell", tableOutput("distTableMpg"))
              )
            )
          )
        )
      ),
    tabPanel("Abonnement",
      sidebarLayout(
        sidebarPanel(),
        mainPanel()
      )
    ),
    tags$script(HTML("var header = $('.navbar> .container-fluid');
                       header.append('<div class=\"navbar-brand\" style=\"float:right\"><img src=\"rap/logo.svg\", alt=\"Rapporteket\", style=\"float:right;height:26px\"></div>');
                       console.log(header)"))

  ) # navbarPage
) # tagList
