defmodule Djotex.Parser.ParaTest do
  use ExUnit.Case

  test "greets the world" do
    text = """
    hi
    there
    """

    assert match?(
             {:ok,
              [
                %Djotex.Ast.Block.Para{
                  children: "hi\nthere",
                  attributes: []
                }
              ], "", _, _, _},
             Djotex.parse_to_ast(text)
           )
  end
end
