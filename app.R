library(shiny)
library(XML)
library(RCurl)

server <- function(input, output) {
  cid <- reactive({
    switch(input$comic,
           "海賊王" = 2,
           "獵人" = 10,
           "火影忍者" = 1)
  })
  
  URLInput <- reactive({
    url=""
    if(input$type == "Volume")
    {
      if (input$n<10)
      {
        url=paste("http://manhua.fzdm.com/",cid(),"/Vol_00",input$n,sep="")
      }
      else
      {
        url=paste("http://manhua.fzdm.com/",cid(),"/Vol_0",input$n,sep="")
      }
    }
    else
    {
      url=paste("http://manhua.fzdm.com/",cid(),"/",input$n,sep="")
    }
    url
  })
  
  output$view <- renderUI({
    urlx=URLInput()
    urlt =paste(urlx,"/index_0.html",sep="")
    if (!url.exists(urlt))
    {
      h1(paste("Error : Please check ",input$type," number."))
    }
    else
    {
      data = list()
      range=120
      i=1
      if (input$type=="Chapter")
      {
        range=25
      }
      for (p in 0:range)
      {
        url =paste(urlx,"/index_",p,".html",sep="")
        if (!url.exists(url))
        {
          break
        }
        html = htmlParse(getURL(url,ssl.verifypeer = FALSE))
        url.list = xpathSApply(html, "//li/a/img[@src]", xmlAttrs)
        data[[i]]=tags$img(src=url.list[1],width=500,heigth=500)
        i=i+1
        data[[i]]=br()
        i=i+1
      }
      data
    }
  })
}

ui <- fluidPage(
  titlePanel("Comic Viewer"),  
  sidebarLayout(
    sidebarPanel(
      selectInput("comic", "Choose a Comic:", 
                  choices = c("海賊王", "獵人", "火影忍者")),      
      
      helpText("Ref : http://manhua.fzdm.com/"),
      radioButtons("type", "Select Type:", choices = c( "Volume","Chapter"),"Chapter"),
      sliderInput("n", "Number:", min=1, max=1000, value=828),
      submitButton("Get Comics")
      
    ),    
    mainPanel(     
      htmlOutput("view")
    )
  )
)

shinyApp(ui = ui, server = server)
