json.extract! page, :id, :url, :title, :width, :height, :processed, :created_at, :updated_at
json.screenshot ssl_cdn(page.screenshot)
json.thumbnail ssl_cdn(page.thumbnail)
