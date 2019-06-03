defmodule StattleshipExTest do
  use ExUnit.Case
  doctest StattleshipEx

  test "greets the world" do
    assert StattleshipEx.hello() == :world
  end
end
