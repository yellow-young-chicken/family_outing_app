class Post < ApplicationRecord

  belongs_to :customer
  belongs_to :spot
  # SQLのエラーが出てしまったため、クラス指定をしております。
  has_many :favorites, dependent: :destroy, class_name: "Favourite"
  has_many :comments, dependent: :destroy
  has_many :post_tags


  validates :title, presence:true
  validates :post_content, presence:true
  validates :spot_id, presence:true
  # 写真の投稿制限のためのメゾットを呼び出しております。
  validate :image_type, :image_size, :image_length


  has_many_attached :images
# 投稿画像がなかった場合のメゾットです。
  def get_images
    unless images.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      images.attach(io:File.open(file_path),filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    images
  end

def favorited_by?(customer)
  favorites.exists?(customer_id: customer.id)
end

private

  def image_type
    images.each do |image|
      if !image.blob.content_type.in?(%('image/jpeg image/png'))
        errors.add(:images, 'はjpegまたはpng形式でアップロードしてください')
      end
    end
  end

  def image_size
    images.each do |image|
      if image.blob.byte_size > 5.megabytes
        errors.add(:images, "は1つのファイル5MB以内にしてください")
      end
    end
  end

  def image_length
    if images.length > 3
      errors.add(:images, "は3枚以内にしてください")
    end
  end

end
