class Page < ActiveRecord::Base
  validates :url, presence: true, url: true

  has_many :crits
  belongs_to :project

  def process
    large_file = Pathname.new(Rails.root.join('public', 'jobs', id.to_s, 'screenshot.png'))
    thumb_file = Pathname.new(Rails.root.join('public', 'jobs', id.to_s, 'thumbnail.png'))

    response = create_screenshot(large_file)
    img = Magick::Image::read(large_file).first
    img.resize_to_fill(160 * 2, 120 * 2, Magick::NorthGravity).write(thumb_file)

    self.title = response['title']
    self.width = img.columns
    self.height = img.rows
    self.screenshot = "/jobs/#{id}/screenshot.png"
    self.thumbnail = "/jobs/#{id}/thumbnail.png"
    self.processed = true

    if self.project.pages.size == 1
      self.project.title = self.title
      self.project.save
    end

    save!
  end

  handle_asynchronously :process

  private
  def create_screenshot(image)
    Rails.logger.info("Rasterizing #{url}.")
    FileUtils.mkdir_p(image.parent) unless image.parent.exist?
    bin = Rails.root.join('rasterize.js')
    json = Phantomjs.run(bin, url, image.to_s).strip
    JSON.parse(json)
  end
end
