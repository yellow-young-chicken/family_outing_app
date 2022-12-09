class Post < ApplicationRecord

  belongs_to :customer
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags


  has_many_attached :images

  def get_images
    unless images.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io:File.open(file_path),filename: 'default-image.jpg', content_type: 'image/jpeg')
      images
    else
      'no_image.jpg'
  end
end


end
