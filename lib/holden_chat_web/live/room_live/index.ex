defmodule HoldenChatWeb.RoomLive.Index do
  use HoldenChatWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Rooms
        <:actions>
          <.button variant="primary" navigate={~p"/rooms/new"}>
            <.icon name="hero-plus" /> New Room
          </.button>
        </:actions>
      </.header>

      <.table
        id="rooms"
        rows={@streams.rooms}
        row_click={fn {_id, room} -> JS.navigate(~p"/rooms/#{room}") end}
      >
        <:col :let={{_id, room}} label="Id">{room.id}</:col>

        <:col :let={{_id, room}} label="Title">{room.title}</:col>

        <:action :let={{_id, room}}>
          <div class="sr-only">
            <.link navigate={~p"/rooms/#{room}"}>Show</.link>
          </div>

          <.link navigate={~p"/rooms/#{room}/edit"}>Edit</.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Rooms")
     |> stream(:rooms, Ash.read!(HoldenChat.Chat.Room))}
  end
end
