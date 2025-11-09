defmodule HoldenChat.Chat.Room do
  # This turns this module into a resource
  use Ash.Resource, domain: HoldenChat.Chat, data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read]

    create :open do
      accept [:title]
    end

    update :close do
      accept []

      validate attribute_does_not_equal(:status, :closed) do
        message "Chat room is already closed"
      end

      change set_attribute(:status, :closed)
      # A custom change could be added like so:
      #
      # change MyCustomChange
      # change {MyCustomChange, opt: :val}
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      constraints max_length: 10
      allow_nil? false
      public? true
    end

    attribute :status, :atom do
      constraints one_of: [:open, :closed]
      default :open
      allow_nil? false
    end
  end
end
