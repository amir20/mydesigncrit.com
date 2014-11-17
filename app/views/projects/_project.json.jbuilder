json.extract! project, :id, :title, :created_at, :updated_at, :share_id
json.thumbnail ssl_cdn(project.thumbnail)
