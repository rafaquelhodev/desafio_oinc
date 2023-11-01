defmodule DesafioOinc.Blog do
  alias DesafioOinc.App
  alias DesafioOinc.Blog.Commands.CreatePost
  alias DesafioOinc.Blog.Projections.Post
  alias DesafioOinc.Repo

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
end
