defmodule HoldenChatWeb.RoomLive.Show do
  use HoldenChatWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Room {@room.id}
        <:subtitle>This is a room record from your database.</:subtitle>

        <:actions>
          <.button navigate={~p"/rooms"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/rooms/#{@room}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit Room
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Id">{@room.id}</:item>

        <:item title="Title">{@room.title}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Room")
     |> assign(:room, Ash.get!(HoldenChat.Chat.Room, id))}
  end
end
