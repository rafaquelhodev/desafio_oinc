defmodule DesafioOinc.Router do
  use Commanded.Commands.Router

  alias DesafioOinc.Blog.Aggregates.Post
  alias DesafioOinc.Blog.Aggregates.Tag
  alias DesafioOinc.Blog.Aggregates.Comment

  alias DesafioOinc.Blog.Commands.CreatePost
  alias DesafioOinc.Blog.Commands.UpdatePost
  alias DesafioOinc.Blog.Commands.AddPostTag
  alias DesafioOinc.Blog.Commands.LikePost
  alias DesafioOinc.Blog.Commands.DislikePost
  alias DesafioOinc.Blog.Commands.CreateTag
  alias DesafioOinc.Blog.Commands.UpdateTag
  alias DesafioOinc.Blog.Commands.AddComment

  dispatch(CreatePost, to: Post, identity: :post_uuid)
  dispatch(UpdatePost, to: Post, identity: :post_uuid)
  dispatch(AddPostTag, to: Post, identity: :post_uuid)
  dispatch(LikePost, to: Post, identity: :post_uuid)
  dispatch(DislikePost, to: Post, identity: :post_uuid)

  dispatch(CreateTag, to: Tag, identity: :tag_uuid)
  dispatch(UpdateTag, to: Tag, identity: :tag_uuid)

  dispatch(AddComment, to: Comment, identity: :comment_uuid)
end
