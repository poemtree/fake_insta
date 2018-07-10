class Identity < ActiveRecord::Base
  belongs_to :user

  def self.find_auth(auth)
    identity = Identity.find_or_create_by(
      provider: auth.provider,
      uid: auth.uid
    )
  end
end
