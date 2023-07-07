defmodule Flightex.Bookings.CreateOrUpdate do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking
  alias Flightex.Users.Agent, as: UserAgent

  def call(%{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      }) do
    with {:ok, _user} <- UserAgent.get(user_id),
         {:ok, formatted_date} <- format_date(complete_date),
         {:ok, booking} <-
           Booking.build(formatted_date, local_origin, local_destination, user_id) do
      BookingAgent.save(booking)
    else
      error -> error
    end
  end

  defp format_date(date) do
    case NaiveDateTime.from_iso8601(date) do
      {:ok, formatted_date} -> {:ok, formatted_date}
      {:error, :invalid_format} -> "Invalid format date"
    end
  end
end
