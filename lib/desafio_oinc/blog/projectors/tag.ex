defmodule DesafioOinc.Blog.Projectors.Tag do
  use Commanded.Projections.Ecto,
    application: DesafioOinc.App,
    repo: DesafioOinc.Repo,
    name: "Blog.Projectors.Tag",
    consistency: :strong

  alias DesafioOinc.Blog.Projections.Tag
  alias DesafioOinc.Blog.Events.TagCreated

  project(%TagCreated{} = event, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :post, %Tag{uuid: event.uuid, name: event.name})
  end)
end
