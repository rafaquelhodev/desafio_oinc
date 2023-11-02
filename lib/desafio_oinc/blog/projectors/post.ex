defmodule DesafioOinc.Blog.Projectors.Post do
  use Commanded.Projections.Ecto,
    application: DesafioOinc.App,
    repo: DesafioOinc.Repo,
    name: "Blog.Projectors.Post",
    consistency: :strong

  alias DesafioOinc.Blog.Projections.Rating
  alias DesafioOinc.Blog.Projections.Post
  alias DesafioOinc.Blog.Projections.PostTag

  alias DesafioOinc.Blog.Events.PostCreated
  alias DesafioOinc.Blog.Events.PostTagAdded

  require Logger

  project(%PostCreated{} = event, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :post, %Post{uuid: event.uuid, text: event.text, title: event.title})
    |> Ecto.Multi.insert(:post_rating, %Rating{
      post_uuid: event.uuid,
      likes: event.likes,
      dislikes: event.dislikes
    })
  end)

  project(%PostTagAdded{} = event, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :post_tag, %PostTag{
      post_uuid: event.uuid,
      tag_uuid: event.added_tag_uuid
    })
  end)

  def error({:error, %Ecto.ConstraintError{} = error}, _event, _failure_context) do
    Logger.error(fn -> "Failed due to constraint error: " <> inspect(error) end)

    :skip
  end
end
