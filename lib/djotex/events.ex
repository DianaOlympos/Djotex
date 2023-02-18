defmodule Djotex.Events do
  import NimbleParsec

  @moduledoc """
    Start_block:
      - defined block type
      - or para
    End_block:
      - newline
      - new_block non nested
  """

  @whitespace Unicode.Set.to_utf8_char!("[:blank:]")
  @not_whitespace Unicode.Set.to_utf8_char!("[:^blank:]")
  @not_newline Unicode.Set.to_utf8_char!("[[:any:] - [[\n][\r]]]")

  new_line =
    empty()
    # |> repeat(utf8_char(@whitespace))
    |> choice([
      string("\n"),
      string("\r\n")
    ])

  at_least_1_white_space =
    utf8_char(@whitespace)
    |> times(min: 1)

  blank_line = new_line |> times(2) |> tag(:blank_line)

  tag_new_line = unwrap_and_tag(new_line, :new_line)

  heading =
    empty()
    |> tag(
      times(utf8_char([?#]), min: 1)
      |> reduce({Enum, :count, []})
      |> unwrap_and_tag(:"#"),
      :heading_level
    )
    |> ignore(at_least_1_white_space)
    |> tag(utf8_string(@not_newline, min: 1), :inline_text)
    |> tag(:heading)

  paragraph =
    empty()
    |> lookahead_not(blank_line)
    |> repeat(utf8_string(@not_newline, min: 1) |> concat(new_line))
    |> reduce({Djotex.Ast.Block.Para, :to_para, [[]]})

  defparsec :headings, heading |> repeat(choice([tag_new_line, parsec(:headings)]))
  defparsec :para, paragraph

  defparsec :events, choice(empty(), [parsec(:headings), parsec(:para)])
end
