xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  sitemap.resources.each do |resource|
    if resource.destination_path =~ /\.html(\.amp)?\Z/
      next if resource.destination_path =~ /(404\/|page\/\d+\/)index\.html\Z/

      xml.url do
        xml.loc "https://blog.katsuma.tv#{resource.url}"

        lastmod = resource.data.date.presence
        xml.lastmod Date.parse(lastmod).to_s if lastmod.present?

        xml.priority case resource.path
        when /\Aentries\//
            1.0
          when "index.html"
            0.8
          else
            0.5
        end
      end
    end
  end
end
