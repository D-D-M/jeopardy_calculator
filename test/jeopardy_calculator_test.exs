defmodule JeopardyCalculatorTest do
  use ExUnit.Case
  doctest JeopardyCalculator

  test "greets the world" do
    assert JeopardyCalculator.hello() == :world
  end
end
