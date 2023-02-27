defmodule Djotex.Parser do
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
    choice([
      string("\n"),
      string("\r\n")
    ])

  at_least_1_white_space =
    utf8_char(@whitespace)
    |> times(min: 1)

  # blank_line = new_line |> times(2) |> tag(:blank_line)

  end_of_block = choice([new_line, eos()])

  block_line = concat(utf8_string(@not_newline, min: 1), new_line)

  inline_text =
    tag(
      repeat(block_line)
      |> lookahead(end_of_block),
      :inline_text
    )

  # first line start with # then whitespace, then text.
  # next line _can_ start with same amount of # or text
  heading =
    times(utf8_char([?#]), min: 1)
    |> reduce({Enum, :count, []})
    |> unwrap_and_tag(:heading_level)
    |> ignore(at_least_1_white_space)
    |> concat(inline_text)
    |> reduce({Djotex.Ast.Block.Heading, :to_ast, [[]]})
    |> ignore(optional(new_line))

  paragraph =
    empty()
    |> concat(inline_text)
    |> reduce({Djotex.Ast.Block.Para, :to_ast, [[]]})
    |> ignore(optional(new_line))

  defparsec :headings, heading
  defparsec :para, paragraph

  defparsec :ast,
            repeat(
              lookahead_not(eos())
              |> choice([parsec(:headings), parsec(:para)])
            )
end
