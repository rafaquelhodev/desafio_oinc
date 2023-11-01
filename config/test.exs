import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :desafio_oinc, DesafioOinc.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "desafio_oinc_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# Commanded event store
config :desafio_oinc, DesafioOinc.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "eventstore_desafio_oinc_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :desafio_oinc, DesafioOincWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "biYOGFho7Omiuz4rzKKn4Lkwl1CEj9a4JczOBqZHobW3oKxLRxXbtIXYOcV32lVJ",
  server: false

# In test we don't send emails.
config :desafio_oinc, DesafioOinc.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
