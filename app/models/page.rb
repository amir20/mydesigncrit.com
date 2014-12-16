class Page < ActiveRecord::Base
  validates :url, url: { allow_nil: true }

  has_many :crits
  belongs_to :project, touch: true, counter_cache: true

  acts_as_paranoid

  CONNECTION = Fog::Storage.new(
      provider: 'Rackspace',
      rackspace_username: 'amirraminfar',
      rackspace_api_key: '59408113174c92574d89ef18847b15ed',
      rackspace_region: 'dfw'
  )

  def process
    large_file = Pathname.new(Rails.root.join('public', 'assets', 'jobs', id.to_s, 'screenshot.png'))
    if screenshot.present?
      img = ::Magick::Image.read(Pathname.new(Rails.root.join('public' + screenshot))).first
      img.resize!(1024.to_f / img.columns) if img.columns > 1024
      img.write(large_file)
    else
      response = create_screenshot(large_file)
      img = ::Magick::Image.read(large_file).first
      self.title = response['title']
    end

    # Create thumbnail
    thumb_file = Pathname.new(Rails.root.join('public', 'assets', 'jobs', id.to_s, 'thumbnail.png'))
    img.resize_to_fill(160 * 2, 120 * 2, Magick::NorthGravity).write(thumb_file)

    self.processed = true
    self.width = img.columns
    self.height = img.rows
    self.thumbnail = upload_to_cdn(thumb_file, "thumbnail_#{id}_#{SecureRandom.hex}.png")
    self.screenshot = upload_to_cdn(large_file, "screenshot_#{id}_#{SecureRandom.hex}.png")

    FileUtils.rm_rf(thumb_file.parent)

    project.reload
    if project.pages.size == 1
      project.title = title
      project.thumbnail = thumbnail
      project.save
    end

    save
  rescue => e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    self.processed = true
    save
  end

  def upload_to_cdn(file, key)
    directory = CONNECTION.directories.get('designcrit')
    file = directory.files.create(
        key: key,
        body: File.open(file),
        public: true
    )
    file.public_url
  end

  def self.create_from_image!(params)
    page = create!(title: params[:image].original_filename)
    dir = Rails.root.join('public', 'assets', 'jobs', page.id.to_s)
    FileUtils.mkdir_p(dir) unless dir.exist?

    File.open(Rails.root.join('public', 'assets', 'jobs', page.id.to_s, params[:image].original_filename), 'wb') do |file|
      file.write(params[:image].read)
    end
    page.screenshot = "/assets/jobs/#{page.id}/#{params[:image].original_filename}"
    page.save!

    page
  end

  def self.create_from_url!(params)
    create!(url: params[:url], title: 'Loading...')
  end

  def self.create_from_url_or_image!(params)
    params[:image].present? ? create_from_image!(params) : create_from_url!(params)
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
