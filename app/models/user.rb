class User < ApplicationRecord
  #remember_tokenの仮想の属性は自分で定義する必要がある
  attr_accessor :remember_token

  validates :name, presence: true, length: { maximum: 50 }
  validates :profile, presence: true, uniqueness: true
  validate :check_profile
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
  

  def check_profile
    unless self.profile.start_with?("https://libecity.com/user_profile/")
      errors.add(:base, "そのプロフィールURLは使用できません")
    end
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    #remember_tokenに　User.new_tokenを代入
    self.remember_token = User.new_token
    #validationを無視して更新　（:remember_digest属性にハッシュ化したremember_tokenを)
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
