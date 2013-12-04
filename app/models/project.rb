class Project < ActiveRecord::Base
  before_create { self.share_id = SecureRandom.hex(16) }

  has_many :pages
end
