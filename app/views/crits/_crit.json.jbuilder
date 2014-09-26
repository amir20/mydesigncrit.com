json.extract! crit, :id, :comment, :x, :y, :width, :height, :created_at, :updated_at
json.user do
  json.partial! 'users/user', user: crit.user
  json.owner crit.user == current_user
  json.can_manage can? :manage, crit
end

