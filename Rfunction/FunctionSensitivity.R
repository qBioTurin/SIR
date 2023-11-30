
init_generation<-function(min_init , max_init)
{
  S=runif(n=1,min=min_init,max=max_init)
  # It returns a vector of lenght equal to 3 since the marking is 
  # defined by the three places: S, I, and R.
  return( c(S, 1,0) )
}

target<-function(output)
{
  ret <- output[,"I"]
  return(as.data.frame(ret))
}

mse<-function(reference, output)
{
  reference[1,] -> times_ref
  reference[3,] -> I_ref

  # We will consider the same time points
  Infect <- output[which(output$Time %in% times_ref),"I"]
  I_ref <- I_ref[which( times_ref %in% output$Time)]
  
  diff.Infect <- 1/length(times_ref)*sum(( Infect - I_ref )^2 )
  
  return(diff.Infect)
}
