defmodule DesafioOinc.Blog.Aggregates.Post do
  defstruct uuid: nil,
            title: nil,
            text: nil,
            likes: 0,
            dislikes: 0,
            tags: MapSet.new()

  alias DesafioOinc.Blog.Events.PostUpdated
  alias DesafioOinc.Blog.Commands.UpdatePost
  alias DesafioOinc.Blog.Aggregates.Post

  alias DesafioOinc.Blog.Commands.CreatePost
  alias DesafioOinc.Blog.Commands.AddPostTag
  alias DesafioOinc.Blog.Commands.LikePost
  alias DesafioOinc.Blog.Commands.DislikePost

  alias DesafioOinc.Blog.Events.PostCreated
  alias DesafioOinc.Blog.Events.PostTagAdded
  alias DesafioOinc.Blog.Events.PostLiked
  alias DesafioOinc.Blog.Events.PostDisliked

  def execute(%Post{uuid: nil}, %CreatePost{} = command)
      when command.text == "" or command.title == "" do
    {:error, :invalid_post_content}
  end

  def execute(%Post{uuid: nil}, %CreatePost{} = command) do
    %PostCreated{
      uuid: command.post_uuid,
      title: command.title,
      text: command.text,
      tags: command.tags,
      likes: 0,
      dislikes: 0
    }
  end

  def execute(%Post{uuid: uuid}, %AddPostTag{} = command) do
    %PostTagAdded{
      added_tag_uuid: command.new_tag_uuid,
      uuid: uuid
    }
  end

  def execute(%Post{uuid: uuid, likes: likes}, %LikePost{}) do
    %PostLiked{
      uuid: uuid,
      likes: likes + 1
    }
  end

  def execute(%Post{uuid: uuid, dislikes: dislikes}, %DislikePost{}) do
    %PostDisliked{
      uuid: uuid,
      dislikes: dislikes + 1
    }
  end

  def execute(%Post{uuid: uuid}, %UpdatePost{} = command) do
    %PostUpdated{
      uuid: uuid,
      title: command.title,
      text: command.text
    }
  end

  def apply(%Post{}, %PostCreated{} = event) do
    %Post{uuid: event.uuid, title: event.title, text: event.text}
  end

  def apply(%Post{tags: tags} = post, %PostTagAdded{} = event) do
    %Post{post | tags: MapSet.put(tags, event.added_tag_uuid)}
  end

  def apply(%Post{} = post, %PostLiked{} = event) do
    %Post{post | likes: event.likes}
  end

  def apply(%Post{} = post, %PostDisliked{} = event) do
    %Post{post | dislikes: event.dislikes}
  end

  def apply(%Post{} = post, %PostUpdated{} = event) do
    %Post{post | title: event.title, text: event.text}
  end
end
