defmodule HoldenChatWeb.UserLive.Index do
  use HoldenChatWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Users
        <:actions>
          <.button variant="primary" navigate={~p"/users/new"}>
            <.icon name="hero-plus" /> New User
          </.button>
        </:actions>
      </.header>

      <.table
        id="users"
        rows={@streams.users}
        row_click={fn {_id, user} -> JS.navigate(~p"/users/#{user}") end}
      >
        <:col :let={{_id, user}} label="Id">{user.id}</:col>

        <:col :let={{_id, user}} label="Username">{user.username}</:col>

        <:action :let={{_id, user}}>
          <div class="sr-only">
            <.link navigate={~p"/users/#{user}"}>Show</.link>
          </div>

          <.link navigate={~p"/users/#{user}/edit"}>Edit</.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Users")
     |> stream(:users, Ash.read!(HoldenChat.Chat.User))}
  end
end
