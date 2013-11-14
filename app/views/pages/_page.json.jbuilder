json.extract! page, :id, :url, :title, :width, :height, :processed
json.screenshot image_url(page.screenshot)
json.thumbnail image_url(page.thumbnail)