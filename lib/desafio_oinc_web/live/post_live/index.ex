defmodule DesafioOincWeb.PostLive.Index do
  use DesafioOincWeb, :live_view

  alias DesafioOinc.Blog
  alias DesafioOinc.Blog.Projections.Post

  alias DesafioOinc.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, posts} = Blog.get_posts(100, 1)

    posts =
      Enum.map(posts, fn post ->
        post = Repo.preload(post, :tags)
        {post.uuid, post}
      end)

    socket = assign(socket, :posts, posts)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :tag, %{"id" => id}) do
    {:ok, tags} = Blog.get_tags()

    {:ok, post} = Blog.find_post(id)
    post = Repo.preload(post, :tags)

    tags =
      Enum.filter(tags, fn tag ->
        tag not in post.tags
      end)

    socket
    |> assign(:page_title, "Add Tag")
    |> assign(:post, post)
    |> assign(:tags, tags)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    {:ok, post} = Blog.find_post(id)

    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, post)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({DesafioOincWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    posts = Map.get(socket, :assigns) |> Map.get(:posts)

    post = Map.put(post, :tags, [])

    {:noreply, assign(socket, :posts, [{post.uuid, post}] ++ posts)}
  end

  @impl true
  def handle_info({DesafioOincWeb.PostLive.FormComponent, {:updated, post}}, socket) do
    posts =
      Map.get(socket, :assigns)
      |> Map.get(:posts)
      |> Enum.map(fn {uuid, current_post} = p ->
        if uuid == post.uuid do
          post = Map.put(post, :tags, current_post.tags)
          {uuid, post}
        else
          p
        end
      end)

    {:noreply, assign(socket, :posts, posts)}
  end

  @impl true
  def handle_info(
        {DesafioOincWeb.PostLive.AddTagComponent, {:tag_added, post, new_tag_uuid}},
        socket
      ) do
    {:ok, new_tag} = Blog.get_tag(new_tag_uuid)

    posts =
      Map.get(socket, :assigns)
      |> Map.get(:posts)
      |> Enum.map(fn {uuid, current_post} = p ->
        if uuid == post.uuid do
          tags = Map.get(current_post, :tags)
          {uuid, %{current_post | tags: tags ++ [new_tag]}}
        else
          p
        end
      end)

    {:noreply, assign(socket, :posts, posts)}
  end
end
