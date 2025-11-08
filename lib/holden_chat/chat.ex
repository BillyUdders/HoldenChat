defmodule HoldenChat.Chat do
  use Ash.Domain

  resources do
    resource HoldenChat.Chat.Room
  end
end
