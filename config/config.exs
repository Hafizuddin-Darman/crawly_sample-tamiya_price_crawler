import Config

config :crawly,
  closespider_timeout: 1,
  concurrent_requests_per_domain: 8,
  closespider_itemcount: 10_000_000,
  pipelines: [
    {Crawly.Pipelines.Validate, fields: [:item_eng_name, :item_number, :item_price, :url]},
    {Crawly.Pipelines.DuplicatesFilter, item_id: :item_number},
    {Crawly.Pipelines.CSVEncoder, fields: [:item_eng_name, :item_number, :item_price, :url]},
    {Crawly.Pipelines.WriteToFile, extension: "csv", folder: "/tmp"}
  ]
