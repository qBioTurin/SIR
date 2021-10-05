
library(epimod)

#downloadContainers()

start_time <- Sys.time()
model_generation("./Net/SIR.PNPRO")
end_time <- Sys.time()-start_time


### Model Analysis
### deterministic

model_analysis(solver_fname = "Net/SIR.solver",
               parameters_fname = "Input/Functions_list_ModelAnalysis.csv",
               solver_type = "LSODA",
               f_time = 100, # days
               s_time = 1
)

source("Rfunction/ModelAnalysisPlot.R")
AnalysisPlot = ModelAnalysisPlot(solverName_path= "results_model_analysis/SIR",Stoch = F)
AnalysisPlot$plI
AnalysisPlot$plS

### stochastic

model_analysis(solver_fname = "Net/SIR.solver",
               parameters_fname = "Input/Functions_list_ModelAnalysis.csv",
               solver_type = "SSA",
               n_run = 1000,
               parallel_processors = 2,
               f_time = 100, # days
               s_time = 1
)

source("Rfunction/ModelAnalysisPlot.R")
AnalysisPlot = ModelAnalysisPlot(solverName_path = "./results_model_analysis/SIR",
                                 Stoch = T)
AnalysisPlot$plI
AnalysisPlot$HistI
AnalysisPlot$plS
AnalysisPlot$HistS




### Calibration analysis
# Execution time 10 mins
start_time <- Sys.time()
model_calibration(parameters_fname = "Input/Functions_list_Calibration.csv",
                  functions_fname = "Rfunction/FunctionCalibration.R",
                  solver_fname = "Net/SIR.solver",
                  reference_data = "Input/reference_data.csv",
                  distance_measure_fname = "Rfunction/msqd.R" ,
                  f_time = 100, # days
                  s_time = 1, # day
                  # Vectors to control the optimization
                  ini_v = c(0.035,0.00035),
                  ub_v = c(0.05, 0.0005),
                  lb_v = c(0.025, 0.00025),
                  max.time = 1
)
end_time <- Sys.time()-start_time

##############################
## Let draw the calibration results
##############################

calibration_optim_trace <-read.csv("./results_model_calibration/SIR-calibration_optim-trace.csv",sep = "")
load("./results_model_calibration/SIR-calibration_optim.RData")

source("Rfunction/CalibrationPlot.R")
plots <- calibration.plot(solverName_path = "Results/results_model_calibration/SIR",reference_path = "Input/reference_data.csv")
plots$plS
plots$plI
plots$plR



###  Sensitivity analysis

## Simple version where only the transition rates vary.
# execution time 4 mins

start_time <- Sys.time()
sensitivity<-sensitivity_analysis(n_config = 500,
                                  parameters_fname = "Input/Functions_list.csv", 
                                  solver_fname = "Net/SIR.solver",
                                  reference_data = "Input/reference_data.csv",
                                  distance_measure_fname = "Rfunction/msqd.R" ,
                                  target_value_fname = "Rfunction/Target.R" ,
                                  f_time = 100, # days 
                                  s_time = 1, # day      
                                  parallel_processors = 2
)
end_time <- Sys.time()-start_time

##############################
## Let draw the trajectories
##############################
source("./Rfunction/SensitivityPlot.R")
pl
plS
plI
plR