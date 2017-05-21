require 'fastimage'

STYLE = File.read("build/stylesheets/bundle.css")
STYLESHEET_LINK_REGEXP = /<link href=\"([..\/]*?stylesheets\/[\w\-]*\.css)\" rel="?stylesheet"? \/>/
IMG_LINK_REGEXP = /<img\s[^>]*?src\s*=\s*['\"]([^'\"]*?)['\"][^>]*?>/i

Time.zone = "Tokyo"

# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

ignore '/layout_amp.html'

helpers do
  def host
    "blog.katsuma.tv"
  end

  def description
    "適当に直感で思ったことを何も考えず発信"
  end
end

configure :development do
  activate :livereload
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :minify_html
end

activate :blog do |blog|
  blog.permalink = "{year}/{month}/{title}.html"
  blog.sources = "entries/{year}/{month}/{day}/{title}.html"

  blog.taglink = "{tag}/index.html"
  blog.year_link = "{year}/index.html"
  blog.month_link = "{year}/{month}/index.html"
  blog.day_link = "{year}/{month}/{day}/index.html"

  blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"
  blog.layout = 'blog'

  # Enable pagination
  blog.paginate = true
  blog.per_page = 3
  blog.page_link = "page/{num}"
end

activate :external_pipeline,
  name: :webpack,
  command: build? ? './node_modules/webpack/bin/webpack.js --bail' : './node_modules/webpack/bin/webpack.js --watch -d',
  source: ".tmp/dist",
  latency: 1

activate :deploy do |deploy|
  deploy.deploy_method = :rsync
  deploy.host  = ENV['DEPLOY_HOST']
  deploy.port  = ENV['DEPLOY_PORT'].to_i
  deploy.path  = ENV['DEPLOY_PATH']
  deploy.user  = ENV['DEPLOY_USER']
  deploy.flags = ENV['DEPLOY_FLAGS']
end

def modify_html_as_amp_format(path)
  html = File.read(path)

  html = use_amp_img(html)
  html = use_inline_style(html)

  File.write(path, html)
end

def use_amp_img(html)
  html.scan(IMG_LINK_REGEXP).each do |img_sources|
    src = img_sources[0]
    scanned_src = src.start_with?('/') ? 'build' + src : src
    sizes = FastImage.size(scanned_src)
    if sizes
      html.gsub!(IMG_LINK_REGEXP, "<amp-img src='#{src}' with='#{sizes[0]}' height='#{sizes[1]}' />")
    end
  end
  html
end

def use_inline_style(html)
  html.gsub(STYLESHEET_LINK_REGEXP, "<style amp-custom>#{STYLE}</style>")
end

amp_paths = []

ready do
  sitemap.resources.select { |resource|
    resource.path.end_with?(".html") && resource.is_a?(Middleman::Blog::BlogArticle)
  }.each do |article|
    proxy_path = "#{article.date.year}/#{article.date.month.to_s.rjust(2, '0')}/#{article.destination_path.split("/").last}.amp"
    proxy proxy_path, "layout_amp.html", locals: { article: article }

    amp_paths << proxy_path
  end
end

after_build do
  amp_paths.each do |path|
    modify_html_as_amp_format("build/#{path}")
  end
end
