defmodule HoldenChatWeb.UserLive.Form do
  use HoldenChatWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage user records in your database.</:subtitle>
      </.header>

      <.form
        for={@form}
        id="user-form"
        phx-change="validate"
        phx-submit="save"
      >
        <%= if @form.source.type == :create do %>
          <.input field={@form[:username]} type="text" label="Username" /><.input
            field={@form[:password]}
            type="text"
            label="Password"
          />
        <% end %>
        <%= if @form.source.type == :update do %>
          <.input field={@form[:username]} type="text" label="Username" />
        <% end %>

        <.button phx-disable-with="Saving..." variant="primary">Save User</.button>
        <.button navigate={return_path(@return_to, @user)}>Cancel</.button>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    user =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(HoldenChat.Chat.User, id)
      end

    action = if is_nil(user), do: "New", else: "Edit"
    page_title = action <> " " <> "User"

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(user: user)
     |> assign(:page_title, page_title)
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, user_params))}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})

        socket =
          socket
          |> put_flash(:info, "User #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, user))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{user: user}} = socket) do
    form =
      if user do
        AshPhoenix.Form.for_update(user, :edit, as: "user")
      else
        AshPhoenix.Form.for_create(HoldenChat.Chat.User, :signup, as: "user")
      end

    assign(socket, form: to_form(form))
  end

  defp return_path("index", _user), do: ~p"/users"
  defp return_path("show", user), do: ~p"/users/#{user.id}"
end
