defmodule DesafioOinc.Blog do
  alias DesafioOinc.Blog.Commands.UpdateTag
  alias DesafioOinc.Blog.Commands.UpdatePost
  alias DesafioOinc.Blog.Commands.AddComment
  alias DesafioOinc.App
  alias DesafioOinc.Repo

  alias DesafioOinc.Blog.Commands.AddComment
  alias DesafioOinc.Blog.Commands.CreateTag
  alias DesafioOinc.Blog.Commands.CreatePost
  alias DesafioOinc.Blog.Commands.AddPostTag
  alias DesafioOinc.Blog.Commands.DislikePost
  alias DesafioOinc.Blog.Commands.LikePost

  alias DesafioOinc.Blog.Projections.Tag
  alias DesafioOinc.Blog.Projections.Post
  alias DesafioOinc.Blog.Projections.Comment

  alias DesafioOinc.Blog.Queries.CommentsQuery
  alias DesafioOinc.Blog.Queries.PostsQuery
  alias DesafioOinc.Blog.Queries.TagsQuery

  def create_post(title, text) do
    uuid = Ecto.UUID.generate()

    dispatch =
      %CreatePost{}
      |> CreatePost.assign_uuid(uuid)
      |> CreatePost.add_title(title)
      |> CreatePost.add_text(text)
      |> App.dispatch(consistency: :strong)

    case dispatch do
      :ok -> {:ok, Repo.get(Post, uuid)}
      error -> error
    end
  end

  def update_post(uuid, title, text) do
    dispatch =
      %UpdatePost{}
      |> UpdatePost.assign_uuid(uuid)
      |> UpdatePost.add_title(title)
      |> UpdatePost.add_text(text)
      |> App.dispatch(consistency: :strong)

    case dispatch do
      :ok -> {:ok, Repo.get(Post, uuid)}
      error -> error
    end
  end

  def get_tag(uuid) do
    case Repo.get(Tag, uuid) do
      nil -> {:error, :not_found}
      tag -> {:ok, tag}
    end
  end

  def create_tag(name) do
    uuid = Ecto.UUID.generate()

    dispatch =
      %CreateTag{}
      |> CreateTag.add_name(name)
      |> CreateTag.assign_uuid(uuid)
      |> App.dispatch(consistency: :strong)

    case dispatch do
      :ok -> {:ok, Repo.get(Tag, uuid)}
      error -> error
    end
  end

  def update_tag(uuid, name) do
    dispatch =
      %UpdateTag{}
      |> UpdateTag.assign_uuid(uuid)
      |> UpdateTag.add_name(name)
      |> App.dispatch(consistency: :strong)

    case dispatch do
      :ok -> {:ok, Repo.get(Tag, uuid)}
      error -> error
    end
  end

  def add_tag_to_post(post_uuid, tag_uuid) do
    dispatch =
      %AddPostTag{}
      |> AddPostTag.assign_tag(tag_uuid)
      |> AddPostTag.assign_uuid(post_uuid)
      |> App.dispatch(consistency: :strong)

    case dispatch do
      :ok -> {:ok, Repo.get(Post, post_uuid)}
      error -> error
    end
  end

  def like_post(post_uuid) do
    dispatch =
      %LikePost{} |> LikePost.assign_uuid(post_uuid) |> App.dispatch(consistency: :strong)

    case dispatch do
      :ok -> {:ok, Repo.get(Post, post_uuid)}
      error -> error
    end
  end

  def dislike_post(post_uuid) do
    dispatch =
      %DislikePost{} |> DislikePost.assign_uuid(post_uuid) |> App.dispatch(consistency: :strong)

    case dispatch do
      :ok -> {:ok, Repo.get(Post, post_uuid)}
      error -> error
    end
  end

  def comment_post(post_uuid, comment_body) do
    uuid = Ecto.UUID.generate()

    dispatch =
      %AddComment{}
      |> AddComment.assign_uuid(uuid)
      |> AddComment.assign_post(post_uuid)
      |> AddComment.add_comment(comment_body)
      |> App.dispatch(consistency: :strong)

    case dispatch do
      :ok -> {:ok, Repo.get(Comment, uuid)}
      error -> error
    end
  end

  def find_post(post_uuid) do
    case Repo.get(Post, post_uuid) do
      nil -> {:error, :not_found}
      post -> {:ok, post}
    end
  end

  def get_comments_from_post(post_uuid) do
    post_uuid
    |> CommentsQuery.comments_from_post()
    |> Repo.all()
  end

  def get_post_tags(post) do
    Repo.preload(post, :tags) |> Map.get(:tags)
  end

  def get_post_rating(post) do
    Repo.preload(post, :rating) |> Map.get(:rating)
  end

  def get_posts(limit, page) do
    posts = limit |> PostsQuery.get_posts(page) |> Repo.all()
    {:ok, posts}
  end

  def get_tags() do
    {:ok, TagsQuery.get_tags() |> Repo.all()}
  end
end
