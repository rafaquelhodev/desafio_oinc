defmodule DesafioOinc.Blog.Projectors.Post do
  use Commanded.Projections.Ecto,
    application: DesafioOinc.App,
    repo: DesafioOinc.Repo,
    name: "Blog.Projectors.Post",
    consistency: :strong

  alias DesafioOinc.Blog.Projections.Rating
  alias DesafioOinc.Blog.Projections.Post
  alias DesafioOinc.Blog.Events.PostCreated

  project(%PostCreated{} = event, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :post, %Post{uuid: event.uuid, text: event.text, title: event.title})
    |> Ecto.Multi.insert(:post_rating, %Rating{
      post_uuid: event.uuid,
      likes: event.likes,
      dislikes: event.dislikes
    })
  end)
end
