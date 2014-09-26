json.extract! page, :id, :url, :title, :width, :height, :processed, :created_at, :updated_at
json.screenshot image_url(page.screenshot)
json.thumbnail image_url(page.thumbnail)
