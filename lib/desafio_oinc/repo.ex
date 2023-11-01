defmodule DesafioOinc.Repo do
  use Ecto.Repo,
    otp_app: :desafio_oinc,
    adapter: Ecto.Adapters.Postgres
end
