require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #index" do
    let(:user) { instance_double(User) }

    before do
      log_in(user)
    end

    it "returns http success" do
      get :index
      expect(response.status).to be(200)
    end
  end

end
