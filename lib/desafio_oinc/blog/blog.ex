defmodule DesafioOinc.Blog do
  alias DesafioOinc.App
  alias DesafioOinc.Repo

  alias DesafioOinc.Blog.Commands.CreateTag
  alias DesafioOinc.Blog.Commands.CreatePost
  alias DesafioOinc.Blog.Commands.AddPostTag

  alias DesafioOinc.Blog.Projections.Tag
  alias DesafioOinc.Blog.Projections.Post

  def create_post(title, text) do
    uuid = Ecto.UUID.generate()

    dispatch =
      %CreatePost{}
      |> CreatePost.assign_uuid(uuid)
      |> CreatePost.add_title(title)
      |> CreatePost.add_text(text)
      |> App.dispatch(consistency: :strong)

    case dispatch do
      :ok -> Repo.get(Post, uuid)
      error -> error
    end
  end

  def create_tag(name) do
    uuid = Ecto.UUID.generate()

    dispatch =
      %CreateTag{}
      |> CreateTag.add_name(name)
      |> CreateTag.assign_uuid(uuid)
      |> App.dispatch(consistency: :strong)

    case dispatch do
      :ok -> Repo.get(Tag, uuid)
      error -> error
    end
  end

  def add_tag_to_post(post_uuid, tag_uuid) do
    dispatch =
      %AddPostTag{}
      |> AddPostTag.assign_tag(tag_uuid)
      |> AddPostTag.assign_uuid(post_uuid)
      |> App.dispatch(consistency: :strong)

    case dispatch do
      :ok -> Repo.get(Post, post_uuid)
      error -> error
    end
  end
end
