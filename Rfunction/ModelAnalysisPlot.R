
library(ggplot2)

ModelAnalysisPlot=function(Ref = FALSE,Stoch = F){

  trace <-read.csv("./results_model_analysis/model_analysis-1.trace",sep = "")
  n_sim_tot<-table(trace$Time)
  n_sim <- n_sim_tot[1]
  time_delete<-as.numeric(names(n_sim_tot[n_sim_tot!=n_sim_tot[1]]))
  
  if(length(time_delete)!=0) trace = trace[which(trace$Time!=time_delete),]
  
  trace$ID <- rep(1:n_sim[1],each = length(unique(trace$Time)) )


plI<-ggplot( )+
  geom_line(data=trace,
            aes(x=Time/7,y=I,group=ID))+
  theme(axis.text=element_text(size=18),
        axis.title=element_text(size=20,face="bold"),
        legend.text=element_text(size=18),
        legend.title=element_text(size=20,face="bold"),
        legend.position="right",
        legend.key.size = unit(1.3, "cm"),
        legend.key.width = unit(1.3,"cm") )+
  labs(x="Weeks", y="I")

plS<-ggplot( )+
  geom_line(data=trace,
            aes(x=Time/7,y=S))+
  theme(axis.text=element_text(size=18),
        axis.title=element_text(size=20,face="bold"),
        legend.text=element_text(size=18),
        legend.title=element_text(size=20,face="bold"),
        legend.position="right",
        legend.key.size = unit(1.3, "cm"),
        legend.key.width = unit(1.3,"cm") )+
  labs(x="Weeks", y="S")

plR<-ggplot( )+
  geom_line(data=trace,
            aes(x=Time/7,y=R))+
  theme(axis.text=element_text(size=18),
        axis.title=element_text(size=20,face="bold"),
        legend.text=element_text(size=18),
        legend.title=element_text(size=20,face="bold"),
        legend.position="right",
        legend.key.size = unit(1.3, "cm"),
        legend.key.width = unit(1.3,"cm") )+
  labs(x="Weeks", y="R")

if(Ref){
  
  reference <- as.data.frame(read.csv("Input/reference_data.csv",
                                      header = FALSE,
                                      sep = ""))
  plI<-plI+
    geom_line(data=reference,
              aes(x=V1/7,y=V3),
              col="red",linetype="dashed")+
    labs(x="Weeks", y="I",col="Distance")
  
  plS<-plS+
    geom_line(data=reference,
              aes(x=V1/7,y=V2),
              col="red",linetype="dashed")+
    labs(x="Weeks", y="S",col="Distance")
  
  plR<-plR+
    geom_line(data=reference,
              aes(x=V1/7,y=V4),
              col="red",linetype="dashed")+
    labs(x="Weeks", y="R",col="Distance")
  
}

if(Stoch){
  plIdens<-ggplot(trace[trace$Time==max(trace$Time),])+
    geom_boxplot(aes(I))+
    theme(axis.text=element_text(size=18),
          axis.title=element_text(size=20,face="bold"),
          legend.text=element_text(size=18),
          legend.title=element_text(size=20,face="bold"),
          legend.position="right",
          legend.key.size = unit(1.3, "cm"),
          legend.key.width = unit(1.3,"cm") )
  
  plSdens<-ggplot(trace[trace$Time==max(trace$Time),])+
    geom_histogram(aes(S,group=ID))+
    theme(axis.text=element_text(size=18),
          axis.title=element_text(size=20,face="bold"),
          legend.text=element_text(size=18),
          legend.title=element_text(size=20,face="bold"),
          legend.position="right",
          legend.key.size = unit(1.3, "cm"),
          legend.key.width = unit(1.3,"cm") )
  
  plRdens<-ggplot(trace[trace$Time==max(trace$Time),])+
    geom_histogram(aes(R,group=ID))+
    theme(axis.text=element_text(size=18),
          axis.title=element_text(size=20,face="bold"),
          legend.text=element_text(size=18),
          legend.title=element_text(size=20,face="bold"),
          legend.position="right",
          legend.key.size = unit(1.3, "cm"),
          legend.key.width = unit(1.3,"cm") )
  
  return(list(plS = plS,plI = plI,plR = plR,
              HistS = plSdens,HistI = plIdens,HistR = plRdens))
}else{
  return(list(plS = plS,plI = plI,plR = plR))
}

}

