module Types
    class PollType < Types::BaseObject
      field :id, ID, null: false
      field :email, String, null: false
      field :title, String, null: false
      field :opt1, String, null: true
      field :opt2, String, null: true
      field :opt3, String, null: true
      field :opt4, String, null: true
      field :res1, Integer, null: false
      field :res2, Integer, null: false
      field :res3, Integer, null: false
      field :res4, Integer, null: false
      field :totalvotes, Integer, null: false
      field :timeposted, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
  