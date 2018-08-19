require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #index" do
    let(:user) { instance_double(User) }

    it "returns http success" do
      log_in(user)

      get :index
      # expect(response).to have_http_status(:success)
      expect(response.status).to be(200)
    end
  end

end
