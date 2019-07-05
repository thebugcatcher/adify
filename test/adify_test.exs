defmodule AdifyTest do
  use ExUnit.Case
  doctest Adify

  test "greets the world" do
    assert Adify.hello() == :world
  end
end
