import Config
config :holden_chat, Oban, testing: :manual
config :holden_chat, token_signing_secret: "hQjU9UHY/rTPLEIAS9Xt0PMvuv58sOZ+"
config :bcrypt_elixir, log_rounds: 1
config :ash, policies: [show_policy_breakdowns?: true], disable_async?: true

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :holden_chat, HoldenChat.Repo,
  database: Path.expand("../holden_chat_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :holden_chat, HoldenChatWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "w2ZzQcCpq9hVoSRQo3s2EYVeurrIB+R1ohIAh5qLu/XnVjcDh3LmfmgA3sZLM1ke",
  server: false

# In test we don't send emails
config :holden_chat, HoldenChat.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
