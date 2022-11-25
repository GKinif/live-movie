defmodule LiveMovie.MoviesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveMovie.Movies` context.
  """

  @doc """
  Generate a genre.
  """
  def genre_fixture(attrs \\ %{}) do
    {:ok, genre} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> LiveMovie.Movies.create_genre()

    genre
  end
end
