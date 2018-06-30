defmodule Adifier.Applier.PackageManagerUpdater do
  @moduledoc """
  Handles Updating Package Managers
  """

  use Adifier.Applier

  @impl true
  def ask(os) do
    """
    Adify wants to update package manager for OS: #{os}.
    Proceed? (Y/N)
    """
  end

  @impl true
  def run(os, noconfirm) do
    case noconfirm || IO.gets(ask(os)) do
      true -> update_pm(os)
      ans when ans in ~w{Y y Yes yes} -> update_pm(os)
      _ ->
        IO.puts "Not updating Package Manager..."
        {:ok, :done}
    end
  end

  def update_pm(os) do
    IO.puts "Updating Package Manager"

    result = os
      |> Adifier.PackageManager.pm_update_cmd()
      |> Adifier.Invoker.call()

    case result do
      {0, _} -> {:ok, :done}
      {_, msg} -> {:error, msg}
    end
  end
end
