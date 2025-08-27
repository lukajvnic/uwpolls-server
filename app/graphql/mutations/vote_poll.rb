module Mutations
  class VotePoll < GraphQL::Schema::Mutation
    field :poll, Types::PollType, null: false
    argument :poll_id, ID, required: true
    argument :option_number, Integer, required: true

    def resolve(poll_id:, option_number:)
      poll = Poll.find(poll_id)
      unless (1..4).include?(option_number)
        raise GraphQL::ExecutionError, "Invalid option number"
      end
      res_column = "res#{option_number}"
      poll.increment!(res_column)
      poll.increment!(:totalvotes)
      
      { poll: poll }
    end
  end
end
