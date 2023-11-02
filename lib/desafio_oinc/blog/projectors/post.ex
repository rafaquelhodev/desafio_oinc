defmodule DesafioOinc.Blog.Projectors.Post do
  use Commanded.Projections.Ecto,
    application: DesafioOinc.App,
    repo: DesafioOinc.Repo,
    name: "Blog.Projectors.Post",
    consistency: :strong

  alias DesafioOinc.Blog.Events.PostUpdated
  alias DesafioOinc.Blog.Projections.Rating
  alias DesafioOinc.Blog.Projections.Post
  alias DesafioOinc.Blog.Projections.PostTag

  alias DesafioOinc.Blog.Events.PostCreated
  alias DesafioOinc.Blog.Events.PostTagAdded
  alias DesafioOinc.Blog.Events.PostDisliked
  alias DesafioOinc.Blog.Events.PostLiked

  alias DesafioOinc.Repo

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

  project(%PostLiked{} = event, _metadata, fn multi ->
    multi
    |> Ecto.Multi.run(:post_rating, fn _repo, _changes -> get_rating(event.uuid) end)
    |> Ecto.Multi.run(:update_post_rating, fn _repo, %{post_rating: rating} ->
      rating
      |> Ecto.Changeset.change(likes: event.likes)
      |> Repo.update()
    end)
  end)

  project(%PostDisliked{} = event, _metadata, fn multi ->
    multi
    |> Ecto.Multi.run(:post_rating, fn _repo, _changes -> get_rating(event.uuid) end)
    |> Ecto.Multi.run(:update_post_rating, fn _repo, %{post_rating: rating} ->
      rating
      |> Ecto.Changeset.change(dislikes: event.dislikes)
      |> Repo.update()
    end)
  end)

  project(%PostUpdated{} = event, _metadata, fn multi ->
    multi
    |> Ecto.Multi.run(:post, fn _repo, _changes -> get_post(event.uuid) end)
    |> Ecto.Multi.run(:update_post, fn _repo, %{post: post} ->
      post
      |> Ecto.Changeset.change(text: event.text, title: event.title)
      |> Repo.update()
    end)
  end)

  def error({:error, %Ecto.ConstraintError{} = error}, _event, _failure_context) do
    Logger.error(fn -> "Failed due to constraint error: " <> inspect(error) end)

    :skip
  end

  defp get_rating(post_uuid) do
    case Repo.get(Rating, post_uuid) do
      nil -> {:error, :rating_not_found}
      rating -> {:ok, rating}
    end
  end

  defp get_post(post_uuid) do
    case Repo.get(Post, post_uuid) do
      nil -> {:error, :post_not_found}
      post -> {:ok, post}
    end
  end
end
