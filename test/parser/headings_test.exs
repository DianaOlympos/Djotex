defmodule Djotex.Parser.HeadingsTest do
  use ExUnit.Case

  test "Single Heading" do
    text = """
    ## Heading
    """

    assert match?(
             {:ok,
              [
                %Djotex.Ast.Block.Heading{
                  children: "Heading",
                  level: 2,
                  attributes: []
                }
              ], "", _, _, _},
             Djotex.parse_to_ast(text)
           )
  end

  test "Two Heading" do
    text = """
    # Heading

    # another
    """

    assert match?(
             {:ok,
              [
                %Djotex.Ast.Block.Heading{
                  children: "Heading",
                  level: 1,
                  attributes: []
                },
                %Djotex.Ast.Block.Heading{
                  children: "another",
                  level: 1,
                  attributes: []
                }
              ], "", _, _, _},
             Djotex.parse_to_ast(text)
           )
  end

  test "Continued Heading with a hash" do
    text = """
    # Heading
    # continued
    """

    assert match?(
             {:ok,
              [
                %Djotex.Ast.Block.Heading{
                  children: "Heading\ncontinued",
                  level: 1,
                  attributes: []
                }
              ], "", _, _, _},
             Djotex.parse_to_ast(text)
           )
  end

  # TODO: this is a change. We should accept ##\n heading but i refused
  test "Heading then para" do
    text = """
    ## heading

    para
    """

    assert match?(
             {:ok,
              [
                %Djotex.Ast.Block.Heading{
                  children: "heading",
                  level: 2,
                  attributes: []
                },
                %Djotex.Ast.Block.Para{
                  children: "para",
                  attributes: []
                }
              ], "", _, _, _},
             Djotex.parse_to_ast(text)
           )
  end
end
