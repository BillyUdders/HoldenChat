defmodule HoldenChat.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        HoldenChat.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:holden_chat, :token_signing_secret)
  end
end
