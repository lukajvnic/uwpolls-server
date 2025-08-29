# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test, String, null: false,
      description: "An example field added by the generator"
    def test
      "Hello World!"
    end

    field :users, [Types::UserType], null: false,
      description: "Lists all users"

    def users
      User.all
    end
    
    # TODO: Change later so it only load like 20 at a time
    field :poll, Types::PollType, null: true do
      description "Find a poll based on id"
      argument :id, ID, required: true
    end
    
    def poll(id:)
      Poll.find_by(id: id)
    end    
  end
end
