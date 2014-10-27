json.extract! project, :id, :title, :created_at, :updated_at
json.thumbnail ssl_cdn(project.thumbnail)
