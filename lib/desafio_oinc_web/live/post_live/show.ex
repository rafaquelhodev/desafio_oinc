defmodule DesafioOincWeb.PostLive.Show do
  use DesafioOincWeb, :live_view

  alias DesafioOinc.Blog
  alias DesafioOinc.Blog.Projections.Comment

  alias DesafioOinc.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:ok, post} = Blog.find_post(id)
    post = Repo.preload(post, :comments)

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

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
