defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count([_ | t]), do: count(t) + 1
  def count([]), do: 0

  @spec reverse(list, list) :: list
  def reverse(list, reversed \\ [])
  def reverse([h | t], reversed), do: reverse(t, [h | reversed])
  def reverse([], reversed), do: reversed

  @spec map(list, (any -> any), list) :: list
  def map(list, f, mapped \\ [])
  def map([h | t], f, mapped) do
    map(t, f, [f.(h) | mapped])
  end
  def map([], _f, mapped), do: reverse(mapped)

  @spec filter(list, (any -> as_boolean(term)), list) :: list
  def filter(list, f, filtered \\ [])
  def filter([h | t], f, filtered) do
    case f.(h) do
      true -> filter(t, f, [h | filtered])
      _ -> filter(t, f, filtered)
    end
  end
  def filter([], _f, filtered), do: reverse(filtered)

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _f), do: acc
  def reduce([h | t], acc, f) do
    new_acc = f.(h, acc)
    reduce(t, new_acc, f)
  end

  @spec append(list, list, list) :: list
  def append(a, b, appended \\ [])
  def append([], [h | t], appended), do: append([], t, [h | appended])
  def append([h | t], [], appended), do: append(t, [], [h | appended])
  def append([h | t], b, appended), do: append(t, b, [h | appended])
  def append([], [], appended), do: reverse(appended)

  @spec concat([[any]], [any]) :: [any]
  def concat(ll, concatenated \\ [])
  def concat([], concatenated), do: reverse(concatenated)
  def concat([head | tail], concatenated) do
    case head do
      [h | t] -> concat([t | tail], [h | concatenated])
      [x] -> concat(tail, [x | concatenated])
      [] -> concat(tail, concatenated)
    end
  end
end
