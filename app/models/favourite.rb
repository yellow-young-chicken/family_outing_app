class Favourite < ApplicationRecord

  # SQLのエラーが出てしまったため、クラス指定をしております。
  belongs_to :post, class_name: "Post"
  belongs_to :customer, class_name: "Customer"

end
