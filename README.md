# DesafioOinc

## Setup

1. Executar `mix setup` para instalar dependências e fazer o setup da aplicação
2. Inicie a aplicação com `mix phx.server`

Visite [`localhost:4000`](http://localhost:4000) no seu browser.

## Tests

Rode o seguinte comando no terminal para rodar os testes e ver a cobertura de testes:

`mix test --cover`

## Entities

As entidades são posts, ratings, tags e comments.

- Posts: podem ter múltiplas **tags** e **comments**. Um **post** tem um único **rating**
- Ratings: um **rating** pertence a um **post**
- Tags: uma **tag** pode pertencer a múltiplos **posts**
- Comments: um **comment** pertence a um **post**

## Backend

1. Navegue para [`localhost:4000/graphiql`](http://localhost:4000/graphiql) para ter acesso ao GraphiQL playground
2. Um erro é retornado na `addComment` mutation se um `text` com mais de 254 caracteres for enviado ao servidor
3. Subscription `commentAdded` para ter acesso aos comentários adicionados:
    - Navegue no GraphiQL playground
    - Adicione `ws://localhost:4000/socket` no `WS URL`
    - Adicione `http://localhost:4000/graphiql` na `URL`
    - Execute a subscription 
    ```graphql
    subscription {
        commentAdded(postUuid: "POST_UUID") {
                uuid
                text
            }
        }
    ```
    - Adicione um comentário no post com uuid = "POST_UUID", você deverá receber um payload na aba da subscription
    - Você pode adicionar um comentário através de UI ou através do playground:
    ```graphql
    mutation {
        addComment (postUuid: "POST_UUID", text: "new text") {
                uuid
                text
                postUuid
            }
        }
    ```

## Frontend

1. Navegue para [`localhost:4000`](http://localhost:4000) para criar e ver posts
2. Clique no `Manage Tags` botão para criar e editar tags
3. Clique em um post para ver os detalhes dele. Na nova tela, é possível:
    - Dar like ou dislike em um post
    - Adicionar comentários
    - Quando um comentário é adicionado, qualquer outra session conectada poderá ver o novo comentário adicionado
    - Um erro é retornado ao adicionar um comentário com mais de 254 caracteres
    