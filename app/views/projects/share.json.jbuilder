json.partial! 'project', project: @project
json.pages @project.pages do |page|
  json.partial! 'pages/page', page: page
  json.crits page.crits, partial: 'crits/crit', as: :crit
end
