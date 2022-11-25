defmodule LiveMovieWeb.GenreLive.FormComponent do
  use LiveMovieWeb, :live_component

  alias LiveMovie.Movies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage genre records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="genre-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Genre</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{genre: genre} = assigns, socket) do
    changeset = Movies.change_genre(genre)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"genre" => genre_params}, socket) do
    changeset =
      socket.assigns.genre
      |> Movies.change_genre(genre_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"genre" => genre_params}, socket) do
    save_genre(socket, socket.assigns.action, genre_params)
  end

  defp save_genre(socket, :edit, genre_params) do
    case Movies.update_genre(socket.assigns.genre, genre_params) do
      {:ok, _genre} ->
        {:noreply,
         socket
         |> put_flash(:info, "Genre updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_genre(socket, :new, genre_params) do
    case Movies.create_genre(genre_params) do
      {:ok, _genre} ->
        {:noreply,
         socket
         |> put_flash(:info, "Genre created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
