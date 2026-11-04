sampleador <- function(data){
  set.seed(2026L)
  n <- nrow(data)
  idx <- sample.int(n = n ,size = floor(n*0.5))
  list(
    amostra = data[idx,],
    resto = data[-idx,]
  )
}
