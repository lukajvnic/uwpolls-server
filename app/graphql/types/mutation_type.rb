module Types
  class MutationType < Types::BaseObject
    field :create_poll, mutation: Mutations::CreatePoll
  end
end
