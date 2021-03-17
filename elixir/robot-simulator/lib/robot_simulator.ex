defmodule RobotSimulator do

  @initial_position {0, 0}
  @initial_direction :north
  @directions [:north, :east, :south, :west]
  @invalid_direction {:error, "invalid direction"}
  @invalid_position {:error, "invalid position"}
  @invalid_instruction {:error, "invalid instruction"}

  defmodule RobotSimulator.Robot do
    defstruct [:direction, position: %{x: 0, y: 0}]

    def new(direction, position) do
        %__MODULE__{
          direction: direction,
          position: %{x: elem(position, 0), y: elem(position, 1)}
        }
    end

    def inc_x(robot), do: update_in(robot.position.x, &(&1 + 1))
    def inc_y(robot), do: update_in(robot.position.y, &(&1 + 1))
    def dec_x(robot), do: update_in(robot.position.x, &(&1 - 1))
    def dec_y(robot), do: update_in(robot.position.y, &(&1 - 1))
  end

  alias RobotSimulator.Robot

  defguard is_north(robot) when robot.direction == :north
  defguard is_south(robot) when robot.direction == :south
  defguard is_east(robot) when robot.direction == :east
  defguard is_west(robot) when robot.direction == :west

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ @initial_direction, position \\ @initial_position)

  def create(direction, _) when direction not in @directions, do: @invalid_direction
  def create(_, position) when not is_tuple(position), do: @invalid_position
  def create(_, position) when tuple_size(position) != 2, do: @invalid_position
  def create(_, {x, y}) when not is_integer(x) or not is_integer(y), do: @invalid_position
  def create(direction, position), do: Robot.new(direction, position)

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    instructions
    |> String.graphemes()
    |> move(robot)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%Robot{direction: d}) when d in @directions, do: d
  def direction(%Robot{direction: d}) when d not in @directions, do: @invalid_direction
  #def direction(_), do: @invalid_direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%Robot{position: %{x: x, y: y}}), do: {x, y}
  def position(p) when not is_tuple(p), do: @invalid_position
  def position({x, y}) when is_integer(x) and is_integer(y), do: {x, y}
  def position(_), do: @invalid_position

  defp move([instruction | next_ones], robot) do
    case instruction do
      "L" when is_north(robot) -> move(next_ones, to_west(robot))
      "L" when is_west(robot) -> move(next_ones, to_south(robot))
      "L" when is_south(robot) -> move(next_ones, to_east(robot))
      "L" when is_east(robot) -> move(next_ones, to_north(robot))
      "R" when is_north(robot) -> move(next_ones, to_west(robot))
      "R" when is_east(robot) -> move(next_ones, to_south(robot))
      "R" when is_south(robot) -> move(next_ones, to_west(robot))
      "R" when is_west(robot) -> move(next_ones, to_north(robot))
      "A" when is_north(robot) -> move(next_ones, Robot.inc_y(robot))
      "A" when is_west(robot) -> move(next_ones, Robot.dec_x(robot))
      "A" when is_south(robot) -> move(next_ones, Robot.dec_y(robot))
      "A" when is_east(robot) -> move(next_ones, Robot.inc_x(robot))
      _ -> @invalid_instruction
    end
  end

  defp move([], robot), do: robot

  defp to_west(robot), do: %{robot | direction: :west}
  defp to_south(robot), do: %{robot | direction: :south}
  defp to_east(robot), do: %{robot | direction: :east}
  defp to_north(robot), do: %{robot | direction: :north}

end
