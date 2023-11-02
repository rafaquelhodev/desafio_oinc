defmodule DesafioOinc.Blog.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        DesafioOinc.Blog.Projectors.Post,
        DesafioOinc.Blog.Projectors.Tag,
        DesafioOinc.Blog.Projectors.Comment
      ],
      strategy: :one_for_one
    )
  end
end
