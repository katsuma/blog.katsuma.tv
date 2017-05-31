require 'fastimage'

STYLE = File.read("build/stylesheets/bundle.css")
STYLESHEET_REGEXP = /<link href=\"\/stylesheets\/bundle\.css\" rel="?stylesheet"? \/>/

IMG_REGEXP = /(<img([\w\W]+?)\/>)/i
IFRAME_REGEXP = /(<iframe([\w\W]+?)><\/iframe>)/i

HOST = "blog.katsuma.tv"

Time.zone = "Tokyo"

# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

ignore '/layout_amp.html'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true

helpers do
  def host
    HOST
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

activate :sitemap_ping do |config|
  config.host         = "https://#{HOST}"
  config.after_build  = false
end

def modify_html_as_amp_format(html)
  html = use_amp_img(html)
  html = use_amp_iframe(html)
  html = use_inline_style(html)

  html
end

def use_amp_img(html)
  html.scan(IMG_REGEXP).each do |imgs|
    src = imgs[1].match(/src=\"([\w\W]+?)\"/)[1]
    path = src.start_with?('/') ? (build? ? "build#{src}" : "sources#{src}") : src
    sizes = FastImage.size(path)
    html.gsub!(imgs[0], "<amp-img src=\"#{src}\" width=\"#{sizes[0]}\" height=\"#{sizes[1]}\" />") if sizes
  end
  html
end

def use_amp_iframe(html)
  html.scan(IFRAME_REGEXP).each do |iframes|
    next unless iframes.any?

    if iframes[0].include?('youtube.com')
      w = iframes[1].match(/width=\"?(\d+)\"?/)[1]
      h = iframes[1].match(/height=\"?(\d+)\"?/)[1]
      v = iframes[1].match(/src=\"\/\/www.youtube\.com\/embed\/(.+)\"/)[1]
      html.gsub!(iframes[0], "<amp-youtube width=\"#{w}\" height=\"#{h}\" layout=\"responsive\" data-videoid=\"#{v}\"></amp-youtube>")
    else
      attributes = iframes[1]
      attributes.gsub!(/marginwidth=\"?(\d+)\"?/, '')
      attributes.gsub!(/marginheight=\"?(\d+)\"?/, '')
      html.gsub!(iframes[0], "<amp-iframe #{attributes}></amp-iframe>")
    end
  end
  html
end

def use_inline_style(html)
  html.gsub(STYLESHEET_REGEXP, "<style amp-custom>#{STYLE}</style>")
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

app.after_render do |html, path, locations|
  if !build? && locations[:current_path].end_with?('.amp')
    modify_html_as_amp_format(html)
  end
end

after_build do
  logger.info "== Re-Build amp page (#{amp_paths.size})"
  amp_paths.each_with_index do |path, index|
    logger.info "== [#{index+1}/#{amp_paths.size}] #{path}"

    build_path = "build/#{path}"
    html = modify_html_as_amp_format(File.read(build_path))
    File.write(build_path, html)
  end
end
