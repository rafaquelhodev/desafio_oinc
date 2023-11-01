defmodule DesafioOinc.Blog.Events.PostTagAdded do
  @derive Jason.Encoder
  defstruct [:uuid, :added_tag_uuid]
end
