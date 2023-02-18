defmodule Djotex.TestText do
  def test_heading_block() do
    test = "### wat \n# another\n### woo \n\n"

    Djotex.Events.headings(test)
  end
end
