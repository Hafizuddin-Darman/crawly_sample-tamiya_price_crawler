import Config

config :crawly,
  closespider_timeout: 10,
  concurrent_requests_per_domain: 8,
  follow_redirects: true,
  closespider_itemcount: 1000,
  middlewares: [
    Crawly.Middlewares.DomainFilter,
    Crawly.Middlewares.UniqueRequest,
    Crawly.Middlewares.UserAgent
  ],
  pipelines: [
    {Crawly.Pipelines.Validate, fields: [:item_eng_name, :item_number, :item_price, :url]},
    {Crawly.Pipelines.DuplicatesFilter, item_id: :item_number},
    {Crawly.Pipelines.CSVEncoder, fields: [:item_eng_name, :item_number, :item_price, :url]},
    {Crawly.Pipelines.WriteToFile, extension: "csv", folder: "/tmp"}
  ]
