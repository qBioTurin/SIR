msqd<-function(reference, output)
{
    reference[,1] -> times_ref
    reference[,2] -> susc_ref
    reference[,3] -> infect_ref
    reference[,4] -> recovered_ref
    
    # We will consider the same time points
    Susc <- output[which(output$Time %in% times_ref),"S"]
    Infect <- output[which(output$Time %in% times_ref),"I"]
    Recovered <- output[which(output$Time %in% times_ref),"R"]
    
    infect_ref <- infect_ref[which( times_ref %in% output$Time)]
    recovered_ref <- recovered_ref[which( times_ref %in% output$Time)]
    susc_ref <- susc_ref[which( times_ref %in% output$Time)]
    
    error <- 1/length(times_ref)*sum(( Infect - infect_ref )^2 +
                         (Recovered - recovered_ref)^2 +
                         (Susc - susc_ref)^2)

    return(error)
}
