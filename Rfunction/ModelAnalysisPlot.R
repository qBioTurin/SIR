if(!require(ggplot2)) install.packages("ggplot2")
if(!require(dplyr)) install.packages("dplyr")
if(!require(patchwork)) install.packages("patchwork")

library(dplyr)
library(ggplot2)
library(patchwork)

ModelAnalysisPlot=function(solverName_path,Stoch = F,print=T,ncol=2){
  
  trace <-read.csv(solverName_path,sep = "")
  n_sim_tot<-table(trace$Time)
  n_sim <- n_sim_tot[1]
  time_delete<-as.numeric(names(n_sim_tot[n_sim_tot!=n_sim_tot[1]]))
  
  if(length(time_delete)!=0) trace = trace[which(trace$Time!=time_delete),]
  
  trace$ID <- rep(1:n_sim[1],each = length(unique(trace$Time)) )
  NoindexPlaces=which( colnames(trace)%in% c("ID","Time"))
  trace.final <-  lapply(colnames(trace)[-NoindexPlaces],function(c){
    return(data.frame(V=trace[,c], ID = trace$ID,Time=trace$Time,Compartment=c ) )
  })
  trace.final <- do.call("rbind",trace.final)
#Create line plots
  l_plot_line=lapply(colnames(trace)[-NoindexPlaces],function(namecl,trace){
    return (ggplot( )+
              geom_line(data=trace,
                        aes(x=Time,y=get(namecl),group=ID))+
              theme(axis.text=element_text(size=18),
                    axis.title=element_text(size=20,face="bold"),
                    legend.text=element_text(size=18),
                    legend.title=element_text(size=20,face="bold"),
                    legend.position="right",
                    legend.key.size = unit(1.3, "cm"),
                    legend.key.width = unit(1.3,"cm") )+
              labs(x="Days", y=namecl))
    
  },trace)
  names(l_plot_line)=colnames(trace)[-NoindexPlaces]
  
  
  
  if(Stoch){
    meanTrace <- trace %>% group_by(Time) %>%
      summarise_at(colnames(trace)[-NoindexPlaces], mean)
    meanTrace.final <-  lapply(colnames(meanTrace)[-which( colnames(meanTrace)=="Time")],function(c){
      return(data.frame(V=unlist(meanTrace[,c]), Time=meanTrace$Time,Compartment=c ) )
    })
    
    meanTrace.final <- do.call("rbind",meanTrace.final)  
    plAll <-ggplot( )+
      geom_line(data=trace.final,
                aes(x=Time,y=V,group=ID))+
      geom_line(data=meanTrace.final,
                aes(x=Time,y=V,col="Mean"),
                linetype="dashed")+
      facet_grid(~Compartment)+
      theme(axis.text=element_text(size=15),
            axis.title=element_text(size=15,face="bold"),
            legend.text=element_text(size=18),
            legend.title=element_text(size=18,face="bold"),
            legend.position="bottom",
            legend.key.size = unit(1, "cm"),
            legend.key.width = unit(1,"cm") )+
      labs(x="Days", y="count")
    
    
    plAllMean <-ggplot( )+
      geom_line(data=meanTrace.final,
                aes(x=Time,y=V,col=Compartment),
                linetype="dashed")+
      theme(axis.text=element_text(size=18),
            axis.title=element_text(size=20,face="bold"),
            legend.text=element_text(size=18),
            legend.title=element_text(size=20,face="bold"),
            legend.position="right",
            legend.key.size = unit(1.3, "cm"),
            legend.key.width = unit(1.3,"cm") )+
      labs(x="Days", y="Mean")
    
#Create Histograms    
    l_plot_hist=lapply(colnames(trace)[-NoindexPlaces],function(namecl,trace){    
    return (ggplot(trace[trace$Time==max(trace$Time),])+
      geom_histogram(aes(get(namecl)))+
      theme(axis.text=element_text(size=18),
            axis.title=element_text(size=20,face="bold"),
            legend.text=element_text(size=18),
            legend.title=element_text(size=20,face="bold"),
            legend.position="right",
            legend.key.size = unit(1.3, "cm"),
            legend.key.width = unit(1.3,"cm") )+labs(x=namecl))
    },trace)
    names(l_plot_hist)=colnames(trace)[-NoindexPlaces]
    
#Adding mean in the line plot
    l_plot_line_mean=lapply(colnames(trace)[-NoindexPlaces],function(namecl,meanTrace){ 
      return (l_plot_line[[namecl]]+  geom_line(data=meanTrace,
                                                aes(x=Time,y=get(namecl),col="Mean"),
                                                linetype="dashed")+
                labs(x="Days", y=namecl,col=""))
    },meanTrace)  

    names(l_plot_line_mean)=colnames(trace)[-NoindexPlaces]
    
    (all_plot_line_mean=wrap_plots(l_plot_line_mean,ncol = ncol))
    (all_plot_hist=wrap_plots(l_plot_hist,ncol = ncol))
    if (print){
      print(all_plot_line_mean)
      print(all_plot_hist)
    }
    return(c(all_plot_line_mean,all_plot_hist))
  }else{
    all_plot_line=wrap_plots(l_plot_line,ncol = ncol)
    if (print){
      print( all_plot_line)
    }
    return(all_plot_line)
  }
}
