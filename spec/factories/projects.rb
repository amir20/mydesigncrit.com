# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  title       :string(255)
#  thumbnail   :string(255)
#  share_id    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  pages_count :integer          default("0"), not null
#  crits_count :integer          default("0"), not null
#  private     :boolean          default("t"), not null
#  deleted_at  :datetime
#
# Indexes
#
#  index_projects_on_deleted_at  (deleted_at)
#  index_projects_on_user_id     (user_id)
#
FactoryGirl.define do
  factory :project do
    user
    title 'Factory Created Project'
    private false

    factory :project_with_pages do
      transient { pages_count 1 }

      after(:create) do |project, evaluator|
        create_list(:page, evaluator.pages_count, project: project)
      end
    end
  end
end
