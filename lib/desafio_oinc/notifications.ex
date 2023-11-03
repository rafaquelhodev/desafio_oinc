defmodule DesafioOinc.Notifications do
  def subscribe(topic) do
    Phoenix.PubSub.subscribe(DesafioOinc.PubSub, topic)
  end

  def notify_subscribers({:ok, result}, topic, event) do
    Phoenix.PubSub.broadcast(DesafioOinc.PubSub, topic, {__MODULE__, event, result})

    {:ok, result}
  end
end
