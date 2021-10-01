
library(epimod)

#downloadContainers()

start_time <- Sys.time()
model_generation(net_fname = "./Net/SIR.PNPRO")
end_time <- Sys.time()-start_time

###  Sensitivity analysis

## Simple version where only the transition rates vary.
# execution time 4 mins

start_time <- Sys.time()
sensitivity<-sensitivity_analysis(n_config = 100,
                                  parameters_fname = "Input/Functions_list.csv", 
                                  solver_fname = "Net/SIR.solver",
                                  reference_data = "Input/reference_data.csv",
                                  distance_measure_fname = "Rfunction/msqd.R" ,
                                  target_value_fname = "Rfunction/Target.R" ,
                                  f_time = 7*3, # weeks
                                  s_time = 1, # days      
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


## Version where only the PRCC is calculated
# sensitivity<-sensitivity_analysis(n_config = 100,
#                                   parameters_fname = "Input/Functions_list.csv", 
#                                   functions_fname = "Rfunction/Functions.R",
#                                   solver_fname = "Net/SIR.solver",
#                                   target_value_fname = "Rfunction/Target.R" ,
#                                   parallel_processors = 1,
#                                   f_time = 7*10, # weeks
#                                   s_time = 1 # days
#                                   )

## Version where only the ranking is calculated
# sensitivity<-sensitivity_analysis(n_config = 100,
#                                   parameters_fname = "Input/Functions_list.csv", 
#                                   functions_fname = "Rfunction/Functions.R",
#                                   solver_fname = "Net/SIR.solver",
#                                   reference_data = "Input/reference_data.csv",
#                                   distance_measure_fname = "Rfunction/msqd.R" ,
#                                   parallel_processors = 1,
#                                   f_time = 7*10, # weeks
#                                   s_time = 1 # days
#                                   )

## Complete and more complex version where all the parameters for calculating
## the PRCC and the ranking are considered, and the initial conditions vary too.
# sensitivity<-sensitivity_analysis(n_config = 100,
#                                   parameters_fname = "Input/Functions_list2.csv", 
#                                   functions_fname = "Rfunction/Functions.R",
#                                   solver_fname = "Net/SIR.solver",
#                                   reference_data = "Input/reference_data.csv",
#                                   distance_measure_fname = "Rfunction/msqd.R" ,
#                                   target_value_fname = "Rfunction/Target.R" ,
#                                   parallel_processors = 2,
#                                   f_time = 7*10, # weeks
#                                   s_time = 1 # days
#                                   )

### Calibration analysis
# Execution time 30 mins
start_time <- Sys.time()
model_calibration(parameters_fname = "Input/Functions_list_Calibration.csv",
                  functions_fname = "Rfunction/FunctionCalibration.R",
                  solver_fname = "Net/SIR.solver",
                  reference_data = "Input/reference_data.csv",
                  distance_measure_fname = "Rfunction/msqd.R" ,
                  f_time = 7*3, # weeks
                  s_time = 1, # days
                  # Vectors to control the optimization
                  ini_v = c(0.4,0.0014),
                  lb_v = c(0.3, 0.001),
                  ub_v = c(0.6, 0.002),
                  max.time = 1
                )

end_time <- Sys.time()-start_time

##############################
## Let draw the calibration results
##############################

calibration_optim_trace <-read.csv("./results_model_calibration/SIR-calibration_optim-trace.csv",sep = "")
load("./results_model_calibration/SIR-calibration_optim.RData")

source("Rfunction/CalibrationPlot.R")
plI

### Model Analysis


model_analysis(out_fname = "model_analysis",
               solver_fname = "Net/SIR.solver",
               parameters_fname = "Input/Functions_list_ModelAnalysis.csv",
               solver_type = "LSODA",
               f_time = 7*3, # weeks
               s_time = 1
               )

source("Rfunction/ModelAnalysisPlot.R")
plI
plS
