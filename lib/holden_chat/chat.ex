defmodule HoldenChat.Chat do
  use Ash.Domain

  resources do
    resource HoldenChat.Chat.Room
    resource HoldenChat.Chat.User
  end
end
