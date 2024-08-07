
library(epimod)

#downloadContainers()

start_time <- Sys.time()
model.generation(net_fname = "./Net/SIR.PNPRO")
end_time <- Sys.time()-start_time

###  Sensitivity analysis

## Simple version where only the transition rates vary.
# execution time 4 mins

start_time <- Sys.time()
sensitivity<-model.sensitivity(n_config = 200,
                               solver_fname = "Net/SIR.solver",
                               parameters_fname = "Input/FunctionsSensitivity_list.csv", 
                               reference_data = "Input/reference_data.csv",
                               functions_fname = "Rfunction/FunctionSensitivity.R",
                               distance_measure = "mse" ,
                               target_value = "target" ,
                               i_time = 0,
                               f_time = 7*10, # weeks
                               s_time = 1, # days  
                               parallel_processors = 2
)
end_time <- Sys.time()-start_time

##############################
## Let draw the trajectories
##############################
source("./Rfunction/SensitivityPlot.R")

pl = SensitivityPlot(folder = "SIR_sensitivity/", scd_folder = "SIR_analysis/")

pl$TrajS
pl$TrajI
pl$TrajR
pl$Points

### Calibration analysis
# Execution time 30 mins
start_time <- Sys.time()
model.calibration(parameters_fname = "Input/Functions_list_Calibration.csv",
                  functions_fname = "Rfunction/FunctionCalibration.R",
                  solver_fname = "Net/SIR.solver",
                  reference_data = "Input/reference_data.csv",
                  distance_measure = "mse" ,
                  f_time = 7*10, # weeks
                  s_time = 1, # days
                  # Vectors to control the optimization
                  ini_v = c(0.02,0.001),
                  lb_v = c(0.01, 0.0001),
                  ub_v = c(0.05, 0.002),
                  max.time = 2
                )

end_time <- Sys.time()-start_time

##############################
## Let draw the calibration results
##############################

source("Rfunction/CalibrationPlot.R")
plots <- calibration.plot(solverName_path = "SIR_calibration/SIR-calibration-1.trace",
                          reference_path ="Input/reference_data.csv",
                          print=F)
plots$plS
plots$plI
plots$plR


### Model Analysis
# Deterministic:

model.analysis(solver_fname = "Net/SIR.solver",
               parameters_fname = "Input/Functions_list_ModelAnalysis.csv",
               solver_type = "LSODA",
               f_time = 7*10, # weeks
               s_time = 1
               )

source("Rfunction/ModelAnalysisPlot.R")

AnalysisPlot = ModelAnalysisPlot(Stoch = F ,print = F,
                                 trace_path = "./SIR_analysis/SIR-analysis-1.trace")
AnalysisPlot$plAll

model.analysis(solver_fname = "Net/SIR.solver",
               parameters_fname = "Input/Functions_list_ModelAnalysis.csv",
               solver_type = "SSA",
               n_run = 500,
               parallel_processors = 2,
               f_time = 7*10, # weeks
               s_time = 1
)

AnalysisPlot = ModelAnalysisPlot(Stoch = T ,print = F,
                                 trace_path = "./SIR_analysis/SIR-analysis-1.trace")

AnalysisPlot$plAll
AnalysisPlot$plAllMean 

##using the general distribution - example

model.generation(net_fname = "./Net/SIR_generalFN.PNPRO")

model.analysis(solver_fname = "./SIR_generalFN.solver",
               solver_type = "SSA",
               n_run = 500,
               parallel_processors = 2,
               f_time = 7*10, # weeks
               s_time = 1
)

AnalysisPlot = ModelAnalysisPlot(Stoch = T ,print = F,
                                  trace_path = "./SIR_generalFN_analysis/SIR_generalFN-analysis-1.trace")
                                 
AnalysisPlot$plAll
AnalysisPlot$plAllMean 
                                 
