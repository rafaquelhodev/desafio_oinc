defmodule DesafioOinc.App do
  use Commanded.Application,
    otp_app: :desafio_oinc,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: DesafioOinc.EventStore
    ]

  router(DesafioOinc.Router)
end
