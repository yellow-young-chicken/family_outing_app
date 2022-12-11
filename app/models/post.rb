class Post < ApplicationRecord

  belongs_to :customer
  belongs_to :spot
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags


  validates :title, presence:true
  validates :post_content, presence:true
  validates :spot_id, presence:true


  has_many_attached :images
# 投稿画像がなかった場合の設定、サイズの調整のためのメゾットです。
  def get_images(width, height)
    unless images.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      images.attach(io:File.open(file_path),filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    images.variant(resize_to_limit: [width, height]).processed
  end

def favorited_by?(customer)
  favorites.exists?(customer_id: customer.id)
end

end
