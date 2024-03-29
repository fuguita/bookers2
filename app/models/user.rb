class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    has_one_attached :profile_image

    has_many :books, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :book_comments, dependent: :destroy

    # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed

    validates :name, length: { in: 2..20 }, uniqueness: true
    validates :introduction, length: { maximum: 50 }

    def get_profile_image(width, height)
      unless profile_image.attached?
        file_path = Rails.root.join('app/assets/images/default-image.jpg')
        profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
      end
      profile_image.variant(resize_to_limit: [width, height]).processed
    end

  def self.search_for(word, method)
    if method == 'perfect_match'
      User.where(name: word)
    elsif method == 'forward_match'
      User.where('name LIKE ?', word+'%')
    elsif method == 'backward_match'
      User.where('name LIKE ?', '%'+word)
    elsif method
      User.where('name LIKE ?', '%'+word+'%')
    end
  end

  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

end
