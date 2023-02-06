#COVID19
if(!require(COVID19)) install.packages("COVID19")
if(!require(ggplot2)) install.packages("ggplot2")

#Importing CODVID19 data for Italy
data=COVID19::covid19("Italy",level=2)
dataL=filter(data,administrative_area_level_2=="Liguria")
dataL=dataL[100:1075,]
#Plot data  for Italy
ggplot(dataL)+geom_line(aes(y=recovered,x=date)) 
ggplot(dataL)+geom_line(aes(y=confirmed,x=date))


#Create the reference data selecting the first 500 days
reference=data.frame(1:480,dataL[1:480,"confirmed"])
ggplot(reference)+geom_line(aes(y=reference[,2],x=reference[,1]))
write.table(reference,file="./Input/reference_dataItalyLiguria.csv",row.names =F, col.names = F)                       


#Generate SEIR model
model.generation(net_fname = "./Net/SEIR.PNPRO")

#Execute model_analysis to derive the model behaviors
model.analysis("SEIR.solver",
               f_time=480,
               s_time=1,
               i_time=1)


source("./Rfunction/ModelAnalysisPlot.R")
#Execute the function ModelAnalysisPlot
outD=ModelAnalysisPlot("SEIR_analysis/SEIR-analysis-1.trace")


model.calibration(solver_fname = "./SEIR.solver",
                  parameters_fname = "./Input/Functions_list_CalibrationItalyLiguria.csv",
                  functions_fname = "./Rfunction/FunctionCalibrationItalyLiguria.R",
                  reference_data = "./Input/reference_dataItalyLiguria.csv",
                  distance_measure = "mse",
                  i_time = 1,
                  f_time = 480, # days
                  s_time = 1, # day
                  # Vectors to control the optimization
                  ini_v = c(1.8e-2,1.80e-8,2.38e-1),
                  ub_v = c(0.3,0.0000001,0.3),
                  lb_v = c(0.01,0.000000000001,0.01),
                  max.time = 40
)


#Plot the result computed by the model calibaration
#Source the code in CalibrationPlot.R This file can be download here: 
#https://raw.githubusercontent.com/qBioTurin/SIR/MasterLesson/Rfunction/CalibrationPlot.R
source("./Rfunction/CalibrationPlot.R")
#Execute the function ModelAnalysisPlot
calibration.plot("SEIR_calibration/SEIR","./Input/reference_dataItalyLiguria.csv")
load("~/SIR/SEIR_calibration/SEIR-calibration_optim.RData")
res=paste(c("c;Recovery;","c;Infection;","c;BecomeInf;"),ret$par,";")
writeLines(res,"./Input/Functions_list_ModelAnalysisItalyLiguria.csv")

#Execute model_analysis to derive the model behaviors
model.analysis("SEIR.solver",
               f_time=480,
               s_time=1,
               i_time=1,
               parameters_fname = "./Input/Functions_list_ModelAnalysisItalyLiguria.csv")
res=read.table("SEIR_analysis/SEIR-analysis-1.trace",header = T)
ggplot()+geom_line(data=res, aes(x=Time,y=I))+geom_line(data=reference,aes(reference[,1],reference[,2]),col="red")


#Execute model_analysis to derive the model behaviors
model.analysis("SEIR.solver",
               f_time=480,
               s_time=1,
               i_time=1,
               parameters_fname = "./Input/Functions_list_ModelAnalysisItalyLiguria.csv",
               solver_type = "SSA",
               n_run = 500)
#Execute the function ModelAnalysisPlot
outS=ModelAnalysisPlot("./SEIR_analysis/SEIR-analysis-1.trace",Stoch = TRUE)
outS$I+geom_line(data=reference,aes(reference[,1],reference[,2]),col="blue")


#Create the reference data selecting the first 500 days
reference=data.frame(1:377,dataL[600:976,"confirmed"])
ggplot(reference)+geom_line(aes(y=reference[,2],x=reference[,1]))
write.table(reference,file="./Input/reference_dataItalyLiguria.csv",row.names =F, col.names = F)                       


#Generate SEIR model
model.generation(net_fname = "./Net/SEIR2.PNPRO")

model.calibration(solver_fname = "./SEIR2.solver",
                  parameters_fname = "./Input/Functions_list_CalibrationItalyLiguria.csv",
                  functions_fname = "./Rfunction/FunctionCalibrationItalyLiguria.R",
                  reference_data = "./Input/reference_dataItalyLiguria.csv",
                  distance_measure = "mse",
                  i_time = 1,
                  f_time = 377, # days
                  s_time = 1, # day
                  # Vectors to control the optimization
                  ini_v = c(1.8e-2,1.80e-8,2.38e-1),
                  ub_v = c(0.3,0.000001,0.3),
                  lb_v = c(0.001,0.000000000001,0.001),
                  max.time = 40
)
#Execute the function ModelAnalysisPlot
calibration.plot("SEIR2_calibration/SEIR2","./Input/reference_dataItalyLiguria.csv")
load("~/SIR/SEIR2_calibration/SEIR2-calibration_optim.RData")
res=paste(c("c;Recovery;","c;Infection;","c;BecomeInf;"),ret$par,";")
writeLines(res,"./Input/Functions_list_ModelAnalysisItalyLiguria.csv")

#Execute model_analysis to derive the model behaviors
model.analysis("SEIR2.solver",
               f_time=377,
               s_time=1,
               i_time=1,
               parameters_fname = "./Input/Functions_list_ModelAnalysisItalyLiguria.csv")
res=read.table("SEIR2_analysis/SEIR2-analysis-1.trace",header = T)
ggplot()+geom_line(data=res, aes(x=Time,y=I))+geom_line(data=reference,aes(reference[,1],reference[,2]),col="red")

#Execute model_analysis to derive the model behaviors
model.analysis("SEIR2.solver",
               f_time=377,
               s_time=1,
               i_time=1,
               parameters_fname = "./Input/Functions_list_ModelAnalysisItalyLiguria.csv",
               solver_type = "SSA",
               n_run = 500)
#Execute the function ModelAnalysisPlot
outS=ModelAnalysisPlot("./SEIR2_analysis/SEIR2-analysis-1.trace",Stoch = TRUE)
outS$I+geom_line(data=reference,aes(reference[,1],reference[,2]),col="blue")

