defmodule InfoSys.Test.HTTPClient do


  defstruct status: 200,
            header: "",
            body: "",
            trailers: ""

  @walfram_result  %{"1 + 1" => 2}

  def get!(_request, options \\ []) do
    case Keyword.fetch(options[:params], :i) do
      {:ok, value} ->
            %InfoSys.Test.HTTPClient{body: Map.get(@walfram_result, value, "")}
      _ -> %InfoSys.Test.HTTPClient{}
    end
  end

end
