defmodule DesafioOincWeb.PostLiveTest do
  use DesafioOincWeb.ConnCase

  import Phoenix.LiveViewTest
  alias DesafioOinc.Fixtures

  @create_attrs %{text: "some text", title: "some title"}
  @update_attrs %{text: "some updated text", title: "some updated title"}
  @invalid_attrs %{text: nil, title: nil}

  defp create_post(_) do
    post = Fixtures.create_post()
    %{post: post}
  end

  describe "Index" do
    setup [:create_post]

    test "lists all posts", %{conn: conn, post: post} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Listing Posts"
      assert html =~ post.text
    end

    test "saves new post", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("a", "New Post") |> render_click() =~
               "New Post"

      assert_patch(index_live, ~p"/posts/new")

      assert index_live
             |> form("#post-form", post: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#post-form", post: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/")

      html = render(index_live)
      assert html =~ "Post created successfully"
      assert html =~ "some text"
    end

    test "updates post in listing", %{conn: conn, post: post} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live
             |> element(~s{[href="/posts/#{post.uuid}/edit"]}, "Edit")
             |> render_click() =~
               "Edit Post"

      assert_patch(index_live, ~p"/posts/#{post.uuid}/edit")

      assert index_live
             |> form("#post-form", post: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#post-form", post: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/")

      html = render(index_live)
      assert html =~ "Post updated successfully"
      assert html =~ "some updated text"
    end

    test "adds a tag to a post", %{conn: conn, post: post} do
      tag = Fixtures.create_tag()

      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live
             |> element(~s{[href="/posts/#{post.uuid}/tag"]}, "Add tag")
             |> render_click() =~
               "Add Tag"

      assert_patch(index_live, ~p"/posts/#{post.uuid}/tag")

      assert index_live
             |> form("#post-form", post: %{new_tags: tag.uuid})
             |> render_submit()

      assert_patch(index_live, ~p"/")

      html = render(index_live)
      assert html =~ "Tag added successfully"
    end
  end

  describe "Show" do
    setup [:create_post]

    test "displays post", %{conn: conn, post: post} do
      {:ok, _show_live, html} = live(conn, ~p"/posts/#{post.uuid}")

      assert html =~ "Show Post"
      assert html =~ post.text
    end

    test "updates post within modal", %{conn: conn, post: post} do
      {:ok, show_live, _html} = live(conn, ~p"/posts/#{post.uuid}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Post"

      assert_patch(show_live, ~p"/posts/#{post.uuid}/show/edit")

      assert show_live
             |> form("#post-form", post: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#post-form", post: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/posts/#{post.uuid}")

      html = render(show_live)
      assert html =~ "Post updated successfully"
      assert html =~ "some updated text"
    end

    test "likes a post", %{conn: conn, post: post} do
      {:ok, show_live, _html} = live(conn, ~p"/posts/#{post.uuid}")

      show_live |> element("button", "Likes") |> render_click()

      html = render(show_live)
      assert html =~ "1 Likes"
    end

    test "dislikes a post", %{conn: conn, post: post} do
      {:ok, show_live, _html} = live(conn, ~p"/posts/#{post.uuid}")

      show_live |> element("button", "Dislikes") |> render_click()

      html = render(show_live)
      assert html =~ "1 Dislikes"
    end
  end
end
