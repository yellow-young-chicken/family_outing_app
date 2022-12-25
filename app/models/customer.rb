class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :spot

  validates :account_name, uniqueness: true, length: { minimum:2 , maximum:20}
  validates :introduction, length: {maximum:200}



  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
    # SQLのエラーが出てしまったため、クラス指定をしております。
  has_many :favorites, dependent: :destroy, class_name: "Favourite"
  has_many :liked_posts, through: :favorites, source: :post

  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy




  def follow(customer)
    relationships.create(followed_id: customer.id)
  end

  def unfollow(customer)
    relationships.find_by(followed_id: customer.id).destroy
  end

  def following?(customer)
    followings.include?(customer)
  end


  has_one_attached :profile_image
  # プロフィール画像がなかった場合の設定、サイズの調整のためのメゾットです。
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/animal_chara_radio_penguin.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # ゲストログインのためのメゾットです。
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.account_name = "ゲスト"
      customer.spot_id = 1
    end
  end

  # 検索のためのメゾットです。
  def self.search_for(content, method, spot_id)
    customers =
    if content.blank?
      Customer.all
    else
      if method == 'perfect'
        Customer.where(account_name: content)
      elsif method == 'forward'
        Customer.where('account_name LIKE ?', content + '%')
      elsif method == 'backward'
        Customer.where('account_name LIKE ?', '%' + content)
      else
        Customer.where('account_name LIKE ?', '%' + content + '%')
      end
    end
    spot_id.blank? ? customers : customers.where(spot_id: spot_id)
    #spot_id.blank? ? ~~ は下記と同じ内容です。
    #if spot_id.blank?
      #customers
    #else
      #csutomers.where()
    #end
  end

    def create_notification_follow!(current_customer)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_customer.id, id, 'follow'])
    if temp.blank?
      notification = current_customer.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end


end
