class TestController < ApplicationController
    def helloworld
        name = params[:name]
        render json: {message:"This is a test, Hello #{name}"}
    end
end
