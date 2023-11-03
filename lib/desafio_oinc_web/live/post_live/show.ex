defmodule DesafioOincWeb.PostLive.Show do
  use DesafioOincWeb, :live_view

  alias DesafioOinc.Blog
  alias DesafioOinc.Blog.Projections.Comment
  alias DesafioOinc.Notifications

  alias DesafioOinc.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:ok, post} = Blog.find_post(id)

    Notifications.subscribe("post-#{id}")

    post =
      post
      |> Repo.preload(:comments)
      |> Repo.preload(:rating)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, post)
     |> assign(:comment, %Comment{text: ""})}
  end

  @impl true
  def handle_info(
        {DesafioOincWeb.PostLive.AddCommentComponent, {:comment_added, _comment}},
        socket
      ) do
    {:noreply, assign(socket, :post, socket.assigns.post)}
  end

  @impl true
  def handle_info(
        {DesafioOincWeb.PostLive.FormComponent, _msg},
        socket
      ) do
    {:noreply, socket}
  end

  def handle_info({Notifications, :comment_added, comment}, socket) do
    post = socket.assigns.post

    post =
      unless Enum.any?(post.comments, fn c -> c.uuid == comment.uuid end) do
        Map.put(post, :comments, post.comments ++ [comment])
      else
        post
      end

    {:noreply, socket |> assign(:post, post)}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
