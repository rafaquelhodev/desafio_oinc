defmodule DesafioOinc.Router do
  use Commanded.Commands.Router

  alias DesafioOinc.Blog.Aggregates.Post

  alias DesafioOinc.Blog.Commands.CreatePost

  dispatch(CreatePost, to: Post, identity: :post_uuid)
end
