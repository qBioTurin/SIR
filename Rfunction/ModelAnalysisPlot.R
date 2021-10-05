library(dplyr)
library(ggplot2)

ModelAnalysisPlot=function(Stoch = F,print=T){
  
  trace <-read.csv("./results_model_analysis/model_analysis-1.trace",sep = "")
  n_sim_tot<-table(trace$Time)
  n_sim <- n_sim_tot[1]
  time_delete<-as.numeric(names(n_sim_tot[n_sim_tot!=n_sim_tot[1]]))
  
  if(length(time_delete)!=0) trace = trace[which(trace$Time!=time_delete),]
  
  trace$ID <- rep(1:n_sim[1],each = length(unique(trace$Time)) )
  
  
  plI<-ggplot( )+
    geom_line(data=trace,
              aes(x=Time,y=I,group=ID))+
    theme(axis.text=element_text(size=18),
          axis.title=element_text(size=20,face="bold"),
          legend.text=element_text(size=18),
          legend.title=element_text(size=20,face="bold"),
          legend.position="right",
          legend.key.size = unit(1.3, "cm"),
          legend.key.width = unit(1.3,"cm") )+
    labs(x="Days", y="I")
  
  plS<-ggplot( )+
    geom_line(data=trace,
              aes(x=Time,y=S,group=ID))+
    theme(axis.text=element_text(size=18),
          axis.title=element_text(size=20,face="bold"),
          legend.text=element_text(size=18),
          legend.title=element_text(size=20,face="bold"),
          legend.position="right",
          legend.key.size = unit(1.3, "cm"),
          legend.key.width = unit(1.3,"cm") )+
    labs(x="Days", y="S")
  
  plR<-ggplot( )+
    geom_line(data=trace,
              aes(x=Time,y=R,group=ID))+
    theme(axis.text=element_text(size=18),
          axis.title=element_text(size=20,face="bold"),
          legend.text=element_text(size=18),
          legend.title=element_text(size=20,face="bold"),
          legend.position="right",
          legend.key.size = unit(1.3, "cm"),
          legend.key.width = unit(1.3,"cm") )+
    labs(x="Days", y="R")
  
  if(Stoch){
    plIdens<-ggplot(trace[trace$Time==max(trace$Time),])+
      geom_histogram(aes(I))+
      theme(axis.text=element_text(size=18),
            axis.title=element_text(size=20,face="bold"),
            legend.text=element_text(size=18),
            legend.title=element_text(size=20,face="bold"),
            legend.position="right",
            legend.key.size = unit(1.3, "cm"),
            legend.key.width = unit(1.3,"cm") )
    
    plSdens<-ggplot(trace[trace$Time==max(trace$Time),])+
      geom_histogram(aes(S))+
      theme(axis.text=element_text(size=18),
            axis.title=element_text(size=20,face="bold"),
            legend.text=element_text(size=18),
            legend.title=element_text(size=20,face="bold"),
            legend.position="right",
            legend.key.size = unit(1.3, "cm"),
            legend.key.width = unit(1.3,"cm") )
    
    plRdens<-ggplot(trace[trace$Time==max(trace$Time),])+
      geom_histogram(aes(R))+
      theme(axis.text=element_text(size=18),
            axis.title=element_text(size=20,face="bold"),
            legend.text=element_text(size=18),
            legend.title=element_text(size=20,face="bold"),
            legend.position="right",
            legend.key.size = unit(1.3, "cm"),
            legend.key.width = unit(1.3,"cm") )
    
    meanTrace <- trace %>% group_by(Time) %>%
      summarise(S=mean(S),I=mean(I),R=mean(R))
    
    plI<-plI+
      geom_line(data=meanTrace,
                aes(x=Time,y=I,col="Mean"),
                linetype="dashed")+
      labs(x="Days", y="I",col="")
    
    plS<-plS+
      geom_line(data=meanTrace,
                aes(x=Time,y=S,col="Mean"),
                linetype="dashed")+
      labs(x="Days", y="S",col="")
    
    plR<-plR+
      geom_line(data=meanTrace,
                aes(x=Time,y=R,col="Mean"),
                linetype="dashed")+
      labs(x="Days", y="R",col="")
    
    ListReturn<-list(plS = plS,plI = plI,plR = plR,
                HistS = plSdens,HistI = plIdens,HistR = plRdens)
  }else{
    ListReturn<-list(plS = plS,plI = plI,plR = plR)
  }
  
  if(print){
    for(j in 1:length(ListReturn))
      print(ListReturn[j])
  }
  
  return(ListReturn)
}

