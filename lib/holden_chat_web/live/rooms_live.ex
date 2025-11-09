defmodule HoldenChatWeb.RoomsLive do
  use HoldenChatWeb, :live_view

  def ok(socket), do: {:ok, socket}
  def halt(socket), do: {:halt, socket}
  def continue(socket), do: {:cont, socket}
  def noreply(socket), do: {:noreply, socket}

  def render(assigns) do
    ~H"""
    <%!-- New room Button --%>
    <.button id="create-room-button" phx-click={JS.navigate(~p"/rooms/create")}>
      <.icon name="hero-plus-solid" />
    </.button>

    <%!-- List room records --%>
    <h1>{gettext("rooms")}</h1>

    <.table id="knowledge-base-rooms" rows={@rooms}>
      <:col :let={row} label={gettext("Name")}>{row.name}</:col>
      <:col :let={row} label={gettext("Description")}>{row.description}</:col>
      <:action :let={row}>
        <%!-- Edit room button --%>
        <.button
          id={"edit-button-#{row.id}"}
          phx-click={JS.navigate(~p"/rooms/#{row.id}")}
          class="bg-white
           text-zinc-500
           hover:bg-white
           hover:text-zinc-900
           hover:underline"
        >
          <.icon name="hero-pencil-solid" />
        </.button>

        <%!-- Delete room Button --%>
        <.button
          id={"delete-button-#{row.id}"}
          phx-click={"delete-#{row.id}"}
          class="bg-white
          text-zinc-500
          hover:bg-white
          hover:text-zinc-900"
        >
          <.icon name="hero-trash-solid" />
        </.button>
      </:action>
    </.table>
    """
  end

  def mount(_params, _session, socket) do
    socket
    |> assign_rooms()
    |> ok()
  end

  # Responds when a user clicks on trash button
  def handle_event("delete-" <> room_id, _params, socket) do
    case destroy_record(room_id) do
      :ok ->
        socket
        |> put_flash(:info, "room deleted successfully")
        |> noreply()

      {:error, _error} ->
        socket
        |> put_flash(:error, "Unable to delete room")
        |> noreply()
    end
  end

  defp assign_rooms(socket) do
    {:ok, rooms} =
      HoldenChat.KnowledgeBase.room()
      |> Ash.read()

    assign(socket, :rooms, rooms)
  end

  defp destroy_record(room_id) do
    HoldenChat.KnowledgeBase.room()
    |> Ash.get!(room_id)
    |> Ash.destroy()
  end
end
