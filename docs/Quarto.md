# Quarto 
Quarto é uma feramenta de criacao e divulgação de documentacao tecnica
## oque é o Quarto
O Quarto é um versao mais robusta do Rmarkdown, tento suporte a mais de uma linguagem, e permitindo diferentes 
tipos de formatos de documentacao, via seu arquivo de configuracao `_Quarto.yml`.

### oque é o _quarto.yml
assim como o springboot tem seu application.yml, como do docker tem seu docker-compose.yml
o quarto tem seu `_quarto.yml` que automatiza configurações para o projeto quarto, e nos permite escolher o 
modelo final que nossa documentação pode ter, seja ela web,pptx ou apenas markdown.

### nossa _quarto.yml
```YAML
project: 
    type: website # tipo da aplicação, o quarto tambem suporta outros tipos.
    brand: styles/_brand.yml # arquivo de estilização padronizado com o estilo do Centro Paula Souza 

lang: pt-BR

website: 
    title: "Iniciação Científica"
    navbar: # configurações da barra de navegação do site
        left:
        - href: index.qmd
            text: Home
        - href: paginas/sobre_o_projeto/about.qmd
            text: Sobre o projeto
        - href: paginas/artigos/index.qmd
            text: Artigos

format: # formato de output do 'website' 
    html:
        theme: [cosmo, brand, styles/custom.scss]
        toc: true
```
> se quiser saber oque um opição especifica desse yml faz, consulte [Quarto OPML options](https://quarto.org/docs/reference/formats/opml.html)

> se quiser um guia pratico de como usar o quarto, consulte o [guia pratico do Quarto](https://quarto-tdg.org/)

## oque resolve, como resolve 
muitas vezes um pesquisa so existe em um slide de um pdf, em uma planilha que ninguem abre e entao é esquicido o 
Quarto resolve isso em um tres palavras: Analise, Divulgue , Reproduza.
o Quarto oferece o ambiente ideal para que desenvolvedores divulguem seus trabalhos com alta integraçao de opcoes 
de disponibilizaçao, de um jeito reproduzivel sem perder a precissao das suas analises, pra mais que apenas um 
grafico em uma documentação esquecida, o Quarto permite que nosso trabalho seja disponibilizado e visto.

## porque usar 

O conehcimento deve ser difundido e divulgado, que jeito melhor do que disponizar nao internet para todo o mundo
