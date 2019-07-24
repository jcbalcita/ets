defmodule Ets do
  use GenServer

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{ets_table: :my_table}, name: __MODULE__)
  end

  def init(%{ets_table: table_name}) do
    table = :ets.new(table_name, [:named_table, :set])
    {:ok, %{ets_table: table}}
  end

  def handle_call({:insert, {_, value} = entry}, _from, state) do
    %{ets_table: ets_table} = state
    true = :ets.insert(ets_table, entry)
    {:reply, value, state}
  end

  def handle_call({:get, key}, _from, state) do
    %{ets_table: ets_table} = state
    result = :ets.lookup(ets_table, key)
    {:reply, result, state}
  end

  def insert(key, value), do: insert({key, value})

  def insert(entry) do
    GenServer.call(__MODULE__, {:insert, entry}) 
  end

  def get(key) do
    case GenServer.call(__MODULE__, {:get, key}) do
      [] -> {:not_found}
      [{_, value}] -> {:found, value}
    end
  end
end
