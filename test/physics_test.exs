defmodule PhysicsTest do
  use ExUnit.Case
  doctest Physics

  test "escape velocity of the earth is correct" do
    ev = Physics.Rocketry.escape_velocity(:earth)
    assert ev === 11.2
  end

  test "escape velocity of planet x is correct" do
    ev = %{mass: 4.0e22, radius: 6.21e6}
      |> Physics.Rocketry.escape_velocity
    assert ev === 1.0
  end
end
