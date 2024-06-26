defmodule InfoSys.Wolfram do
   alias InfoSys.Result

  @behaviour InfoSys.Backend

  @base "http://api.wolframalpha.com/v1/result"

  @impl true
  def name, do: "wolfram"

  @impl true
  def compute(query_str, _opts) do
    query_str
    |> fetch_answers()
    |> build_results()
  end

  defp build_results(nil), do: []

  defp build_results(answer) do
    [%Result{backend: __MODULE__, score: 95, text: to_string(answer)}]
  end

  @http Application.compile_env(:info_sys, :wolfram)[:http_client] || Req
  defp fetch_answers(query) do
    # req = @http.new(base_url: @base)
    @http.get!(@base, params: [appid: id(), i: query]).body
    # @http.get!(req, url: "", params: [appid: id(), i: query]).body
  end

  defp id, do: Application.fetch_env!(:info_sys, :wolfram)[:app_id]
end
