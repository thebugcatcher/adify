defmodule Adifier.Tool.Wget do
  @moduledoc """
  `GNU Wget` is a free utility for non-interactive download of files from the
  Web. It supports `HTTP`, `HTTPS`, and `FTP` protocols, as well as retrieval
  through `HTTP` proxies.

  `Wget` is non-interactive, meaning that it can work in the background, while
  the user is not logged on. This allows you to start a retrieval and
  disconnect from the system, letting `Wget` finish the work. By contrast, most
  of the Web browsers require constant user's presence, which can be a great
  hindrance when transferring a lot of data.
  """

  use Adifier.Tool, name: "wget"

  @impl true
  def install_cmd(:mac), do: "brew install wget --with-libressl"

  @impl true
  def install_cmd(os), do: super(os)

  @impl true
  def description, do: @moduledoc
end
