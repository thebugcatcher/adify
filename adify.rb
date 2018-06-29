#!/usr/local/bin/ruby -w

#############
### ABOUT ###
# This ruby script installs asdf, erlang and elixir. Once installed it
# delegates the call to the elixir app, adifier.
#############
ELIXIR_VERSION=1.6.6.freeze
ERLANG_VERSION=21.0.freeze
ASDF_VERSION=0.5.0.freeze
SHELL=$1.freeze

def _announce(msg)
  puts <<-HEREDOC
==========================================================
#{msg}....
==========================================================
  HEREDOC
end

#####################
### Installs Asdf ###
#####################
def install_asdf(vsn = ASDF_VERSION)
  _announce "Installing Asdf version: #{vsn}"
  `git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v#{vsn}`
  `echo -e "\n. $HOME/.asdf/asdf.sh" >> ~/.#{SHELL}rc`
  `echo -e "\n. $HOME/.asdf/completions/asdf.bash" >> ~/.#{SHELL}rc`
  `source ~/.#{SHELL}rc`
end

#######################
### Installs Erlang ###
#######################
def install_erlang(vsn = ERLANG_VERSION)
  _announce "Installing Erlang version: #{vsn}"
  `asdf plugin-add erlang`
  `asdf install erlang #{vsn}`
end

#######################
### Installs Elixir ###
#######################
def install_elixir(vsn = ELIXIR_VERSION)
  _announce "Installing Elixir version: #{vsn}"
  `asdf plugin-add elixir`
  `asdf install elixir #{vsn}`
end

####################
### Runs Adifier ###
####################
def mix_adify
  _announce "Running Adifier"
  `cd adifier`
	`mix deps.get`
	`mix compile`
  `mix adify`
end
