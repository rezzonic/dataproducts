library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("How would your computer rank among the fastest computers in the world?"),
  sidebarPanel(
    p(HTML("<b>Frequency</b>. This is the frequency of your processor, in GHz. 
           Check <a href=\"http://www.wikihow.com/Check-CPU-Speed\">here</a> for a howto.")),
    p(HTML("<b>Number of cores</b>. The number of cores of your machine")),
    p(HTML("<b>Architecture</b>. <a href=\"http://en.wikipedia.org/wiki/Sandy_bridge\">Sandy 
Bridge</a> was available 2011. When looking up the frequency, you can see the CPU model.
           This <a href=\"http://ark.intel.com/\">Intel website</a> lets you look it up. If
<i>Instruction Set Extension</i> contains AVX, then it's Sandy Bridge or newer.")),
    p(HTML("<b>Efficiency</b>. Just take a wild guess on this one! Values between 80 and 95 are
          within reasonable reach.")),
    textInput('freq', 'Frequency [GHz]',value = 1.4),
    textInput('cores', 'Number of cores', value=2),
    selectInput("arch", "Architecture:",
                c("Before Sandy Bridge" = "4",
                  "Sandy Bridge or better" = "8")),
    sliderInput('eff', 'Estimated efficiency [%]',value = 90, min = 50, max = 100, step = 1)
  ),
  mainPanel(
    p("Moore's law implies that computing power doubles every 18 months.
      It is then reasonable to think that the computer you're using now has the power of
      a supercomputer a couple of years ago."),
    p("The goal of this application is to show how your computer would have 
      ranked since the nineties."),
   h2("Results"),
   p("Peak performance of your computer in GFLOPs"),
   verbatimTextOutput("yourflops"),
   p("Estimated RMax of your computer in GFLOPs"),
   verbatimTextOutput("yourRMax"),
   p("Your computer compared to the 500 most powerful computers in the world, over time"),  
   plotOutput('flopsPlot'),
   p("Your computer's rank in the Top500, over time"),     
   tableOutput('rank'),
   h2("Appendix: how FLOPs are calculated"),
   p("The theoretical peak performance is calculated by multiplying the frequency of the
     CPU by the number of cores and then by the number of operations per clock cycle."),
   p("A Sandy Bridge or newer processors executes 8 operations per clock cycle, whereas
     older Intel architecture, only 4. For the sake of simplicity, we do not account in this
     project for non-Intel general purpose chips."),
   p(HTML("For this project, we estimate RMax with the efficiency slider. The machines in the Top500
     have their RMax measured with the <a href=\"http://www.netlib.org/benchmark/hpl/\">HPL benchmark</a> ")),
   h2("References"),
   p(HTML("Data is taken from <a href=\"http://www.top500.org\">The Top500</a> website."))
  )
))
