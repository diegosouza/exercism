defmodule Markdown do

  @strong_begin ~r/^#{"__"}{1}/
  @strong_end ~r/#{"__"}{1}$/
  @italic_begin ~r/^[#{"_"}{1}][^#{"_"}+]/
  @italic_end ~r/[^#{"_"}{1}]/

  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  def parse(m) do
    m
    |> lines()
    |> Enum.map(&process/1)
    |> Enum.join()
    |> patch()
  end

  defp process(line) do
    cond do
      header?(line)         -> h_tag(line)
      paragraph?(line)      -> p_tag(line)
      unordered_list?(line) -> ul_li_tags(line)
    end
  end

  defp ul_li_tags(line) do
    line
    |> String.trim_leading("* ")
    |> String.split()
    |> join_words_with_tags()
    |> wrap("li")
  end

  defp h_tag(line) do
    [hashtags | words] = String.split(line)
    level = hashtags |> String.length() |> to_string()
    join_words_with_tags(words) |> wrap("h#{level}")
  end

  defp p_tag(line) do
    line
    |> String.split()
    |> join_words_with_tags()
    |> wrap("p")
  end

  defp join_words_with_tags(text) do
    text
    |> Enum.map(&prefix_and_suffix(&1))
    |> Enum.join(" ")
  end

  defp prefix_and_suffix(text) do
    text
    |> replace_prefix()
    |> replace_suffix()
  end


  defp replace_prefix(w) do
    cond do
      w =~ @strong_begin ->
        String.replace(w, @strong_begin, "<strong>", global: false)
      w =~ @italic_begin ->
        String.replace(w, "_" , "<em>", global: false)
      true -> w
    end
  end

  defp replace_suffix(w) do
    cond do
      w =~ @strong_end ->
        String.replace(w, @strong_end, "</strong>")
      w =~ @italic_end ->
        String.replace(w, "_", "</em>")
      true -> w
    end
  end

  defp wrap(content, tag) do
    "<#{tag}>#{content}</#{tag}>"
  end

  defp patch(text) do
    String.replace_suffix(
      String.replace(text, "<li>", "<ul><li>", global: false),
      "</li>",
      "</li></ul>"
    )
  end

  defp lines(m), do: String.split(m, "\n")
  defp header?(t), do: String.starts_with?(t, "#")
  defp unordered_list?(t), do: String.starts_with?(t, "*")

  defp paragraph?(t) do
    not (header?(t) or unordered_list?(t))
  end

end
