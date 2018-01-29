defmodule Adifier.Tool.Nodejs do
  @moduledoc """
  """

  use Adify.Tool

  def install_cmd(:ubuntu) do
    """
		asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
		bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
		asdf install nodejs 9.0.0
    """
  end

  def description() do
    """
		Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine.
		Node.js uses an event-driven, non-blocking I/O model that makes it
		lightweight and efficient.

		This is used by many of my other tools, so it's a must have.
		"""
  end
end
