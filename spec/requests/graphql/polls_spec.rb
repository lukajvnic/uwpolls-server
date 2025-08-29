require 'rails_helper'

RSpec.describe "Polls GraphQL API", type: :request do
  def graphql_query(query)
    post "/graphql", params: { query: query }
    JSON.parse(response.body)
  end

  it "creates a poll" do
    query = <<~GQL
      mutation {
        createPoll(
          email: "test@example.com"
          title: "Best Language?"
          opt1: "Ruby"
          opt2: "Python"
          opt3: "Go"
          opt4: "Java"
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

    result = graphql_query(query)
    poll_data = result["data"]["createPoll"]["poll"]

    expect(poll_data["title"]).to eq("Best Language?")
    expect(poll_data["opt1"]).to eq("Ruby")
    expect(poll_data["totalvotes"]).to eq(0)
    end
end
