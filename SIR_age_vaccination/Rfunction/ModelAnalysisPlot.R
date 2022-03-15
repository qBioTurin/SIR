library(dplyr)
library(ggplot2)

ModelAnalysisPlot=function(trace_path,Stoch = F,print=T){

	trace <-read.csv(trace_path,sep = "")
	n_sim_tot<-table(trace$Time)
	n_sim <- n_sim_tot[1]
	time_delete<-as.numeric(names(n_sim_tot[n_sim_tot!=n_sim_tot[1]]))

	if(length(time_delete)!=0) trace = trace[which(trace$Time!=time_delete),]

	trace$ID <- rep(1:n_sim[1],each = length(unique(trace$Time)) )

	trace.final <-  lapply(colnames(trace)[-which( colnames(trace)%in% c("ID","Time"))],function(c){
		return(data.frame(V=trace[,c], ID = trace$ID,Time=trace$Time,Compartment=c ) )
	})
	trace.final <- do.call("rbind",trace.final)

	colors <- c("a1" = "red", "a2" = "orange")

	mean_trace_I_a1 <- aggregate(trace$I_a1, list(trace$Time), FUN=mean)
	mean_trace_I_a2 <- aggregate(trace$I_a2, list(trace$Time), FUN=mean)

	plI<-ggplot( )+
		geom_line(data=trace,
							aes(x=Time, y=I_a1, group=ID, color="a1"))+
		geom_line(data=trace,
							aes(x=Time, y=I_a2, group=ID, color="a2"))+
		scale_color_manual(values = colors)+
		theme(axis.text=element_text(size=18),
					axis.title=element_text(size=20,face="bold"),
					legend.text=element_text(size=18),
					legend.title=element_text(size=20,face="bold"),
					legend.position="right",
					legend.key.size = unit(1.3, "cm"),
					legend.key.width = unit(1.3,"cm") )+
		labs(x="Days", y="I", color="Age class")

	plS<-ggplot( )+
		geom_line(data=trace,
							aes(x=Time,y=S_a1,group=ID))+
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
							aes(x=Time,y=R_a1,group=ID))+
		theme(axis.text=element_text(size=18),
					axis.title=element_text(size=20,face="bold"),
					legend.text=element_text(size=18),
					legend.title=element_text(size=20,face="bold"),
					legend.position="right",
					legend.key.size = unit(1.3, "cm"),
					legend.key.width = unit(1.3,"cm") )+
		labs(x="Days", y="R")

	if(Stoch){
		meanTrace <- trace %>% group_by(Time) %>%
			summarise(S_a1=mean(S_a1),S_a2=mean(S_a2),I_a1=mean(I_a1),I_a2=mean(I_a2),R_a1=mean(R_a1),R_a2=mean(R_a2))

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
			labs(x="Days", y="Population")


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
			labs(x="Days", y="Mean Population")

		plI_a1dens<-ggplot(trace[trace$Time==max(trace$Time),])+
			geom_histogram(aes(I_a1), binwidth = 1)+
			theme(axis.text=element_text(size=18),
						axis.title=element_text(size=20,face="bold"),
						legend.text=element_text(size=18),
						legend.title=element_text(size=20,face="bold"),
						legend.position="right",
						legend.key.size = unit(1.3, "cm"),
						legend.key.width = unit(1.3,"cm") )

		plI_a2dens<-ggplot(trace[trace$Time==max(trace$Time),])+
			geom_histogram(aes(I_a2), binwidth = 1)+
			theme(axis.text=element_text(size=18),
						axis.title=element_text(size=20,face="bold"),
						legend.text=element_text(size=18),
						legend.title=element_text(size=20,face="bold"),
						legend.position="right",
						legend.key.size = unit(1.3, "cm"),
						legend.key.width = unit(1.3,"cm") )

		plS_a1dens<-ggplot(trace[trace$Time==max(trace$Time),])+
			geom_histogram(aes(S_a1), binwidth = 1)+
			theme(axis.text=element_text(size=18),
						axis.title=element_text(size=20,face="bold"),
						legend.text=element_text(size=18),
						legend.title=element_text(size=20,face="bold"),
						legend.position="right",
						legend.key.size = unit(1.3, "cm"),
						legend.key.width = unit(1.3,"cm") )

		plS_a2dens<-ggplot(trace[trace$Time==max(trace$Time),])+
			geom_histogram(aes(S_a2), binwidth = 1)+
			theme(axis.text=element_text(size=18),
						axis.title=element_text(size=20,face="bold"),
						legend.text=element_text(size=18),
						legend.title=element_text(size=20,face="bold"),
						legend.position="right",
						legend.key.size = unit(1.3, "cm"),
						legend.key.width = unit(1.3,"cm") )

		plR_a1dens<-ggplot(trace[trace$Time==max(trace$Time),])+
			geom_histogram(aes(R_a1), binwidth = 1)+
			theme(axis.text=element_text(size=18),
						axis.title=element_text(size=20,face="bold"),
						legend.text=element_text(size=18),
						legend.title=element_text(size=20,face="bold"),
						legend.position="right",
						legend.key.size = unit(1.3, "cm"),
						legend.key.width = unit(1.3,"cm") )

		plR_a2dens<-ggplot(trace[trace$Time==max(trace$Time),])+
			geom_histogram(aes(R_a2), binwidth = 1)+
			theme(axis.text=element_text(size=18),
						axis.title=element_text(size=20,face="bold"),
						legend.text=element_text(size=18),
						legend.title=element_text(size=20,face="bold"),
						legend.position="right",
						legend.key.size = unit(1.3, "cm"),
						legend.key.width = unit(1.3,"cm") )

		plI<-plI+
			geom_line(data=meanTrace,
								aes(x=Time,y=I_a1),
								color="black",
								linetype="dotted")+
			geom_line(data=meanTrace,
								aes(x=Time,y=I_a2),
								color="black",
								linetype="dotted")+
			labs(x="Days", y="I")

		plS<-plS+
			geom_line(data=meanTrace,
								aes(x=Time,y=S_a1,col="Mean"),
								linetype="dashed")+
			geom_line(data=meanTrace,
								aes(x=Time,y=S_a2,col="Mean"),
								linetype="dashed")+
			labs(x="Days", y="S",col="")

		plR<-plR+
			geom_line(data=meanTrace,
								aes(x=Time,y=R_a1,col="Mean"),
								linetype="dashed")+
			geom_line(data=meanTrace,
								aes(x=Time,y=R_a2,col="Mean"),
								linetype="dashed")+
			labs(x="Days", y="R",col="")

		ListReturn<-list(plS = plS,plI = plI,plR = plR,
										 HistS_a1 = plS_a1dens,HistS_a2 = plS_a2dens,
										 HistI_a1 = plI_a1dens,HistI_a2 = plI_a2dens,
										 HistR_a1 = plR_a1dens,HistR_a2 = plR_a2dens,
										 plAll=plAll,plAllMean=plAllMean)
	}else{
		plAll <-ggplot( )+
			geom_line(data=trace.final,
								aes(x=Time,y=V,col=Compartment))+
			theme(axis.text=element_text(size=18),
						axis.title=element_text(size=20,face="bold"),
						legend.text=element_text(size=18),
						legend.title=element_text(size=20,face="bold"),
						legend.position="right",
						legend.key.size = unit(1.3, "cm"),
						legend.key.width = unit(1.3,"cm") )+
			labs(x="Days", y="Population")
		ListReturn<-list(plS = plS,plI = plI,plR = plR,plAll=plAll)
	}

	if(print){
		for(j in 1:length(ListReturn))
			print(ListReturn[j])
	}

	return(ListReturn)
}

