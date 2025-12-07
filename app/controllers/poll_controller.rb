class PollController < ApplicationController
  skip_before_action :verify_authenticity_token

  def get_trending_polls
    page = (params[:page] || 1).to_i
    per_page = 20
    polls = Poll.where(created_at: 7.days.ago..Time.current).order(totalvotes: :desc).offset((page - 1) * per_page).limit(per_page + 1)

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

  def get_popular_polls
    page = (params[:page] || 1).to_i
    per_page = 20
    polls = Poll.order(totalvotes: :desc).offset((page - 1) * per_page).limit(per_page + 1)
    
    user_email = session[:user_id] ? User.find_by(id: session[:user_id])&.email : nil

    render json: {
      page: page,
      has_more: polls.size > per_page,
      polls: polls.first(per_page).map { |poll|
        user_votes = JSON.parse(poll.user_votes.to_s.presence || "{}")
        user_voted_option = user_email ? user_votes[user_email] : nil
        {
          id: poll.id,
          title: poll.title,
          opt1: poll.opt1,
          opt2: poll.opt2,
          opt3: poll.opt3,
          opt4: poll.opt4,
          res1: poll.res1,
          res2: poll.res2,
          res3: poll.res3,
          res4: poll.res4,
          total_votes: poll.totalvotes,
          user_has_voted: user_voted_option.present?,
          user_voted_option: user_voted_option
        }
      }
    }
  end

  def get_recent_polls
    page = (params[:page] || 1).to_i
    per_page = 20
    polls = Poll.order(created_at: :desc).offset((page - 1) * per_page).limit(per_page + 1)
    
    user_email = session[:user_id] ? User.find_by(id: session[:user_id])&.email : nil
    
    render json: {
      page: page,
      has_more: polls.size > per_page,
      polls: polls.first(per_page).map { |poll|
        user_votes = JSON.parse(poll.user_votes.to_s.presence || "{}")
        user_voted_option = user_email ? user_votes[user_email] : nil
        {
          id: poll.id,
          title: poll.title,
          opt1: poll.opt1,
          opt2: poll.opt2,
          opt3: poll.opt3,
          opt4: poll.opt4,
          res1: poll.res1,
          res2: poll.res2,
          res3: poll.res3,
          res4: poll.res4,
          total_votes: poll.totalvotes,
          user_has_voted: user_voted_option.present?,
          user_voted_option: user_voted_option
        }
      }
    }
  end

  def get_new_polls
    page = (params[:page] || 1).to_i
    per_page = 20
    
    user_email = session[:user_id] ? User.find_by(id: session[:user_id])&.email : nil
    
    # Get all polls ordered by created_at, then filter out voted ones
    all_polls = Poll.order(created_at: :desc)
    
    # Filter out polls the user has voted on
    if user_email
      unvoted_polls = all_polls.select do |poll|
        user_votes = JSON.parse(poll.user_votes.to_s.presence || "{}")
        !user_votes.key?(user_email)
      end
    else
      unvoted_polls = all_polls.to_a
    end
    
    # Paginate the filtered results
    paginated_polls = unvoted_polls.drop((page - 1) * per_page).take(per_page + 1)
    
    render json: {
      page: page,
      has_more: paginated_polls.size > per_page,
      polls: paginated_polls.first(per_page).map { |poll|
        {
          id: poll.id,
          title: poll.title,
          opt1: poll.opt1,
          opt2: poll.opt2,
          opt3: poll.opt3,
          opt4: poll.opt4,
          res1: poll.res1,
          res2: poll.res2,
          res3: poll.res3,
          res4: poll.res4,
          total_votes: poll.totalvotes,
          user_has_voted: false,
          user_voted_option: nil
        }
      }
    }
  end

  def get_my_polls
    user = User.find_by(id: session[:user_id])
    unless user
      return render json: { error: "Not authenticated", polls: [], has_more: false }, status: :ok
    end

    page = (params[:page] || 1).to_i
    per_page = 20
    polls = Poll.where(email: user.email).order(created_at: :desc).offset((page - 1) * per_page).limit(per_page + 1)
    
    render json: {
      page: page,
      has_more: polls.size > per_page,
      polls: polls.first(per_page).map { |poll|
        user_votes = JSON.parse(poll.user_votes.to_s.presence || "{}")
        user_voted_option = user_votes[user.email]
        {
          id: poll.id,
          title: poll.title,
          opt1: poll.opt1,
          opt2: poll.opt2,
          opt3: poll.opt3,
          opt4: poll.opt4,
          res1: poll.res1,
          res2: poll.res2,
          res3: poll.res3,
          res4: poll.res4,
          total_votes: poll.totalvotes,
          user_has_voted: user_voted_option.present?,
          user_voted_option: user_voted_option
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

  def peek_poll
    poll = Poll.find_by(id: params[:id])
    unless poll
      return render json: { error: "Poll not found" }, status: :not_found
    end

    render json: {
      id: poll.id,
      title: poll.title,
      opt1: poll.opt1,
      opt2: poll.opt2,
      opt3: poll.opt3,
      opt4: poll.opt4,
      res1: poll.res1,
      res2: poll.res2,
      res3: poll.res3,
      res4: poll.res4,
      total_votes: poll.totalvotes
    }
  end

  def vote_poll
    user = User.find_by(id: session[:user_id])
    unless user
      return render json: { error: "Not authenticated" }, status: :unauthorized
    end
    
    variables = {
      pollId: params[:pollId],
      optionNumber: params[:optionNumber],
      userEmail: user.email
    }
    query = <<~GQL
      mutation($pollId: ID!, $optionNumber: Int!, $userEmail: String!) {
        votePoll(pollId: $pollId, optionNumber: $optionNumber, userEmail: $userEmail) {
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
    user = User.find_by(id: session[:user_id])
    unless user
      return render json: { error: "Not authenticated" }, status: :unauthorized
    end

    # Handle both direct params and nested poll params
    poll_params = params[:poll] || params
    variables = poll_params.permit(:title, :opt1, :opt2, :opt3, :opt4).to_h
    variables[:email] = user.email

    query = <<~GQL
      mutation($email: String!, $title: String!, $opt1: String!, $opt2: String!, $opt3: String, $opt4: String) {
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
