class AddVotedEmailsToPolls < ActiveRecord::Migration[8.0]
  def change
    add_column :polls, :voted_emails, :text, default: ""
  end
end
