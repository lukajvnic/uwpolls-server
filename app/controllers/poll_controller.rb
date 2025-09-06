class PollController < ApplicationController
  skip_before_action :verify_authenticity_token

  def vote_poll
    variables = params.permit(:pollId, :optionNumber).to_h
    query = <<~GQL
      mutation($pollId: ID!, $optionNumber: Int!) {
        votePoll(pollId: $pollId, optionNumber: $optionNumber) {
          poll {
            res1,
            res2,
            res3,
            res4,
            totalvotes
          }
        }
      }
    GQL

    result = MyAppSchema.execute(query, variables: variables)
    render json: result
  end

  def create_poll
    variables = params.permit(:email, :title, :opt1, :opt2, :opt3, :opt4).to_h

    query = <<~GQL
      mutation($email: String!, $title: String!, $opt1: String!, $opt2: String!, $opt3: String!, $opt4: String!) {
        createPoll(
          email: $email,
          title: $title,
          opt1: $opt1,
          opt2: $opt2,
          opt3: $opt3,
          opt4: $opt4
        ) {
          poll {
            id
            title
            email
            opt1
            opt2
            opt3
            opt4
            totalvotes
          }
        }
      }
    GQL

    result = MyAppSchema.execute(query, variables: variables)
    render json: result
  end
end
