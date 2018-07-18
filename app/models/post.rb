class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :user
  has_many :likes
  has_many :liked_users, through: :likes, source: :user
  mount_uploader :img, ImgUploader

  # 검증(model validation)
  validates :title, presence: {message: ".. 제목을 입력해주세요."}, length: {minimum: 8, maximum: 20, too_long: "제목은 %{count}자 이내로 입력해주세요.", too_short: "제목은 %{count}자 이상으로 입력해주세요."}
  validates :content, presence: {message: ".. 내용을 입력해주세요."}

end
