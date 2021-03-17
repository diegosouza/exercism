defmodule RobotSimulator do

  @initial_position {0, 0}
  @initial_direction :north
  @directions [:north, :east, :south, :west]

  defmodule Robot do
    defstruct [:direction, :position]
  end

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ @initial_direction, position \\ @initial_position)

  def create(direction, position) do
    robot = %Robot{
      direction: direction(direction),
      position: position(position)
    }

    case [robot.direction, robot.position] do
      [{:error, message}, _] -> {:error, message}
      [_ , {:error, message}] -> {:error, message}
      _ -> robot
    end
  end


  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(_robot = %{direction: direction}), do: direction
  def direction(d) when d not in @directions, do: {:error, "invalid direction"}
  def direction(d) when is_atom(d), do: d

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(_robot = %{position: position}), do: position
  def position(p) when not is_tuple(p), do: {:error, "invalid position"}
  def position({x, y}) when is_integer(x) and is_integer(y), do: {x, y}
  def position(_), do: {:error, "invalid position"}

end
