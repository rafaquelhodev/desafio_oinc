defmodule DesafioOinc.Router do
  use Commanded.Commands.Router

  alias DesafioOinc.Blog.Aggregates.Post
  alias DesafioOinc.Blog.Aggregates.Tag

  alias DesafioOinc.Blog.Commands.CreatePost
  alias DesafioOinc.Blog.Commands.AddPostTag
  alias DesafioOinc.Blog.Commands.LikePost
  alias DesafioOinc.Blog.Commands.DislikePost
  alias DesafioOinc.Blog.Commands.CreateTag

  dispatch(CreatePost, to: Post, identity: :post_uuid)
  dispatch(AddPostTag, to: Post, identity: :post_uuid)
  dispatch(LikePost, to: Post, identity: :post_uuid)
  dispatch(DislikePost, to: Post, identity: :post_uuid)
  dispatch(CreateTag, to: Tag, identity: :tag_uuid)
end
