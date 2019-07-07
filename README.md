# Adify

<img src="logo/logo.png" alt="https://hexdocs.pm/adify/index.html" width="270" height="190">

[![Build Status](https://travis-ci.org/aditya7iyengar/adify.svg?branch=master)](https://travis-ci.org/aditya7iyengar/adify)
[![Coverage Status](https://coveralls.io/repos/github/aditya7iyengar/adify/badge.svg?branch=master)](https://coveralls.io/github/aditya7iyengar/adify?branch=master)
[![Hex Version](http://img.shields.io/hexpm/v/adify.svg?style=flat)](https://hex.pm/packages/adify)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/adify.svg)](https://hex.pm/packages/adify)
[![Hex docs](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/adify)
[![docs](https://inch-ci.org/github/aditya7iyengar/adify.svg)](http://inch-ci.org/github/aditya7iyengar/adify)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/aditya7iyengar/adify/master/LICENSE)

A configurable, extendable DevOps environment app. This app installs tools
based on the given operating systems.

## Installation

Adify is [available on hex.pm](https://hex.pm/packages/adify).

You can either add it as a dependency in your project's `mix.exs`, or install it
globally as an archive task.

```elixir
# In mix.exs
def deps do
  [
    {:adify, "~> 0.1.0"}
  ]
end
```

OR

```sh
$ mix archive.install adify 0.1.0
```

## Usage

### Basic Usage

This app comes with an prelude script, that can be ran to install it's required
dependencies on your computers. The easiest way to get started is to run that
script:

```sh
$ bash <(wget -qO- https://raw.githubusercontent.com/aditya7iyengar/adify/master/prelude.sh)

OR

$ bash <(curl -s https://raw.githubusercontent.com/aditya7iyengar/adify/master/prelude.sh)
```

This script installs the required dependencies to run `$ mix adify` task and
runs the task from the home directory. Based on the value of the environment
variable `NO_CONFIRM`, it will either confirm before installing a dependency or
not. (If `NO_CONFIRM` is not set, it defaults to `false`)

To get more information about what this script does, check out the documentation
for `prelude.sh` on top of the file.

#### Configure

- `NO_CONFIRM` env variable
- `TOOLS_DIR` env variable
- `SHELL` env variable
