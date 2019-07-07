Code.require_file("test/mix_test_helper.exs")

defmodule Adify.Mix.Tasks.AdifyTest do
  use ExUnit.Case

  import MixTestHelper

  @tools_dir Path.join([__DIR__, "..", "..", "..", "support", "tools"])

  describe "run/1" do
    test "runs pre, main and post commands" do
      mix("adify", ["--noconfirm", "-t #{@tools_dir}"])
    end
  end
end
