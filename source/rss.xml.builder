xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  site_url = "http://blog.katsuma.tv/"
  xml.channel do
    xml.title "blog.katsuma.tv"
    xml.subtitle "適当に直感で思ったことを何も考えず発信"
    xml.copyright "Copyright #{Time.now.year}"
    xml.link site_url

    blog.articles[0..5].each do |article|
      xml.item do
        xml.title article.title
        xml.link URI.join(site_url, article.url)
        xml.description article.body
        xml.pubDate Time.parse(article.date.to_time.iso8601).rfc822()
        xml.guid URI.join(site_url, article.url)
      end
    end
  end
end
