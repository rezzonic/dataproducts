require(rCharts)

top500 <- read.table("top500-summary.txt",header=TRUE)
ddate<-as.Date(paste(as.character(top500$mdate),"-01",sep=""))
dates<- as.Date(paste(levels(top500$mdate),"-01",sep=""))
top500 <- data.frame(mdate=ddate,rank=top500$Rank,RMax=top500$RMax)
mins <- tapply(top500$RMax,top500$mdate,min)
maxs <- tapply(top500$RMax,top500$mdate,max)

shinyServer(
  function(input, output) {
    RMax <- reactive(as.numeric(input$freq)*as.numeric(input$cores)*as.numeric(input$arch)*input$eff/100)
    df <- reactive(
        data.frame(dates=dates,mins=mins,maxs=maxs,isTop500=(mins<=RMax()))
    )
    
    output$yourflops <- renderText(as.numeric(input$freq)*as.numeric(input$cores)*as.numeric(input$arch))
    output$yourRMax <- renderText(RMax())

    output$flopsPlot <- renderPlot({
      	plot(df()$dates, df()$maxs, col=rgb(0,0,1,1-0.5*as.integer(df()$isTop500)),
           log='y',ylim=c(min(top500$RMax),max(top500$RMax)),pch=16, xlab="year", ylab="RMax [GFLOPs]")
	      points(df()$dates, df()$mins, col=rgb(0,0.5,1,1-0.375*as.integer(df()$isTop500)),pch=17)
        legend('topleft',legend=c("1st","500th"), col=c(rgb(0,0,1),rgb(0,0.5,1)), pch=16:17, bty='n')
        abline(h=RMax())
        text(x=tail(df()$dates,1),y=RMax(), labels="you", pos=3)
	})
  
    tmprank <- reactive(
      with(top500[top500$RMax<=RMax(),],aggregate(rank,by=list(mdate),min))
      )
    
    output$rank <- renderTable(include.rownames=FALSE,
      data.frame(date=strftime(tmprank()[,1],"%B %Y"),rank=tmprank()[,2])
      )
  }
)
