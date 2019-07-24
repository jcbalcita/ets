defmodule EtsTest do
  use ExUnit.Case
  doctest Ets

  test "ets table works" do
    #given
    Ets.start_link()
    key = :hello
    expected = "world"
    Ets.insert(key, expected)

    # when
    {:found, actual} = Ets.get(key)

    # then
    assert actual == expected
  end
end
