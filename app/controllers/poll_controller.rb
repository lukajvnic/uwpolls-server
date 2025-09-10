class PollController < ApplicationController
  skip_before_action :verify_authenticity_token

  def get_popular_polls
    page = (params[:page] || 1).to_i
    per_page = 20
    polls = Poll.order(totalvotes: :desc).offset((page - 1) * per_page).limit(per_page + 1)

    render json: {
      page: page,
      has_more: polls.size > per_page,
      polls: polls.first(per_page).map { |poll|
        {
          id: poll.id,
          title: poll.title,
          opt1: poll.opt1,
          opt2: poll.opt2,
          opt3: poll.opt3,
          opt4: poll.opt4,
          total_votes: poll.totalvotes
        }
      }
    }
  end

  def get_recent_polls
    page = (params[:page] || 1).to_i
    per_page = 20
    polls = Poll.order(created_at: :desc).offset((page - 1) * per_page).limit(per_page + 1)
    
    render json: {
      page: page,
      has_more: polls.size > per_page,
      polls: polls.first(per_page).map { |poll|
        {
          id: poll.id,
          title: poll.title,
          opt1: poll.opt1,
          opt2: poll.opt2,
          opt3: poll.opt3,
          opt4: poll.opt4,
          total_votes: poll.totalvotes
        }
      }
    }
  end

  def get_random_poll
    poll = Poll.order("RANDOM()").first
    render json: {
      id: poll.id,
      title: poll.title,
      opt1: poll.opt1,
      opt2: poll.opt2,
      opt3: poll.opt3,
      opt4: poll.opt4,
      total_votes: poll.totalvotes
    }
  end

  def search_polls
    query_param = params[:query] || ""
    page = (params[:page] || 1).to_i
    per_page = 20
    polls = Poll.where("title ILIKE ?", "%#{query_param}%").order(created_at: :desc).offset((page - 1) * per_page).limit(per_page + 1)
    render json: {
      page: page,
      has_more: polls.size > per_page,
      polls: polls.first(per_page).map { |poll|
        {
          id: poll.id,
          title: poll.title,
          opt1: poll.opt1,
          opt2: poll.opt2,
          opt3: poll.opt3,
          opt4: poll.opt4,
          total_votes: poll.totalvotes
        }
      }
    }
  end

  def delete_poll
    variables = params.permit(:pollId).to_h
    query = <<~GQL
      mutation($pollId: ID!) {
        deletePoll(pollId: $pollId) {}
      }
    GQL
    result = MyAppSchema.execute(query, variables: variables)
    render json: result
  end

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
