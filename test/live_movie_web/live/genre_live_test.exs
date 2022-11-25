defmodule LiveMovieWeb.GenreLiveTest do
  use LiveMovieWeb.ConnCase

  import Phoenix.LiveViewTest
  import LiveMovie.MoviesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_genre(_) do
    genre = genre_fixture()
    %{genre: genre}
  end

  describe "Index" do
    setup [:create_genre]

    test "lists all genres", %{conn: conn, genre: genre} do
      {:ok, _index_live, html} = live(conn, ~p"/genres")

      assert html =~ "Listing Genres"
      assert html =~ genre.name
    end

    test "saves new genre", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/genres")

      assert index_live |> element("a", "New Genre") |> render_click() =~
               "New Genre"

      assert_patch(index_live, ~p"/genres/new")

      assert index_live
             |> form("#genre-form", genre: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#genre-form", genre: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/genres")

      assert html =~ "Genre created successfully"
      assert html =~ "some name"
    end

    test "updates genre in listing", %{conn: conn, genre: genre} do
      {:ok, index_live, _html} = live(conn, ~p"/genres")

      assert index_live |> element("#genres-#{genre.id} a", "Edit") |> render_click() =~
               "Edit Genre"

      assert_patch(index_live, ~p"/genres/#{genre}/edit")

      assert index_live
             |> form("#genre-form", genre: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#genre-form", genre: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/genres")

      assert html =~ "Genre updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes genre in listing", %{conn: conn, genre: genre} do
      {:ok, index_live, _html} = live(conn, ~p"/genres")

      assert index_live |> element("#genres-#{genre.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#genre-#{genre.id}")
    end
  end

  describe "Show" do
    setup [:create_genre]

    test "displays genre", %{conn: conn, genre: genre} do
      {:ok, _show_live, html} = live(conn, ~p"/genres/#{genre}")

      assert html =~ "Show Genre"
      assert html =~ genre.name
    end

    test "updates genre within modal", %{conn: conn, genre: genre} do
      {:ok, show_live, _html} = live(conn, ~p"/genres/#{genre}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Genre"

      assert_patch(show_live, ~p"/genres/#{genre}/show/edit")

      assert show_live
             |> form("#genre-form", genre: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#genre-form", genre: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/genres/#{genre}")

      assert html =~ "Genre updated successfully"
      assert html =~ "some updated name"
    end
  end
end
