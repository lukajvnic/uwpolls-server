class AddUserVotesToPolls < ActiveRecord::Migration[8.0]
  def change
    add_column :polls, :user_votes, :text, default: "{}"
  end
end
