class Post < ApplicationRecord

  belongs_to :customer
  belongs_to :spot   # , optional:true
  # SQLのエラーが出てしまったため、クラス指定をしております。
  has_many :favorites, dependent: :destroy, class_name: "Favourite"
  has_many :liked_customers, through: :favorites, source: :customer
  has_many :comments, dependent: :destroy
  has_many :post_tags
  has_many :notifications, dependent: :destroy


  validates :title, presence:true
  validates :post_content, presence:true
  # validates :spot_id, presence:true
  # レートの評価を1以上~5以下に設定しています。
  validates :rate, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true

  # 写真の投稿制限のためのメゾットを呼び出しております。
  validate :image_type, :image_size, :image_length


acts_as_taggable_on :tags



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

  # 検索のためのメゾットです。
  def self.search_for(content, method, spot_id)
    spots =
      if content.blank?
        Post.all
      else
        if method == 'perfect'
          Post.where(title: content)
        elsif method == 'forward'
          Post.where('title LIKE ?', content+'%')
        elsif method == 'backward'
          Post.where('title LIKE ?', '%'+content)
        else
          Post.where('title LIKE ?', '%'+content+'%')
        end
      end
    spot_id.blank? ? spots : spots.where(spot_id: spot_id)
  end


  def create_notification_like!(current_customer)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_customer.id, customer_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_customer.active_notifications.new(
        post_id: id,
        visited_id: customer_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end




     def create_notification_comment!(current_customer, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:customer_id).where(post_id: id).where.not(customer_id: current_customer.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_customer, comment_id, temp_id['customer_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_customer, comment_id, customer_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_customer, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_customer.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
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
