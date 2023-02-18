defmodule DjotexTest do
  use ExUnit.Case
  doctest Djotex

  test "greets the world" do
    text = """
    hi
    there
    """

    assert match?(
             {:ok, [%Djotex.Ast.Block.Para{children: "hi\nthere\n", attributes: []}], "", _, _,
              _},
             Djotex.parse_to_events(text)
           )
  end
end
