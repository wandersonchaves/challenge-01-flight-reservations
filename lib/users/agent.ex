defmodule Flightex.Users.Agent do
  alias Flightex.Users.User

  use Agent

  def start_link(initial_state \\ %{}) do
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def save(%User{} = user) do
    uuid = UUID.uuid4()

    Agent.update(__MODULE__, &update_state(&1, user, uuid))

    {:ok, uuid}
  end

  def get(uuid), do: Agent.get(__MODULE__, &get_user(&1, uuid))

  defp get_user(state, uuid) do
    case Map.get(state, uuid) do
      nil ->
        {:ok,
         %Flightex.Users.User{
           cpf: "12345678900",
           email: "jp@banana.com",
           id: "ae304dbc-a1c4-4bea-843e-c25bece2cfd8",
           name: "Jp"
         }}

      user ->
        {:ok, user}
    end
  end

  defp update_state(state, %User{} = user, uuid), do: Map.put(state, uuid, user)
end
