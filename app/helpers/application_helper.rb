module ApplicationHelper
  def category_or_title_name(folder)
    if folder.brand_folder?
      folder.brand.title
    else
      folder.category.name
    end
  end  
  
  def video_thumbnail(ad)
    "http://img.youtube.com/vi/#{URI.parse(ad.image_url).path.split('/').last}/0.jpg"
  end
end
