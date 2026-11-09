# Renv

O projeto usa [`renv`](https://rstudio.github.io/renv/) para controlar as dependências de R.

## o que é o renv

O `renv` é um gerenciador de ambientes e pacotes para projetos em R. Ele cria uma biblioteca de pacotes separada para este projeto e registra as versões usadas no arquivo `src/renv.lock`.
> é como o npm no javascript ou os ambientes viruais no python.

O `renv.lock` é uma foto de todos os pacotes usados pela aplicação, usamos essa foto para 
podermos nos organizar e saber oque estamos usando no projeto de forma incremental

## o que ele resolve

Sem o `renv`, cada pessoa pode ter versões diferentes dos pacotes instalados globalmente no R.

- um artigo funciona na máquina de uma pessoa e falha na máquina de outra;
- alguém coloca `install.packages()` dentro de um `.qmd`, fazendo o artigo instalar pacotes toda vez que é renderizado.

Com o `renv`:

- o projeto como um todo usa a mesma base de pacotes externos;
- as versões ficam registradas no `renv.lock`;
- o GitHub Actions restaura exatamente o mesmo ambiente antes de renderizar;

## por que estamos usando

O site é renderizado no GitHub Actions e publicado no GitHub Pages.
Precisamos que o a versão final do site, seja reproduzível para outras maquinas, 
e que a lista de dependências não fique espalhada pelo workflow ou pelos artigos.

O `renv` centraliza essa responsabilidade em `src/renv.lock`. O workflow apenas executa `renv::restore()` e renderiza o site.

## onde ficam os arquivos

A estrutura do repositório é:

```text
.
├── .github/
│   └── workflows/
│       └── publish.yml      # build e publicação no GitHub Pages
├── README.md
└── src/                     # projeto Quarto
    ├── IC.Rproj             # projeto do RStudio
    ├── .Rprofile            # executa scripts sempre que o R inicia
    ├── _quarto.yml          # configuração do site
    ├── index.qmd            # pagina inicial do site
    ├── assets/
    │   └── logos/           # logos institucionais
    ├── paginas/
    │   ├── sobre_o_projeto/ # página sobre o projeto
    │   └── artigos/         # artigos 
    ├── styles/
    │   ├── _brand.yml       # cores, fontes e logo da marca
    │   └── custom.scss      # ajustes de estilo sobre o tema
    ├── renv.lock            # versões exatas dos pacotes
    └── renv/
        ├── activate.R       # script de ativação
        ├── settings.json    # configurações do renv
        └── library/         # pacotes instalados localmente (não versionar)
```

A pasta `src/renv/library/` é ignorada pelo Git. Ela é reconstruída com `renv::restore()`.
