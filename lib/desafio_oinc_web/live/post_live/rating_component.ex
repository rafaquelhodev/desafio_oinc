defmodule DesafioOincWeb.PostLive.RatingComponent do
  use DesafioOincWeb, :live_component

  alias DesafioOinc.Blog

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.button phx-click="like" phx-target={@myself} class="like-button">
        <%= @post.rating.likes %> Likes
      </.button>
      <.button phx-click="dislike" phx-target={@myself} class="dislike-button">
        <%= @post.rating.dislikes %> Dislikes
      </.button>
    </div>
    """
  end

  @impl true
  def handle_event("like", _params, socket) do
    case Blog.like_post(socket.assigns.post.uuid) do
      {:ok, post} ->
        {:noreply,
         socket
         |> push_patch(to: socket.assigns.patch)}

      _error ->
        {:noreply,
         socket
         |> push_patch(to: socket.assigns.patch)}
    end
  end

  @impl true
  def handle_event("dislike", _params, socket) do
    case Blog.dislike_post(socket.assigns.post.uuid) do
      {:ok, post} ->
        {:noreply,
         socket
         |> push_patch(to: socket.assigns.patch)}

      _error ->
        {:noreply,
         socket
         |> push_patch(to: socket.assigns.patch)}
    end
  end
end
