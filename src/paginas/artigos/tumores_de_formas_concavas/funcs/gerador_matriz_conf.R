conf_matriz <- function(modelo,data , threshold,teste){
  if(teste == FALSE){
    probs <- predict(modelo,type='response')
  }
  probs <- predict(modelo,type = 'response', newdata =  data)
  addmargins(
    table(
      Observado = data$diagnosis,
      Previsto = probs > threshold
      )
  )
}
