defmodule HoldenChat.Chat.User do
  use HoldenChat.Chat.Base

  actions do
    create :signup do
      accept [:username, :password]
    end

    update :edit do
      accept [:username]
      change set_attribute(:username, arg(:username))
    end
  end

  attributes do
    attribute :username, :string do
      allow_nil? false
      public? true
    end

    attribute :password, :string do
      allow_nil? false
      public? false
    end
  end
end
