library(epimod)

#downloadContainers()

start_time <- Sys.time()
model.generation(net_fname = "./Net/SIR_age_vaccination.PNPRO")
end_time <- Sys.time()-start_time

### Sensitivity analysis

start_time <- Sys.time()
sensitivity<-model.sensitivity(n_config = 50,
															 solver_fname = "Net/SIR_age_vaccination.solver",
															 parameters_fname = "Input/FunctionsSensitivity_list.csv",
															 i_time = 0,
															 f_time = 7*10, # weeks
															 s_time = 1, # days
															 parallel_processors = 2)
end_time <- Sys.time()-start_time

##############################
## Let draw the trajectories
##############################
source("./Rfunction/SensitivityPlot.R")

pl = SensitivityPlot(rank=F, folder = "SIR_age_vaccination_sensitivity/")

pl$TrajS_a1
pl$TrajS_a2
pl$TrajI_a1
pl$TrajI_a2
pl$TrajR_a1
pl$TrajR_a2
pl$TrajV_a1
pl$TrajV_a2


### Model Analysis

#Deterministic
model.analysis(solver_fname = "Net/SIR_age_vaccination.solver",
							 parameters_fname = "Input/FunctionsModelAnalysis_list.csv",
							 solver_type = "LSODA",
							 f_time = 7*10, # weeks
							 s_time = 1)

source("Rfunction/ModelAnalysisPlot.R")

AnalysisPlot = ModelAnalysisPlot(Stoch = F, print = F,
																 trace_path = "./SIR_age_vaccination_analysis/SIR_age_vaccination-analysis-1.trace")
AnalysisPlot$plI

#Stochastic
model.analysis(solver_fname = "Net/SIR_age_vaccination.solver",
							 parameters_fname = "Input/FunctionsModelAnalysis_list.csv",
							 solver_type = "SSA",
							 f_time = 7*10, # weeks
							 s_time = 1,
							 n_run = 100,
							 seed = "./seeds-SIR_age_vaccination-analysis.RData")

source("Rfunction/ModelAnalysisPlot.R")

AnalysisPlot = ModelAnalysisPlot(Stoch = T, print = F,
																 trace_path = "./SIR_age_vaccination_analysis/SIR_age_vaccination-analysis-1.trace")
AnalysisPlot$plI
