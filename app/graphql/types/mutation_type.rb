module Types
  class MutationType < GraphQL::Schema::Object
    field :create_poll, mutation: Mutations::CreatePoll
    field :vote_poll, mutation: Mutations::VotePoll
    field :delete_poll, mutation: Mutations::DeletePoll
  end
end
