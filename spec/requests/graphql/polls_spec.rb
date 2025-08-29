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

    it "fetches a poll by id" do
        poll = Poll.create!(email: "a@b.com", title: "Fav Food?", opt1: "Pizza", opt2: "Burger")
    
        query = <<~GQL
          {
            poll(id: #{poll.id}) {
              id
              title
              email
            }
          }
        GQL
    
        result = graphql_query(query)
        poll_data = result["data"]["poll"]
    
        expect(poll_data["title"]).to eq("Fav Food?")
        expect(poll_data["email"]).to eq("a@b.com")
      end
    
    it "votes for a poll option" do
        poll = Poll.create!(email: "a@b.com", title: "Fav Color?", opt1: "Red", opt2: "Blue", res1: 0, res2: 0, totalvotes: 0)
    
        query = <<~GQL
          mutation {
            votePoll(pollId: #{poll.id}, optionNumber: 1) {
              poll {
                id
                res1
                totalvotes
              }
            }
          }
        GQL
    
        result = graphql_query(query)
        poll_data = result["data"]["votePoll"]["poll"]
    
        expect(poll_data["res1"]).to eq(1)
        expect(poll_data["totalvotes"]).to eq(1)
      end

      it "deletes poll" do
        poll = Poll.create!(email: "a@b.com", title: "Fav Drink?", opt1: "Tea", opt2: "Coffee")
    
        query = <<~GQL
          mutation {
            deletePoll(pollId: #{poll.id}) {
              poll {
                id
                title
              }
            }
          }
        GQL
    
        result = graphql_query(query)
        poll_data = result["data"]["deletePoll"]["poll"]
    
        expect(poll_data["title"]).to eq("Fav Drink?")
        expect(Poll.find_by(id: poll.id)).to be_nil
      end
    
end
