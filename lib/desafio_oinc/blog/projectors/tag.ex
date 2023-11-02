defmodule DesafioOinc.Blog.Projectors.Tag do
  use Commanded.Projections.Ecto,
    application: DesafioOinc.App,
    repo: DesafioOinc.Repo,
    name: "Blog.Projectors.Tag",
    consistency: :strong

  alias DesafioOinc.Blog.Projections.Tag
  alias DesafioOinc.Blog.Events.TagCreated
  alias DesafioOinc.Blog.Events.TagUpdated

  alias DesafioOinc.Repo

  project(%TagCreated{} = event, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :post, %Tag{uuid: event.uuid, name: event.name})
  end)

  project(%TagUpdated{} = event, _metadata, fn multi ->
    multi
    |> Ecto.Multi.run(:tag, fn _repo, _changes -> get_tag(event.uuid) end)
    |> Ecto.Multi.run(:update_tag, fn _repo, %{tag: tag} ->
      tag
      |> Ecto.Changeset.change(name: event.name)
      |> Repo.update()
    end)
  end)

  defp get_tag(tag_uuid) do
    case Repo.get(Tag, tag_uuid) do
      nil -> {:error, :tag_not_found}
      tag -> {:ok, tag}
    end
  end
end
