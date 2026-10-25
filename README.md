# IC
Iniciaçao cientifica FATEC Itaquera , classificação de dados utilizando regressão Logistica, professora: Claudia de Lello Courtouké 

# dependências R com renv

O projeto usa [`renv`](https://rstudio.github.io/renv/) para controlar as dependências de R.

## o que é o renv

O `renv` é um gerenciador de ambientes e pacotes para projetos em R. Ele cria uma biblioteca de pacotes separada para este projeto e registra as versões usadas no arquivo `src/renv.lock`.

Na prática, o `renv.lock` funciona como uma "foto" do ambiente: ele diz quais pacotes e versões o projeto precisa para renderizar os artigos.

## o que ele resolve

Sem o `renv`, cada pessoa pode ter versões diferentes dos pacotes instalados globalmente no R. Isso causa problemas como:

- um artigo funciona na máquina de uma pessoa e falha na máquina de outra;
- o build local funciona, mas o GitHub Actions falha;
- alguém precisa editar o workflow sempre que adiciona um pacote novo;
- alguém coloca `install.packages()` dentro de um `.qmd`, fazendo o artigo instalar pacotes toda vez que é renderizado.

Com o `renv`:

- cada projeto tem seu próprio conjunto de pacotes;
- as versões ficam registradas no `renv.lock`;
- o GitHub Actions restaura exatamente o mesmo ambiente antes de renderizar;
- para adicionar um pacote, não é necessário alterar o workflow, apenas atualizar o `renv.lock`.

## por que estamos usando

O site é renderizado no GitHub Actions e publicado no GitHub Pages. Precisamos que o build seja reproduzível e que a lista de dependências não fique espalhada pelo workflow ou pelos artigos.

O `renv` centraliza essa responsabilidade em `src/renv.lock`. O workflow apenas executa `renv::restore()` e renderiza o site.

## onde ficam os arquivos

Os arquivos do `renv` ficam dentro de `src/`, porque é ali que está o projeto Quarto:

```text
src/
  .Rprofile             # ativa o renv ao abrir o projeto
  renv.lock             # versões exatas dos pacotes
  renv/
    activate.R          # script de ativação
    settings.json       # configurações do renv
    library/            # pacotes instalados localmente (não versionar)
```

A pasta `src/renv/library/` é ignorada pelo Git. Ela é reconstruída com `renv::restore()`.

## primeira vez no projeto

Abra o projeto `src/iniciacao_cientifica.Rproj` no RStudio ou entre na pasta `src` pelo terminal:

```bash
cd src
Rscript -e "renv::restore()"
```

Também é possível abrir o console do R dentro de `src` e executar:

```r
renv::restore()
```

Isso instala as versões registradas em `src/renv.lock`.

## uso no dia a dia

Sempre que atualizar o repositório ou trocar de branch, entre em `src` e rode:

```r
renv::restore()
```

Para verificar se o ambiente local está de acordo com o `renv.lock`:

```r
renv::status()
```

Para renderizar o site:

```bash
cd src
quarto preview
```

O uso normal é: `renv::restore()`, escrever o artigo, `quarto preview`, commitar.

## como adicionar um pacote novo

Não coloque `install.packages()` dentro do `.qmd`. O artigo deve apenas carregar o pacote com `library()`.

Dentro do console do R, no projeto `src`:

```r
renv::install("nome-do-pacote")
```

Use o pacote normalmente no artigo:

````markdown
```{r}
library(nome-do-pacote)
```
````

Depois registre a dependência no lockfile:

```r
renv::snapshot()
```

Por fim, commit o `renv.lock` atualizado junto com o artigo:

```bash
git add src/renv.lock src/artigos/novo-artigo.qmd
git commit -m "feat - novo artigo e dependencia"
```

Se o pacote ainda não aparecer no lockfile, você pode informá-lo explicitamente:

```r
renv::snapshot(packages = "nome-do-pacote")
```

## o que deve ser commitado

Sempre versione:

- `src/renv.lock`
- `src/.Rprofile`
- `src/renv/activate.R`
- `src/renv/settings.json`

Nunca versione:

- `src/renv/library/`
- `src/renv/local/`
- `src/renv/cellar/`
- `src/renv/staging/`

Esses diretórios são recriados pelo `renv` e já estão no `.gitignore` interno.

## regras importantes

- Não rode `renv::init()` novamente; o projeto já está inicializado.
- Não edite `src/renv.lock` manualmente.
- Não adicione `install.packages()` nos artigos.
- Use `library(pacote)` no `.qmd` apenas para carregar o pacote.
- Sempre que adicionar ou remover um pacote, rode `renv::snapshot()` e commit o `renv.lock`.
- Antes de abrir um pull request, rode `renv::status()` e `quarto preview` localmente.

## GitHub Actions e GitHub Pages

O workflow `.github/workflows/publish.yml` foi configurado assim:

- pull requests para `main` ou `dev`: executa o build, sem publicar;
- push ou merge em `dev`: executa o build, sem publicar;
- push ou merge em `main`: executa o build e publica no GitHub Pages.

O workflow usa `r-version: renv` e `r-lib/actions/setup-renv@v2`, então a versão do R e as versões dos pacotes vêm do `src/renv.lock`. Não é necessário manter uma lista de pacotes dentro do workflow.

## problemas comuns

**`renv::status()` diz que o projeto está fora de sincronia**

Rode:

```r
renv::restore()
```

Se você adicionou um pacote intencionalmente e ainda não atualizou o lockfile:

```r
renv::snapshot()
```

**O pacote funciona localmente, mas falha no GitHub Actions**

Verifique se o `src/renv.lock` foi commitado e se `renv::status()` não mostra pendências. Depois rode `quarto render` localmente a partir de `src`.

**Preciso instalar o Rtools no Windows**

Alguns pacotes compilados podem exigir o Rtools. O `renv` avisa quando ele é necessário. Na maioria dos casos, os binários do CRAN para Windows já são usados automaticamente.

**O build falhou por causa de um pacote**

Não edite o workflow para instalar o pacote manualmente. Rode `renv::install("pacote")`, use o pacote no artigo, rode `renv::snapshot()` e commit o `renv.lock`.

# commites semanticos 
isso não é uma regra, mas seria bom se todos usasem esse padrão de commit 
[commit semantico](https://github.com/iuricode/padroes-de-commits)
[doc original](https://www.conventionalcommits.org/en/v1.0.0/)

# branches e pull-requests
**nunca pushem diretamente na banch main**, se você quer adicionar, remover ou alterar algo, crie sua branch primeiro, faça suas alteraçoes entao crie um pull request,
nao me importo com o padrao de nome da branch, mas sugiro esse padrão: 
    {seu_nome}-{coisa_que_voce_fez}

