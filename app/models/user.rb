class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :kakao]
  has_many :posts
  has_many :comments
  has_many :likes
  has_many :liked_posts, through: :likes, source: :post

  # User.find_auth
  def self.find_auth(auth, signed_in_resource)
      # Identity가 있는지 검사 후 없으면 새로 생성
      # 새로 생성된 identity는 user가 nill 이므로 이를 검사하여
      # 신규 유저 생성이 가능하다
      identity = Identity.find_auth(auth)
      user = signed_in_resource ? signed_in_resource : identity.user

      # User가 있는지 검사
      if user.nil?
        user = User.find_by(email: auth.info.email)
        if auth.provider == 'kakao'
          user = User.new(
            name: auth.info.name,
            password: Devise.friendly_token[0,20],
            profile_img: auth.info.image
          )
        else
          user = User.new(
            email: auth.info.email,
            name: auth.info.name,
            password: Devise.friendly_token[0,20],
            profile_img: auth.info.image
          )
        end
      end
      user.save!
      if identity.user != user
        identity.user = user
        identity.save!
      end
      user
  end

  def email_required?
    false
  end

end
