defmodule DesafioOinc.Blog.Aggregates.Post do
  defstruct uuid: nil, title: nil, text: nil, likes: 0, dislikes: 0, tags: []

  alias DesafioOinc.Blog.Aggregates.Post

  alias DesafioOinc.Blog.Commands.CreatePost

  alias DesafioOinc.Blog.Events.PostCreated

  def execute(%Post{uuid: nil}, %CreatePost{} = command)
      when command.text == "" or command.title == "" do
    {:error, :invalid_post_content}
  end

  def execute(%Post{uuid: nil}, %CreatePost{} = command) do
    %PostCreated{
      uuid: command.post_uuid,
      title: command.title,
      text: command.text,
      tags: command.tags
    }
  end

  def apply(%Post{}, %PostCreated{} = event) do
    %Post{uuid: event.uuid, title: event.title, text: event.text}
  end
end
