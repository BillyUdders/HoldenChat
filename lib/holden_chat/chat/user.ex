defmodule HoldenChat.Chat.User do
  use Ash.Resource,
    domain: HoldenChat.Chat,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read]

    create :signup do
      accept [:username, :password]
    end

    update :edit do
      accept [:username]
      change set_attribute(:username, arg(:username))
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :username, :string do
      allow_nil? false
      public? true
    end

    attribute :password, :string do
      allow_nil? false
      public? false
    end

    attribute :created_date, :date do
      allow_nil? false
      default {Date, :utc_today, []}
    end
  end
end
