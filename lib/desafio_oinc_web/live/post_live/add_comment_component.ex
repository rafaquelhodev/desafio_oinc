defmodule DesafioOincWeb.PostLive.AddCommentComponent do
  use DesafioOincWeb, :live_component

  alias DesafioOinc.Blog.Projections.Comment
  alias DesafioOinc.Blog

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="comment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:text]} type="textarea" placeholder="Add a comment" />

        <:actions>
          <.button phx-disable-with="Saving...">Add comment</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{comment: comment} = assigns, socket) do
    changeset = Comment.changeset(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment}, socket) do
    changeset =
      socket.assigns.comment
      |> Comment.changeset(comment)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"comment" => comment}, socket) do
    case Blog.comment_post(socket.assigns.post.uuid, comment["text"]) do
      {:ok, new_comment} ->
        notify_parent({:comment_added, new_comment})

        {:noreply,
         socket
         |> put_flash(:info, "Comment added successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, :comment_too_big} ->
        {:noreply,
         socket
         |> put_flash(:error, "Comments must be less than 254 characteres!")
         |> push_patch(to: socket.assigns.patch)}

      _error ->
        {:noreply,
         socket
         |> put_flash(:error, "Error adding comment")
         |> push_patch(to: socket.assigns.patch)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
