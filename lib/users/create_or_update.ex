defmodule Flightex.Users.CreateOrUpdate do
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.User

  def call(%{name: name, email: email, cpf: cpf}) do
    case User.build(cpf, email, name) do
      {:ok, user} ->
        case UserAgent.save(user) do
          {:ok, %{id: id}} ->
            {:ok, %{user | id: id}}

          _ ->
            {:error, "Cpf must be a String"}
        end

      {:error, _reason} ->
        {:error, "Falha ao criar o usuário"}
    end
  end
end
