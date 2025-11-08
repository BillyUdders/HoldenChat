defmodule HoldenChatWeb.PageController do
  use HoldenChatWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
