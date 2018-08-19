require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:user) { instance_double(User) }

  before { log_in(user) }

  describe "GET #index" do
    let(:books) { [ instance_double(Book), instance_double(Book) ] }

    before do
      allow(user).to receive(:books).and_return(books)

      get :index
    end

    it "shows all the books belong to current user" do
      expect(assigns(:books)).to eq(books)
    end
  end

  describe "POST create" do
    let(:book) { FactoryBot.build_stubbed(:book) }
    let(:params) { { name: "Moby-Dick", author: "Herman Melville" } }

    before do
      allow(book).to receive(:save)
      allow(user).to receive_message_chain(:books, :build).and_return(book)
    end

    it "saves the book" do
      post :create, params: { book: params }
      expect(book).to have_received(:save)
    end
  end
end
