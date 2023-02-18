defmodule Djotex.Ast do
  @type attributes() :: map()
  alias Djotex.Ast

  defmodule SourceLoc do
    defstruct line: 0, col: 0, offset: 0
    @enforce_keys [:line, :col, :offset]

    @type t :: %__MODULE__{line: integer(), col: integer(), offset: integer()}
  end

  defmodule Position do
    defstruct start: %SourceLoc{}, end: %SourceLoc{}

    @enforce_keys [:start, :end]

    @type t :: %__MODULE__{start: SourceLoc.t(), end: SourceLoc.t()}
  end

  defmodule Attributes do
    defstruct attributes: %{}, pos: %Position{}

    @type t :: %__MODULE__{attributes: Ast.attributes(), pos: Position.t()}
  end

  defmodule Block do
    @type t ::
            Ast.Block.Para.t()
            | Ast.Block.Heading.t()
            | Ast.Block.ThematicBreak.t()
            | Ast.Block.Section.t()
            | Ast.Block.Div.t()
            | Ast.Block.CodeBlock.t()
            | Ast.Block.RawBlock.t()
            | Ast.Block.BlockQuote.t()
            | Ast.Block.OrderedList.t()
            | Ast.Block.BulletList.t()
            | Ast.Block.TaskList.t()
            | Ast.Block.DefinitionList.t()
            | Ast.Block.Table.t()

    defmodule Para do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{children: [Ast.Inline.t()], attributes: [Ast.Attributes.t()]}

      def to_para(iolist, attributes) do
        %__MODULE__{children: Enum.join(iolist), attributes: attributes}
      end
    end

    defmodule Heading do
      defstruct level: 1, children: [], attributes: []

      @type t :: %__MODULE__{
              level: integer(),
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule ThematicBreak do
      defstruct attributes: []

      @type t :: %__MODULE__{attributes: [Ast.Attributes.t()]}
    end

    defmodule Section do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{children: [Ast.Block.t()], attributes: [Ast.Attributes.t()]}
    end

    defmodule Div do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{children: [Ast.Block.t()], attributes: [Ast.Attributes.t()]}
    end

    defmodule CodeBlock do
      defstruct lang: nil, text: "", attributes: []

      @type t :: %__MODULE__{
              lang: nil | String.t(),
              attributes: [Ast.Attributes.t()],
              text: String.t()
            }
    end

    defmodule RawBlock do
      defstruct format: "", text: "", attributes: []

      @type t :: %__MODULE__{
              format: String.t(),
              attributes: [Ast.Attributes.t()],
              text: String.t()
            }
    end

    defmodule BlockQuote do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{children: [Ast.Block.t()], attributes: [Ast.Attributes.t()]}
    end

    defmodule ListItem do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{children: [Ast.Block.t()], attributes: [Ast.Attributes.t()]}
    end

    defmodule OrderedList.Style do
      defstruct ordering_style: :decimal, separator: :period

      @type style :: :decimal | :lower_alpha | :upper_alpha | :lower_roman | :upper_roman

      @type separator :: :period | :parenthesis | :enclosing_parentheses

      @type t :: %__MODULE__{
              ordering_style: style(),
              separator: separator()
            }
    end

    defmodule OrderedList do
      defstruct children: [], style: %OrderedList.Style{}, tight: false, start: 1, attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Block.ListItem.t()],
              style: OrderedList.Style.t(),
              tight: boolean(),
              start: integer(),
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule BulletList do
      @type style :: :+ | :- | :*

      defstruct children: [], style: :*, tight: false, attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Block.ListItem.t()],
              style: style(),
              tight: boolean(),
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule TaskListItem do
      @type checkboxstatus :: :checked | :unchecked

      defstruct checkbox: :unchecked, children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Block.t()],
              checkbox: checkboxstatus(),
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule TaskList do
      defstruct children: [], tight: false, attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Block.TaskListItem.t()],
              tight: boolean(),
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule Term do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule Definition do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Block.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule DefinitionListItem do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Block.Term.t() | Ast.Block.Definition.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule DefinitionList do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule TableCaption do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule TableCell do
      @type alignement :: :default | :left | :right | :center

      defstruct head: false, children: [], attributes: [], align: :default

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()],
              head: boolean(),
              align: alignement()
            }
    end

    defmodule TableRow do
      defstruct head: false, children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Block.TableCell.t()],
              attributes: [Ast.Attributes.t()],
              head: boolean()
            }
    end

    defmodule TableElement do
      defstruct caption: nil, rows: []

      @type t :: %__MODULE__{
              caption: nil | Ast.Block.TableCaption.t(),
              rows: [Ast.Block.TableRow.t()]
            }
    end

    defmodule Table do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Blockk.TableElement.t()],
              attributes: [Ast.Attributes.t()]
            }
    end
  end

  defmodule Inline do
    @type t() ::
            Ast.Inline.Str.t()
            | Ast.Inline.SoftBreak.t()
            | Ast.Inline.HardBreak.t()
            | Ast.Inline.NonBreakingSpace.t()
            | Ast.Inline.Symb.t()
            | Ast.Inline.Verbatim.t()
            | Ast.Inline.RawInline.t()
            | Ast.Inline.InlineMath.t()
            | Ast.Inline.DisplayMath.t()
            | Ast.Inline.Url.t()
            | Ast.Inline.Email.t()
            | Ast.Inline.FootnoteReference.t()
            | Ast.Inline.SmartPunctuation.t()
            | Ast.Inline.Emph.t()
            | Ast.Inline.Strong.t()
            | Ast.Inline.Link.t()
            | Ast.Inline.Image.t()
            | Ast.Inline.Span.t()
            | Ast.Inline.Mark.t()
            | Ast.Inline.Superscript.t()
            | Ast.Inline.Subscript.t()
            | Ast.Inline.Insert.t()
            | Ast.Inline.Delete.t()
            | Ast.Inline.DoubleQuoted.t()
            | Ast.Inline.SingleQuoted.t()

    defmodule Str do
      defstruct text: "", attributes: []

      @type t :: %__MODULE__{
              attributes: [Ast.Attributes.t()],
              text: String.t()
            }
    end

    defmodule SoftBreak do
      defstruct attributes: []

      @type t :: %__MODULE__{attributes: [Ast.Attributes.t()]}
    end

    defmodule HardBreak do
      defstruct attributes: []

      @type t :: %__MODULE__{attributes: [Ast.Attributes.t()]}
    end

    defmodule NonBreakingSpace do
      defstruct attributes: []

      @type t :: %__MODULE__{attributes: [Ast.Attributes.t()]}
    end

    defmodule Symb do
      defstruct attributes: [], alias: ""

      @type t :: %__MODULE__{attributes: [Ast.Attributes.t()], alias: String.t()}
    end

    defmodule Verbatim do
      defstruct attributes: [], text: ""

      @type t :: %__MODULE__{attributes: [Ast.Attributes.t()], text: String.t()}
    end

    defmodule RawInline do
      defstruct attributes: [], text: "", format: ""

      @type t :: %__MODULE__{
              attributes: [Ast.Attributes.t()],
              text: String.t(),
              format: String.t()
            }
    end

    defmodule InlineMath do
      defstruct attributes: [], text: ""

      @type t :: %__MODULE__{
              attributes: [Ast.Attributes.t()],
              text: String.t()
            }
    end

    defmodule DisplayMath do
      defstruct attributes: [], text: ""

      @type t :: %__MODULE__{
              attributes: [Ast.Attributes.t()],
              text: String.t()
            }
    end

    defmodule Url do
      defstruct attributes: [], text: ""

      @type t :: %__MODULE__{
              attributes: [Ast.Attributes.t()],
              text: String.t()
            }
    end

    defmodule Email do
      defstruct attributes: [], text: ""

      @type t :: %__MODULE__{
              attributes: [Ast.Attributes.t()],
              text: String.t()
            }
    end

    defmodule FootnoteReference do
      defstruct text: "", attributes: []

      @type t :: %__MODULE__{
              attributes: [Ast.Attributes.t()],
              text: String.t()
            }
    end

    defmodule SmartPunctuation do
      @type smart_punctuation ::
              :left_single_quote
              | :right_single_quote
              | :left_double_quote
              | :right_double_quote
              | :ellipses
              | :em_dash
              | :en_dash

      defstruct text: "", attributes: [], type: :left_single_quote

      @type t :: %__MODULE__{
              attributes: [Ast.Attributes.t()],
              text: String.t(),
              type: smart_punctuation()
            }
    end

    defmodule Emph do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule Strong do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule Link do
      defstruct children: [], attributes: [], destination: nil, reference: nil

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()],
              destination: nil | String.t(),
              reference: nil | String.t()
            }
    end

    defmodule Image do
      defstruct children: [], attributes: [], destination: nil, reference: nil

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()],
              destination: nil | String.t(),
              reference: nil | String.t()
            }
    end

    defmodule Span do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule Mark do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule Superscript do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule Subscript do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule Insert do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule Delete do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule DoubleQuoted do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end

    defmodule SingleQuoted do
      defstruct children: [], attributes: []

      @type t :: %__MODULE__{
              children: [Ast.Inline.t()],
              attributes: [Ast.Attributes.t()]
            }
    end
  end

  defmodule Reference do
    defstruct attributes: [], label: "", destination: ""

    @type t :: %__MODULE__{
            attributes: [Attributes.t()],
            label: String.t(),
            destination: String.t()
          }
  end

  defmodule Footnote do
    defstruct children: [], attributes: [], label: ""

    @type t :: %__MODULE__{
            children: [Block.t()],
            attributes: [Attributes.t()],
            label: String.t()
          }
  end

  defmodule Doc do
    defstruct children: [], attributes: [], references: %{}, footnotes: %{}

    @type t :: %__MODULE__{
            children: [Block.t()],
            attributes: [Attributes.t()],
            references: %{optional(String.t()) => Ast.Reference.t()},
            footnotes: %{optional(String.t()) => Ast.Reference.t()}
          }
  end

  @type ast_node ::
          Doc.t()
          | Block.t()
          | Inline.t()
          | Block.ListItem.t()
          | Block.TaskListItem.t()
          | Block.DefinitionListItem.t()
          | Block.Term.t()
          | Block.Definition.t()
          | Block.TableRow.t()
          | Block.TableCell.t()
          | Block.TableCaption.t()
          | Footnote.t()
          | Reference.t()
end
