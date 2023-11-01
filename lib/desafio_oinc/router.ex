defmodule DesafioOinc.Router do
  use Commanded.Commands.Router

  alias DesafioOinc.Blog.Aggregates.Post
  alias DesafioOinc.Blog.Aggregates.Tag

  alias DesafioOinc.Blog.Commands.CreatePost
  alias DesafioOinc.Blog.Commands.CreateTag

  dispatch(CreatePost, to: Post, identity: :post_uuid)
  dispatch(CreateTag, to: Tag, identity: :tag_uuid)
end
