library(epimod)
downloadContainers()

model.generation(net_fname = "./Net/SIR_age.PNPRO")

### Sensitivity analysis
sensitivity<-model.sensitivity(n_config = 50,
                               solver_fname = "Net/SIR_age.solver",
                               parameters_fname = "Input/FunctionsSensitivity_list.csv",
                               i_time = 0,
                               f_time = 7*10, # weeks
                               s_time = 1, # days
                               parallel_processors = 2)

source("./Rfunction/SensitivityPlot.R")
pl = SensitivityPlot(rank=F, folder = "SIR_age_sensitivity/")

pl$TrajS_a1
pl$TrajS_a2
pl$TrajI_a1
pl$TrajI_a2
pl$TrajR_a1
pl$TrajR_a2


### Model Analysis
#Deterministic
model.analysis(solver_fname = "Net/SIR_age.solver",
               parameters_fname = "Input/FunctionsModelAnalysis_list.csv",
               solver_type = "LSODA",
               f_time = 7*10, # weeks
               s_time = 1)

source("Rfunction/ModelAnalysisPlot.R")

AnalysisPlot = ModelAnalysisPlot(Stoch = F, print = F,
                                 trace_path = "./SIR_age_analysis/SIR_age-analysis-1.trace")
AnalysisPlot$plI <- AnalysisPlot$plI + labs(title="SIR with age stratification (deterministic)")
AnalysisPlot$plI
ggsave("./Images/I_analysis_SIR_age_LSODA.png", dpi = 300)

# Stochastic
model.analysis(solver_fname = "Net/SIR_age.solver",
               parameters_fname = "Input/FunctionsModelAnalysis_list.csv",
               solver_type = "SSA",
               f_time = 7*10, # weeks
               s_time = 1,
               n_run = 100,
               seed = "./SIR_age_analysis/seeds-SIR_age-analysis.RData",
               extend = TRUE)

source("Rfunction/ModelAnalysisPlot.R")

AnalysisPlot = ModelAnalysisPlot(Stoch = T, print = F,
                                 trace_path = "./SIR_age_analysis/SIR_age-analysis-1.trace")
AnalysisPlot$plI <- AnalysisPlot$plI + labs(title="SIR with age stratification (stochastic)")
AnalysisPlot$plI
ggsave("./Images/I_analysis_SIR_age_SSA.png", dpi = 300)
