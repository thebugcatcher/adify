defmodule Adifier.Tool.Curl do
  @moduledoc """
  CUrl is a tool to transfer data from or to a server, using one of the
  supported protocols (`DICT`, `FILE`, `FTP`, `FTPS`, `GOPHER`, `HTTP`, `HTTPS`,
  `IMAP`, `IMAPS`, `LDAP`, `LDAPS`, `POP3`, `POP3S`, `RTMP`, `RTSP`, `SCP`,
  `SFTP`, `SMB`, `SMBS`, `SMTP`, `SMTPS`, `TELNET` and `TFTP`). The command is
  designed to work without user interaction.

  CUrl offers a busload of useful tricks like proxy support, user
  authentication, FTP upload, HTTP post, SSL connections, cookies, file transfer
  resume,  Met‐ alink, and more.
  """

  use Adifier.Tool, name: "curl"

  @impl true
  def description, do: @moduledoc
end
