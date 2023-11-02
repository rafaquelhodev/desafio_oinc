defmodule DesafioOinc.Blog.Projectors.Comment do
  use Commanded.Projections.Ecto,
    application: DesafioOinc.App,
    repo: DesafioOinc.Repo,
    name: "Blog.Projectors.Comment",
    consistency: :strong

  alias DesafioOinc.Blog.Projections.Comment

  alias DesafioOinc.Blog.Events.CommentCreated

  require Logger

  project(%CommentCreated{} = event, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :comment, %Comment{
      uuid: event.uuid,
      text: event.text,
      post_uuid: event.post_uuid
    })
  end)

  def error({:error, %Ecto.ConstraintError{} = error}, _event, _failure_context) do
    Logger.error(fn -> "Failed due to constraint error: " <> inspect(error) end)

    :skip
  end
end
