fun.recovery <- function(optim_v, n)
{
  return(optim_v[1])
}

fun.infection <- function(optim_v, n)
{
  return(optim_v[2])
}

mse <- function(reference, output)
{
  reference[1,] -> times_ref
  reference[2,] -> infect_ref

  # We will consider the same time points
  Infect <- output[which(output$Time %in% times_ref),"I"]
  infect_ref <- infect_ref[which(times_ref %in% output$Time)]

  diff.Infect <- 1/length(times_ref) * sum((Infect - infect_ref)^2)

  return(diff.Infect)
}
