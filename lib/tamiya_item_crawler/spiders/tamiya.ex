defmodule Tamiya do
  @behaviour Crawly.Spider

  @impl Crawly.Spider
  def base_url() do
    "https://www.tamiya.com/japan"
  end

  @impl Crawly.Spider
  def init() do
    [
      start_urls: [
        "https://www.tamiya.com/japan/products/list.html?field_sort=a&sortkey=sort_ga&genre_item=30&cmdarticlesearch=1&absolutepage=1"
      ]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    # set the response body
    parsed_body = Floki.parse(response.body)

    # Getting item_urls to follow
    item_urls =
      parsed_body
      |> Floki.find("#wrapper")
      |> Floki.find(".item_list_")
      |> Floki.find("a")
      |> Floki.attribute("href")

    # Getting pagination_urls as well
    pagination_urls =
      parsed_body
      |> Floki.find(".navipage_.top_")
      |> Floki.find(".navipage_next_")
      |> Floki.find("a")
      |> Floki.attribute("href")
      # ensure the pagination_urls are absolute_url
      |> Enum.map(fn url ->
        url
        |> build_absolute_url()
      end)

    # combine both urls
    all_urls = item_urls ++ pagination_urls

    # Convert URLs into requests
    requests =
      Enum.map(all_urls, fn url ->
        url
        |> Crawly.Utils.request_from_url()
      end)

    # Extract details from the page, e.g.
    # https://www.tamiya.com/japan/products/10303/index.html

    # get item_title_block
    item_title_block = Floki.find(parsed_body, ".item_title_block_")

    # get item_name
    item_name =
      item_title_block
      |> Floki.filter_out("div.title1_")
      |> Floki.filter_out("div.title2_")

    item_eng_name =
      item_name
      |> Floki.find("span")
      |> Floki.text(deep: false)
      |> String.trim()

    item_eng_name = Enum.join(for <<c::utf8 <- item_eng_name>>, do: <<c::utf8>>)

    # # need to research further to get japanese characters
    # item_jap_name =
    #   item_name
    #   |> Floki.find("h1")
    #   |> Floki.text(deep: false)
    #   |> String.trim()

    # get item_number
    item_number =
      item_title_block
      |> Floki.find("div.title1_")
      |> Floki.find("span:first-of-type")
      |> Floki.text(deep: false)

    item_number = Enum.join(for <<c::utf8 <- item_number>>, do: <<c::utf8>>)

    item_number =
      item_number
      |> String.trim()
      |> String.graphemes()
      |> Enum.take(-5)
      |> Enum.join()

    # get item_price
    item_price =
      item_title_block
      |> Floki.find("div.title2_")
      |> Floki.find("div:first-of-type")
      |> Floki.find("p")
      |> Floki.text(deep: false)

    item_price = Enum.join(for <<c::utf8 <- item_price>>, do: <<c::utf8>>)

    %Crawly.ParsedItem{
      :requests => requests,
      :items => [
        %{
          item_eng_name: item_eng_name,
          item_number: item_number,
          item_price: item_price,
          url: response.request_url
        }
      ]
    }
  end

  defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()
end
