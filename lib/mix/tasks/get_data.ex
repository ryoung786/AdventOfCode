defmodule Mix.Tasks.GetData do
  use Mix.Task
  @requirements ["app.config"]

  def run(args) do
    {:ok, _} = Application.ensure_all_started(:req)

    {opts, _, _} =
      OptionParser.parse(args,
        aliases: [y: :year, d: :day],
        switches: [year: :integer, day: :integer]
      )

    year = Keyword.get(opts, :year, 2025)
    day = Keyword.get(opts, :day, 1)
    session_key = Application.get_env(:aoc, :session_keys)[year]

    headers = [cookie: "session=#{session_key}"]
    req = Req.new(base_url: "https://adventofcode.com/#{year}/day/#{day}", headers: headers)
    contents = Req.get!(req, url: "/input").body
    input_filename = (day |> Integer.to_string() |> String.pad_leading(2, "0")) <> ".input"

    File.write!(
      Path.join([:code.priv_dir(:aoc), "#{year}", input_filename]),
      contents
    )
  end
end
