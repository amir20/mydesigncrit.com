json.extract! project, :id, :title, :thumbnail
json.pages do
  json.array! project.pages, partial: 'pages/page', as: :page
end
