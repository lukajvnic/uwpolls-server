module Types
  class MutationType < GraphQL::Schema::Object
    field :create_poll, mutation: Mutations::CreatePoll
    field :vote_poll, mutation: Mutations::VotePoll
  end
end
