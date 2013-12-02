class AnonymousUser < User

  def self.create_guest
    create(name: 'Guest', provider: 'tilofy', email: "guest-#{SecureRandom.random_number(0xffffff)}@tilofy.com")
  end
end
