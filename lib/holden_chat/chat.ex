defmodule HoldenChat.Chat do
  use Ash.Domain

  resources do
    resource HoldenChat.Chat.Room
    resource HoldenChat.Chat.User
    resource HoldenChat.Chat.Message
  end
end
