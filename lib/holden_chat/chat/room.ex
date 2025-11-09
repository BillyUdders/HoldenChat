defmodule HoldenChat.Chat.Room do
  # This turns this module into a resource
  use HoldenChat.Chat.Base,
    domain: HoldenChat.Chat,
    data_layer: Ash.DataLayer.Ets

  actions do
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
      # change MyCustomChange
      # change {MyCustomChange, opt: :val}
    end
  end

  attributes do
    attribute :title, :string do
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
