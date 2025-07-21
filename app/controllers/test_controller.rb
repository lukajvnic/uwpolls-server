class TestController < ApplicationController
    def helloworld
        render json: {message: "This is a test, Hello World"}
    end
end
