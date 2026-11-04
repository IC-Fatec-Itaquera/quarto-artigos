# sampleador(): divide um data.frame em duas partes (`amostra` e `resto`)
#   sem usar o RNG do R.
#
#   A selecao e feita por hash de uma chave estavel (por padrao, a coluna
#   `id`), entao o resultado e sempre o mesmo: nao depende da maquina, da
#   versao do R, da ordem das linhas nem de `set.seed()`.
#
#   Argumentos:
#     data  : data.frame com a coluna usada como chave.
#     prop  : fracao de linhas que vai para `amostra` (default: 50%).
#     chave : nome da coluna que identifica cada observacao (unica e estavel).
#     sal   : texto que "tempera" o hash. Trocar o sal gera outro split,
#             mantendo a reprodutibilidade.
#
#   Retorna uma lista com:
#     amostra : data.frame com floor(nrow(data) * prop) linhas.
#     resto   : data.frame com as linhas restantes.
#
#   Exemplo:
#     source("funcs/sample_sem_rng.r")
#     partes <- sampleador(study)            # 50% por padrao
#     partes <- sampleador(study, prop = 0.7, sal = "outro-split")

sampleador <- function(data, prop = 0.5, chave = "id", sal = "2026") {
  if (!chave %in% names(data)) {
    stop("coluna `", chave, "` nao encontrada em `data`", call. = FALSE)
  }

  n <- nrow(data)
  k <- floor(n * prop)

  # chave -> texto estavel (sem notacao cientifica, sem depender da ordem)
  chave_txt <- if (is.numeric(data[[chave]])) {
    sprintf("%.0f", data[[chave]])
  } else {
    as.character(data[[chave]])
  }

  # xxhash32 do texto: mesma chave => mesmo hash em qualquer lugar
  h <- vapply(
    chave_txt,
    function(x) digest::digest(paste0(sal, ":", x),
                               algo = "xxhash32", serialize = FALSE),
    character(1)
  )

  idx <- order(h)[seq_len(k)]

  list(
    amostra = data[idx, , drop = FALSE],
    resto   = data[-idx, , drop = FALSE]
  )
}
