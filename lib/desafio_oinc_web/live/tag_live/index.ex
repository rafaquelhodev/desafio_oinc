defmodule DesafioOincWeb.TagLive.Index do
  use DesafioOincWeb, :live_view

  alias DesafioOinc.Blog
  alias DesafioOinc.Blog.Projections.Tag

  @impl true
  def mount(_params, _session, socket) do
    {:ok, tags} = Blog.get_tags()

    socket =
      socket
      |> stream_configure(:tags, dom_id: &"tags-#{&1.uuid}")
      |> stream(:tags, tags)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    {:ok, tag} = Blog.get_tag(id)

    socket
    |> assign(:page_title, "Edit Tag")
    |> assign(:tag, tag)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tag")
    |> assign(:tag, %Tag{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tags")
    |> assign(:tag, nil)
  end

  @impl true
  def handle_info({DesafioOincWeb.TagLive.FormComponent, {:saved, tag}}, socket) do
    {:noreply, stream_insert(socket, :tags, tag)}
  end
end
