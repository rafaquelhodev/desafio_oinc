defmodule DesafioOincWeb.PostLive.AddTagComponent do
  use DesafioOincWeb, :live_component

  alias DesafioOinc.Blog.Projections.Post
  alias DesafioOinc.Blog

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage post records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="post-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:new_tags]} type="select" options={@new_tags} label="New tag" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Post</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{post: post, tags: tags} = assigns, socket) do
    changeset = Post.changeset(post)

    tags = Enum.map(tags, fn t -> {t.name, t.uuid} end)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(new_tags: tags)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Post.changeset(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"post" => %{"new_tags" => new_tag_uuid}}, socket) do
    case Blog.add_tag_to_post(socket.assigns.post.uuid, new_tag_uuid) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tag added successfully")
         |> push_patch(to: socket.assigns.patch)}

      _error ->
        {:noreply,
         socket
         |> put_flash(:error, "Error adding Tag")
         |> push_patch(to: socket.assigns.patch)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
