module Mutations
    class DeletePoll < GraphQL::Schema::Mutation
        field :poll, Types::PollType, null: false
        argument :poll_id, ID, required: true

        def resolve(poll_id:)
            poll = Poll.find(poll_id)
            poll.destroy!
            { poll: poll }
        end
    end
end  
