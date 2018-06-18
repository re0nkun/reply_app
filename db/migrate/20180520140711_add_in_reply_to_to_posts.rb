class AddInReplyToToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :in_reply_to, :integer, default: 0
    add_index :posts, :in_reply_to
  end
end
