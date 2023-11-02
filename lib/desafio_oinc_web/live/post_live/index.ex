defmodule DesafioOincWeb.PostLive.Index do
  use DesafioOincWeb, :live_view

  alias DesafioOinc.Blog
  alias DesafioOinc.Blog.Projections.Post

  @impl true
  def mount(_params, _session, socket) do
    {:ok, posts} = Blog.get_posts(100, 1)

    posts = Enum.map(posts, fn post -> {post.uuid, post} end)

    socket = assign(socket, :posts, posts)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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
    {:noreply, assign(socket, :posts, posts ++ [{post.uuid, post}])}
  end

  @impl true
  def handle_info({DesafioOincWeb.PostLive.FormComponent, {:updated, post}}, socket) do
    posts =
      Map.get(socket, :assigns)
      |> Map.get(:posts)
      |> Enum.map(fn {uuid, _p} = p ->
        if uuid == post.uuid do
          {uuid, post}
        else
          p
        end
      end)

    {:noreply, assign(socket, :posts, posts)}
  end
end
