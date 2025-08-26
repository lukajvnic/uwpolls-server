module Mutations
  class CreatePoll < GraphQL::Schema::Mutation
    # Return type
    field :poll, Types::PollType, null: false

    # Arguments (note: no wrapping in `input`)
    argument :email, String, required: true
    argument :title, String, required: true
    argument :opt1, String, required: true
    argument :opt2, String, required: true
    argument :opt3, String, required: false
    argument :opt4, String, required: false

    def resolve(email:, title:, opt1:, opt2:, opt3: nil, opt4: nil)
      poll = Poll.create!(
        email: email,
        title: title,
        opt1: opt1,
        opt2: opt2,
        opt3: opt3,
        opt4: opt4,
        totalvotes: 0,
        timeposted: Time.current
      )

      { poll: poll }
    end
  end
end
