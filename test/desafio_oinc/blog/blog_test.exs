defmodule DesafioOinc.Blog.BlogTest do
  use DesafioOinc.DataCase

  alias DesafioOinc.Repo

  describe "create_post/1" do
    test "creates a post with a ratings entity" do
      post = DesafioOinc.Blog.create_post("title", "text")

      assert not is_nil(post.uuid)
      assert post.title == "title"
      assert post.text == "text"

      post = Repo.preload(post, :rating)

      assert post.rating.likes == 0
      assert post.rating.dislikes == 0
    end
  end
end
