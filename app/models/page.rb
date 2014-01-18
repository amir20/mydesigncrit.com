class Page < ActiveRecord::Base
  validates :url, url: { allow_nil: true }

  has_many :crits
  belongs_to :project

  def process
    large_file = Pathname.new(Rails.root.join('public', 'assets', 'jobs', id.to_s, 'screenshot.png'))
    if self.screenshot.present?
      img = ::Magick::Image::read(Pathname.new(Rails.root.join('public' + self.screenshot))).first
      img.resize!(1024.to_f / img.columns).write(large_file)
    else
      response = create_screenshot(large_file)
      img = ::Magick::Image::read(large_file).first
      self.title = response['title']
    end

    # Create thumbnail
    thumb_file = Pathname.new(Rails.root.join('public', 'assets', 'jobs', id.to_s, 'thumbnail.png'))
    img.resize_to_fill(160 * 2, 120 * 2, Magick::NorthGravity).write(thumb_file)

    self.thumbnail = "/assets/jobs/#{id}/thumbnail.png"
    self.processed = true
    self.width = img.columns
    self.height = img.rows
    self.screenshot = "/assets/jobs/#{id}/screenshot.png"
    self.screenshot = "/assets/jobs/#{id}/screenshot.png"

    begin
      if self.project.pages.size == 1
        self.project.title = self.title
        self.project.save
      end

      save
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
    end
  end

  def self.create_from_image!(params)
    page = create!(title: params[:image].original_filename)
    dir = Rails.root.join('public', 'assets', 'jobs', page.id.to_s)
    FileUtils.mkdir_p(dir) unless dir.exist?

    File.open(Rails.root.join('public', 'assets', 'jobs', page.id.to_s, params[:image].original_filename), 'wb') do |file|
      file.write(params[:image].read)
      page.screenshot = "/assets/jobs/#{page.id.to_s}/#{params[:image].original_filename}"
      page.save!
    end

    page
  end

  def self.create_from_url!(params)
    create!(url: params[:url], title: 'Loading...')
  end

  def self.create_from_url_or_image!(params)
    page = params[:image].present? ? create_from_image!(params) : create_from_url!(params)
    page.process
    page
  end

  handle_asynchronously :process

  private
  def create_screenshot(image)
    Rails.logger.info("Rasterizing #{url}.")
    FileUtils.mkdir_p(image.parent) unless image.parent.exist?
    bin = Rails.root.join('rasterize.js')
    json = `phantomjs #{bin} #{url} #{image.to_s}`
    JSON.parse(json.each_line.to_a.last)
  end
end
