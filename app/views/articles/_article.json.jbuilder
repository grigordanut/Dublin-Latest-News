json.extract! article, :id, :headline, :content, :weblink, :created_at, :updated_at
json.url article_url(article, format: :json)
