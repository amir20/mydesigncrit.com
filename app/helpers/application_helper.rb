module ApplicationHelper
  def anonymous_user?
    guest_or_current_user.is_a? AnonymousUser
  end

  def valid_session?
    guest_or_current_user.id.present?
  end

  def guest_or_current_user
    current_user || AnonymousUser.new(name: 'Guest')
  end

  def image_tag_with_at2x(name_at_1x, options = {})
    name_at_2x = name_at_1x.gsub(%r{\.\w+$}, '@2x\0')
    image_tag(name_at_1x, options.merge('data-at2x' => asset_path(name_at_2x)))
  end

  def nav_link(name, path)
    link_to name, path, class: ('active' if current_page?(path))
  end

  def project_img(project, options = {})
    if project.thumbnail?
      image_tag ssl_cdn(project.thumbnail), options.merge(height: nil)
    else
      image_tag 'no-image.png', options.merge('data-no-retina' => true)
    end
  end

  def ssl_cdn(url)
    url.gsub(/\.r\d\d\./, '.ssl.').sub('http:', 'https:') unless url.nil?
  end
end
