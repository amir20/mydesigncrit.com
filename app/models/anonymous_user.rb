class AnonymousUser < User
  def self.create_guest
    create(name: 'Guest', provider: 'designcrit', email: "#{SecureRandom.hex}@designcrit.io")
  end
end
