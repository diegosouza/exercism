defmodule Markdown do

  @list_regex ~r/(?<!<\/li>)<li>(.*)<\/li>(?!<li>)/
  @bold_regex ~r/__([^_]*)__/
  @emphasize_regex ~r/_([^_]*)_/

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
    |> String.split("\n")
    |> Enum.map_join(&process_text/1)
    |> list
    |> bold
    |> italic
  end

  defp process_text("#" <> text), do: parse_header(text)
  defp process_text("* " <> text), do: enclose_with_tag(text, "li")
  defp process_text(t), do: "<p>#{t}</p>"

  defp parse_header(text, level \\1)
  defp parse_header("#" <> text, level), do: parse_header(text, level + 1)
  defp parse_header(" " <> text, level), do: enclose_with_tag(text, "h#{level}")

  defp enclose_with_tag(text, tag), do: "<#{tag}>#{text}</#{tag}>"

  defp list(t) do
    String.replace(t, @list_regex, "<ul><li>\\1</li></ul>")
  end

  defp bold(t) do
    String.replace(t, @bold_regex, "<strong>\\1</strong>")
  end

  defp italic(t) do
    String.replace(t, @emphasize_regex, "<em>\\1</em>")
  end

end
