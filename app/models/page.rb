class Page < ActiveRecord::Base
  has_many :crits

  def process
    file = Rails.root.join 'rasterize.js'
    Rails.logger.info("Rasterizing #{url}.")
    out = Phantomjs.run(file, url, 'example.png')
    Rails.logger.info(out)
  end

  handle_asynchronously :process
end
