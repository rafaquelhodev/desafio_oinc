defmodule DesafioOinc.Blog.Aggregates.Post do
  defstruct uuid: nil, title: nil, text: nil, likes: 0, dislikes: 0, tags: MapSet.new()

  alias DesafioOinc.Blog.Aggregates.Post

  alias DesafioOinc.Blog.Commands.CreatePost
  alias DesafioOinc.Blog.Commands.AddPostTag

  alias DesafioOinc.Blog.Events.PostCreated
  alias DesafioOinc.Blog.Events.PostTagAdded

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

  def execute(%Post{uuid: uuid}, %AddPostTag{} = command) do
    %PostTagAdded{
      added_tag_uuid: command.new_tag_uuid,
      uuid: uuid
    }
  end

  def apply(%Post{}, %PostCreated{} = event) do
    %Post{uuid: event.uuid, title: event.title, text: event.text}
  end

  def apply(post = %Post{tags: tags}, %PostTagAdded{} = event) do
    %Post{post | tags: MapSet.put(tags, event.added_tag_uuid)}
  end
end
