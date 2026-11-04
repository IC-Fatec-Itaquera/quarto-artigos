sampleador <- function(data){
  set.seed(2026L)
  n <- nrow(data)
  idx <- sample.int(n = n ,size = flor(n*0.5))
  list(
    amostra = data[sla,],
    resto = data[-sla,]
  )
}
