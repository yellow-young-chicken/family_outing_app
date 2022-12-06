class Post < ApplicationRecord

  belongs_to :customer
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags





  has_many_attached :images


end
