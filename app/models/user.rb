class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
        
  has_many :posts

  has_many :active_rels, class_name: "Relation", foreign_key: :follower_id
  has_many :followeds, through: :active_rels
  has_many :passive_rels, class_name: "Relation", foreign_key: :followed_id
  has_many :followers, through: :passive_rels

  validates :name, presence: true

  # def followed_by? u
  #   self.passive_rels.where(follower_id: u.id).exists?
  # end

  def following? other_user
    self.followeds.include?(other_user)
  end

  def feed
    following_ids = "SELECT followed_id FROM relations
                     WHERE follower_id = :user_id"
    Post.where(in_reply_to: [self.id, 0]).or(Post.where(user_id: self.id))
    .where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: self.id)
    # ユーザーのidと同じ数字のin_reply_toを持つポスト　or
    # in_reply_toの数字が0のポスト or
    # ユーザーが投稿したポスト 
  end

end
