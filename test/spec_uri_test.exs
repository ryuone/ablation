defmodule SpecURI do
  use ExUnit.Case

  test "URI.encode with char_reserved?/1 predicate." do
    url = "https://www.google.com/";
    assert URI.encode(url, &URI.char_reserved?/1) == "%68%74%74%70%73://%77%77%77%2E%67%6F%6F%67%6C%65%2E%63%6F%6D/"
  end

  test "URI.encode with default predicate(&char_unescaped?/1)." do
    url = "https://www.google.com/";
    assert URI.encode(url) == url
  end

  test "URI.encode with char_unreserved/1 predicate." do
    url = "https://www.google.com/";
    assert URI.encode(url, &URI.char_unreserved?/1) == "https%3A%2F%2Fwww.google.com%2F"
  end


  test "URI.decode" do
    url = "https://www.google.com/";
    assert (URI.encode(url, &URI.char_reserved?/1) |> URI.decode) == url
  end

  test "URI.decode in Japanese" do
    url = "https://www.google.co.jp/#newwindow=1&q=てすと";
    assert (URI.encode(url, &URI.char_reserved?/1) |> URI.decode) == url
  end

  test "URI.decode_query" do
    query = "#newwindow=1&q=てすと"
    assert %{"#newwindow" => "1", "q" => "てすと"} == URI.decode_query(query)
  end

  test "URI.encode_query" do
    query = "%23newwindow=1&q=%E3%81%A6%E3%81%99%E3%81%A8"
    assert URI.encode_query(%{"#newwindow" => "1", "q" => "てすと"}) == query
  end

  test "URI.encode_www_form" do
    query = "#newwindow=1&q=てすと"
    assert "%23newwindow%3D1%26q%3D%E3%81%A6%E3%81%99%E3%81%A8" == URI.encode_www_form(query)
  end

  test "URI.decode_www_form" do
    query = "#newwindow=1&q=てすと"
    assert URI.decode_www_form("%23newwindow%3D1%26q%3D%E3%81%A6%E3%81%99%E3%81%A8") == query
  end

  test "URI.parse" do
    url = "https://www.google.co.jp/#newwindow=1&q=てすと";
    assert URI.parse(url) == %URI{
      authority: "www.google.co.jp",
      fragment: "newwindow=1&q=てすと",
      host: "www.google.co.jp",
      path: "/",
      port: 443,
      query: nil,
      scheme: "https",
      userinfo: nil
    }
  end

  test "URI.query_decoder" do
    assert [{"foo", "1"}, {"bar", "100"}, {"q", "テスト"}] == URI.query_decoder("foo=1&bar=100&q=テスト") |> Enum.map(&(&1))
  end

  test "URI.parse and to_string" do
    url = "https://www.google.co.jp/#newwindow=1&q=てすと";
    assert %URI{
      authority: "www.google.co.jp",
      fragment: "newwindow=1&q=てすと",
      host: "www.google.co.jp",
      path: "/",
      port: 443,
      query: nil,
      scheme: "https",
      userinfo: nil
    } |> URI.to_string == url
  end
end
