json.extract! @project, :id, :title, :thumbnail
json.pages @project.pages do |page|
  json.partial! page, partial: 'pages/page', as: :page
  json.crits page.crits, partial: 'crits/crit', as: :crit
end
