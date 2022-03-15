library(epimod)
downloadContainers()

model.generation(net_fname = "./Net/SIR.PNPRO")


model.analysis(solver_fname = "./Net/SIR.solver",
							 solver_type = "LSODA",
							 i_time = 1,
							 f_time = 100, # days
							 s_time = 1, # day
							 parameters_fname = "./Input/Functions_list_ModelAnalysis_wrong.csv")

source("./Rfunction/ModelAnalysisPlot.R")
AnalysisPlots = ModelAnalysisPlot("./SIR_analysis/SIR-analysis-1.trace", Stoch = FALSE, print = FALSE)
reference <- read.csv("./Input/reference_data.csv", sep = " ")
AnalysisPlots$plI <- AnalysisPlots$plI + geom_line(data=reference, aes(x=X0, y=X3, color="Reference data")) + labs(title="SIR (random rates, deterministic)")
AnalysisPlots$plI
ggsave("./Images/I_analysis_SIR_simple_LSODA_wrong.png", dpi = 300)


model.analysis(solver_fname = "./Net/SIR.solver",
							 solver_type = "SSA",
							 i_time = 1,
							 f_time = 100, # days
							 s_time = 1, # day
							 n_run = 200,
							 parameters_fname = "./Input/Functions_list_ModelAnalysis_wrong.csv")

source("./Rfunction/ModelAnalysisPlot.R")
AnalysisPlots = ModelAnalysisPlot("./SIR_analysis/SIR-analysis-1.trace", Stoch = TRUE, print = FALSE)
reference <- read.csv("./Input/reference_data.csv", sep = " ")
AnalysisPlots$plI <- AnalysisPlots$plI + geom_line(data=reference, aes(x=X0, y=X3, color="Reference data")) + labs(title="SIR (random rates, stochastic)")
AnalysisPlots$plI
ggsave("./Images/I_analysis_SIR_simple_SSA_wrong.png", dpi = 300)


model.calibration(solver_fname = "./Net/SIR.solver",
                  parameters_fname = "./Input/Functions_list_Calibration.csv",
                  functions_fname = "./Rfunction/FunctionCalibration.R",
                  reference_data = "./Input/reference_data.csv",
                  distance_measure = "mse",
                  i_time = 1,
                  f_time = 100, # days
                  s_time = 1, # day
                  # Vectors to control the optimization
                  ini_v = c(0.035,0.00035),
                  ub_v = c(0.05, 0.0005),
                  lb_v = c(0.025, 0.00025),
                  max.time = 1)

source("./Rfunction/CalibrationPlot.R")
CalibrationPlots = calibration.plot("SIR_calibration/SIR", "./Input/reference_data.csv", print = F)
CalibrationPlots$plI <- CalibrationPlots$plI + labs(title="SIR (calibration)")
ggsave("./Images/I_calibration_SIR_simple_LSODA.png", dpi = 300)


model.analysis(solver_fname = "./Net/SIR.solver",
							 solver_type = "LSODA",
							 i_time = 1,
							 f_time = 100, # days
							 s_time = 1, # day
							 parameters_fname = "./Input/Functions_list_ModelAnalysis.csv")

source("./Rfunction/ModelAnalysisPlot.R")
AnalysisPlots = ModelAnalysisPlot("./SIR_analysis/SIR-analysis-1.trace", Stoch = FALSE, print = FALSE)
reference <- read.csv("./Input/reference_data.csv", sep = " ")
AnalysisPlots$plI <- AnalysisPlots$plI + geom_line(data=reference, aes(x=X0, y=X3, color="Reference data")) + labs(title="SIR (estimated rates, deterministic)")
AnalysisPlots$plI
ggsave("./Images/I_analysis_SIR_simple_LSODA.png", dpi = 300)

model.analysis(solver_fname = "./Net/SIR.solver",
							 solver_type = "SSA",
							 i_time = 1,
							 f_time = 100, # days
							 s_time = 1, # day
							 n_run = 200,
							 parameters_fname = "./Input/Functions_list_ModelAnalysis.csv")

source("./Rfunction/ModelAnalysisPlot.R")
AnalysisPlots = ModelAnalysisPlot("./SIR_analysis/SIR-analysis-1.trace", Stoch = TRUE, print = FALSE)
reference <- read.csv("./Input/reference_data.csv", sep = " ")
AnalysisPlots$plI <- AnalysisPlots$plI + geom_line(data=reference, aes(x=X0, y=X3, color="Reference data")) + labs(title="SIR (estimated rates, stochastic)")
AnalysisPlots$plI
ggsave("./Images/I_analysis_SIR_simple_SSA.png", dpi = 300)
