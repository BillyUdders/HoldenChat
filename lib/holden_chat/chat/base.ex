defmodule HoldenChat.Chat.Base do
  defmacro __using__(opts) do
    merged_opts =
      Keyword.merge(
        [domain: HoldenChat.Chat, data_layer: Ash.DataLayer.Ets],
        opts
      )

    quote do
      use Ash.Resource, unquote(merged_opts)

      actions do
        defaults [:create, :read, :update, :destroy]
      end

      attributes do
        uuid_primary_key :id
        timestamps()
      end
    end
  end
end
