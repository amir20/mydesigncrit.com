class ShareMailer < ActionMailer::Base
  default from: 'no-reply@designcrit.io'

  def send_project_to(project, to)
    @project = project
    mail(to: to, subject: 'A project on DesignCrit.io has been shared with you!')
  end
end
