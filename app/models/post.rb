class Post < ApplicationRecord
  before_validation :set_in_reply_to

  belongs_to :user

  validates :user_id, presence: true
  validates :body, presence: true
  validates :in_reply_to, presence: false
  validate :reply_to_user

  default_scope -> { order(created_at: :desc) }

  def set_in_reply_to
    if @index = body.index("@")
      reply_id = []
      while is_i?(body[@index+1])
        @index += 1
        reply_id << body[@index]
      end
      self.in_reply_to = reply_id.join.to_i
    else
      self.in_reply_to = 0
    end
  end
  def is_i?(s)
    Integer(s) != nil rescue false
  end
  # post.bodyから最初の＠を見つけて後に続く数字をin_reply_toに入れる。なければ0をいれる


  def reply_to_user
    return if self.in_reply_to == 0

    if !(user = User.find_by(id: self.in_reply_to))
      errors.add(:base, "User ID you specified doesn't exist.")
    else
      if user_id == self.in_reply_to
        errors.add(:base, "You can't reply to yourself.")
      else
        if !(reply_to_user_name_correct?(user))
          errors.add(:base, "User ID doesn't match its name.")
        end
      end
    end
  end
  def reply_to_user_name_correct?(user)
    user_name = user.name.gsub(" ","-")
    body[@index+2, user_name.length] == user_name
  end

  # def self.including_replies(id)
  #   where(in_reply_to: [id, 0])
  #     .or(Post.where(user_id: id))
  # end
end
