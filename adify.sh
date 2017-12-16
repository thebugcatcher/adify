### PRELUDE ###
# This script is responsible for running all the commands required to setup an ubuntu computer
# to be used by Adi Iyengar effectively. Hence, it adifies the computer.
# This script doesn't not include the tools required to do "Work" related stuff

# TODO: Make it runnable on other OS.
# This Script is setup to run only on Ubuntu computers


### REQUIREMENTS ###
# - Internet Connection
# - Admin Privilleges of the computer being adified
# - Adi (for credentials)

### GIT ###
# Running all three package manager commands.
sudo apt-get install -y git
sudo yum install -y git
brew install git

ex_version="1.5.2"
asdf_version="0.4.0"

if [ ! -d "$HOME/.adify" ]; then
  echo """
  ==========================================================
  Adifying for the first time....

  This script is responsible for running all the commands required to setup an ubuntu computer
  to be used by Adi Iyengar effectively. Hence, it adifies the computer.
  This script doesn't not include the tools required to do 'work' elated stuff by default
  ==========================================================
  """

  echo """
  ==========================================================
  Installing Git to get adify.
  ==========================================================
  """
  sudo apt-get install -y git


  echo """
  ==========================================================
  Fetching Adifying files...
  ==========================================================
  """
  git clone --depth=1 https://github.com/aditya7iyengar/adify.git "$HOME/.adify"

  cd "$HOME/.adify"
  [ "$1" = "ask" ] && export ADIFYASK="true"
  [ "$1" = "work" ] && export ADIFYWORK="true"


  echo """
  ==========================================================
  Installing Asdf $asdf_version for Elixir and Erlang...
  ==========================================================
  """
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v${asdf_version}


  echo """
  ==========================================================
  Installing ELIXIR $ex_version to run Adifier app....
  ==========================================================
  """
  asdf add-plugin elixir asdf-elixir
  asdf install elixir ${ex_version}

  echo """
  ==========================================================
  Running Adifier... (mix adify)
  ==========================================================
  """
  mix adify
else
  echo """
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  The system is already Adified.
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  """
fi

