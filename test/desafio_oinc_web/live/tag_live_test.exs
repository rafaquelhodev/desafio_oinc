defmodule DesafioOincWeb.TagLiveTest do
  use DesafioOincWeb.ConnCase

  import Phoenix.LiveViewTest
  alias DesafioOinc.Fixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_tag(_) do
    tag = Fixtures.create_tag()
    %{tag: tag}
  end

  describe "Index" do
    setup [:create_tag]

    test "lists all tags", %{conn: conn, tag: tag} do
      {:ok, _index_live, html} = live(conn, ~p"/tags")

      assert html =~ "Listing Tags"
      assert html =~ tag.name
    end

    test "saves new tag", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tags")

      assert index_live |> element("a", "New Tag") |> render_click() =~
               "New Tag"

      assert_patch(index_live, ~p"/tags/new")

      assert index_live
             |> form("#tag-form", tag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#tag-form", tag: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tags")

      html = render(index_live)
      assert html =~ "Tag created successfully"
      assert html =~ "some name"
    end

    test "updates tag in listing", %{conn: conn, tag: tag} do
      {:ok, index_live, _html} = live(conn, ~p"/tags")

      assert index_live |> element("#tags-#{tag.uuid} a", "Edit") |> render_click() =~
               "Edit Tag"

      assert_patch(index_live, ~p"/tags/#{tag.uuid}/edit")

      assert index_live
             |> form("#tag-form", tag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#tag-form", tag: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tags")

      html = render(index_live)
      assert html =~ "Tag updated successfully"
      assert html =~ "some updated name"
    end
  end

  describe "Show" do
    setup [:create_tag]

    test "displays tag", %{conn: conn, tag: tag} do
      {:ok, _show_live, html} = live(conn, ~p"/tags/#{tag.uuid}")

      assert html =~ "Show Tag"
      assert html =~ tag.name
    end

    test "updates tag within modal", %{conn: conn, tag: tag} do
      {:ok, show_live, _html} = live(conn, ~p"/tags/#{tag.uuid}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tag"

      assert_patch(show_live, ~p"/tags/#{tag.uuid}/show/edit")

      assert show_live
             |> form("#tag-form", tag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#tag-form", tag: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/tags/#{tag.uuid}")

      html = render(show_live)
      assert html =~ "Tag updated successfully"
      assert html =~ "some updated name"
    end
  end
end
