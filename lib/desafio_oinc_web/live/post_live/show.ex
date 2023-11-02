defmodule DesafioOincWeb.PostLive.Show do
  use DesafioOincWeb, :live_view

  alias DesafioOinc.Blog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:ok, post} = Blog.find_post(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, post)}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
