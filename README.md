# TamiyaItemCrawler

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tamiya_item_crawler` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tamiya_item_crawler, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/tamiya_item_crawler](https://hexdocs.pm/tamiya_item_crawler).

## Notes

To run the crawler, follow these steps

- run the iex console
```elixir
iex -S mix
```

- start the crawly spider
```elixir
Crawly.Engine.start_spider(Tamiya)
```