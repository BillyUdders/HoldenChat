defmodule HoldenChatWeb.RoomLive.Form do
  use HoldenChatWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage room records in your database.</:subtitle>
      </.header>

      <.form
        for={@form}
        id="room-form"
        phx-change="validate"
        phx-submit="save"
      >
        <%= if @form.source.type == :create do %>
          <.input field={@form[:title]} type="text" label="Title" />
        <% end %>
        <%= if @form.source.type == :update do %>
        <% end %>

        <.button phx-disable-with="Saving..." variant="primary">Save Room</.button>
        <.button navigate={return_path(@return_to, @room)}>Cancel</.button>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    room =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(HoldenChat.Chat.Room, id)
      end

    action = if is_nil(room), do: "New", else: "Edit"
    page_title = action <> " " <> "Room"

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(room: room)
     |> assign(:page_title, page_title)
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"room" => room_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, room_params))}
  end

  def handle_event("save", %{"room" => room_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: room_params) do
      {:ok, room} ->
        notify_parent({:saved, room})

        socket =
          socket
          |> put_flash(:info, "Room #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, room))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{room: room}} = socket) do
    form =
      if room do
        AshPhoenix.Form.for_update(room, :close, as: "room")
      else
        AshPhoenix.Form.for_create(HoldenChat.Chat.Room, :open, as: "room")
      end

    assign(socket, form: to_form(form))
  end

  defp return_path("index", _room), do: ~p"/rooms"
  defp return_path("show", room), do: ~p"/rooms/#{room.id}"
end
