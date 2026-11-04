# tabela_correlacoes(): recebe um data.frame já limpo (apenas colunas
#   numéricas) e devolve a tabela longa de correlações cujo módulo é maior
#   ou igual ao limiar informado.
#
# ocorrencias_correlacao(): recebe a tabela gerada acima e o nome (ou parte
#   do nome) de uma variável e devolve todas as ocorrências dessa variável,
#   nos dois lados do par, junto com a variável relacionada e o coeficiente.

# Recebe um data.frame já limpo (só colunas numéricas) e devolve a tabela
# longa de correlações acima do limiar.
tabela_correlacoes <- function(dados, limite = 0.8) {
  if (!all(vapply(dados, is.numeric, logical(1)))) {
    stop(
      "`dados` deve conter apenas colunas numéricas. ",
    )
  }

  matrix_de_correlacoes <- cor(dados)
  index <- which(
    upper.tri(matrix_de_correlacoes) 
    & abs(matrix_de_correlacoes) >= limite,
    arr.ind = TRUE
    )

  resultados <- data.frame(
    dominio = rownames(matrix_de_correlacoes)[index[, "row"]],
    imagem = colnames(matrix_de_correlacoes)[index[, "col"]],
    corelacao  = matrix_de_correlacoes[index]
  )

  resultados[order(-abs(resultados$corelacao)), ]
}

# Procura uma variável (exata ou parcial, case-insensitive) nos dois lados
# da tabela e devolve todas as ocorrências.
ocorrencias_correlacao <- function(tabela, variavel) {
  casa <- function(coluna) grepl(tolower(variavel), tolower(coluna), fixed = TRUE)
  no_dominio <- casa(tabela$dominio)
  na_imagem <- casa(tabela$imagem)
  
  saida <- rbind(
    data.frame(
      variavel       = tabela$dominio[no_dominio],
      outra_variavel = tabela$imagem[no_dominio],
      correlacao     = tabela$corelacao[no_dominio]
    ),
    data.frame(
      variavel       = tabela$imagem[na_imagem],
      outra_variavel = tabela$dominio[na_imagem],
      correlacao     = tabela$corelacao[na_imagem]
    )
  )
  saida[order(-abs(saida$correlacao)), ]
}
