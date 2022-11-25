defmodule LiveMovieWeb.GenreLive.Show do
  use LiveMovieWeb, :live_view

  alias LiveMovie.Movies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:genre, Movies.get_genre!(id))}
  end

  defp page_title(:show), do: "Show Genre"
  defp page_title(:edit), do: "Edit Genre"
end
