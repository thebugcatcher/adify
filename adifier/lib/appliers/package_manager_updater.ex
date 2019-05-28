defmodule Adifier.Applier.PackageManagerUpdater do
  @moduledoc """
  Handles Updating Package Managers
  """

  use Adifier.Applier

  require Logger

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
      true ->
        update_pm(os)

      "Y" <> _tali ->
        update_pm(os)

      "y" <> _tali ->
        update_pm(os)

      _ ->
        Logger.warn("Not updating Package Manager...")
        {:ok, :done}
    end
  end

  def update_pm(os) do
    Logger.info("Updating Package Manager")

    result =
      os
      |> Adifier.PackageManager.pm_update_cmd()
      |> Adifier.Invoker.call()

    case result do
      {0, _} -> {:ok, :done}
      {_, msg} -> {:error, msg}
    end
  end
end
