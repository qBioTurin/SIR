
init_generation<-function(min_init , max_init)
{
   # min/max are vectors = first position interval values for the first place and second position for the second place

    p_1=runif(n=1,min=min_init[1],max=max_init[1])

    return( c(p_1, 1,0) )
}

target<-function(output)
{
  ret <- output[,"I"]
  return(as.data.frame(ret))
}

mse<-function(reference, output)
{
  reference[1,] -> times_ref
  reference[2,] -> infect_ref
  
  # We will consider the same time points
  Infect <- output[which(output$Time %in% times_ref),"I"]
  infect_ref <- infect_ref[which( times_ref %in% output$Time)]
  
  diff.Infect <- 1/length(times_ref)*sum(( Infect - infect_ref )^2 )
  
  return(diff.Infect)
}