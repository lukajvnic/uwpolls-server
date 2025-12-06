module Mutations
  class VotePoll < GraphQL::Schema::Mutation
    field :poll, Types::PollType, null: false
    argument :poll_id, ID, required: true
    argument :option_number, Integer, required: true
    argument :user_email, String, required: true

    def resolve(poll_id:, option_number:, user_email:)
      poll = Poll.find(poll_id)
      unless (1..4).include?(option_number)
        raise GraphQL::ExecutionError, "Invalid option number"
      end
      
      # Parse existing votes (JSON format: {"email": option_number})
      user_votes = JSON.parse(poll.user_votes.to_s.presence || "{}")
      
      # Check if user has already voted
      if user_votes.key?(user_email)
        raise GraphQL::ExecutionError, "You have already voted on this poll"
      end
      
      # Record the vote
      res_column = "res#{option_number}"
      poll.increment!(res_column)
      poll.increment!(:totalvotes)
      
      # Add user's vote to JSON
      user_votes[user_email] = option_number
      poll.update!(user_votes: user_votes.to_json)
      
      { poll: poll }
    end
  end
end
