defmodule HoldenChat.Chat.Message do
  use HoldenChat.Chat.Base

  actions do
    defaults [:read]

    create :publish do
      accept [:body, :room_id]
    end

    update :edit do
      accept [:body]
    end
  end

  attributes do
    attribute :body, :string do
      allow_nil? false
      public? true
    end

    attribute :room_id, :string do
      allow_nil? false
    end
  end

  relationships do
    belongs_to :room, HoldenChat.Chat.Room
  end
end
