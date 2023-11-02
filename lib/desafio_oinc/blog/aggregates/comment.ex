defmodule DesafioOinc.Blog.Aggregates.Comment do
  defstruct uuid: nil,
            text: nil,
            post_uuid: nil

  alias DesafioOinc.Blog.Aggregates.Comment

  alias DesafioOinc.Blog.Commands.AddComment

  alias DesafioOinc.Blog.Events.CommentCreated

  def execute(%Comment{uuid: nil}, %AddComment{} = command)
      when length(command.text) >= 254 do
    {:error, :comment_too_big}
  end

  def execute(%Comment{uuid: nil}, %AddComment{} = command) do
    %CommentCreated{
      uuid: command.comment_uuid,
      post_uuid: command.post_uuid,
      text: command.text
    }
  end

  def apply(%Comment{}, %CommentCreated{} = event) do
    %Comment{uuid: event.uuid, post_uuid: event.post_uuid, text: event.text}
  end
end
