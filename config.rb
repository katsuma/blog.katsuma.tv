# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

page "/feed.xml", layout: false

helpers do
  def host
    "blog.katsuma.tv"
  end
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


configure :development do
  activate :livereload
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :minify_html
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
