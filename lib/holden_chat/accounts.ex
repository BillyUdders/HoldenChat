defmodule HoldenChat.Accounts do
  use Ash.Domain, otp_app: :holden_chat, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource HoldenChat.Accounts.Token
    resource HoldenChat.Accounts.User
  end
end
