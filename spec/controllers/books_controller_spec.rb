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

  describe "POST #create" do
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

    context "when the book is successfully saved" do
      before do
        allow(book).to receive(:save).and_return(true)
        post :create, params: { book: params }
      end

      it "redirects to the book show page" do
        expect(response).to redirect_to(book_path(book))
        expect(flash[:notice]).to eql("Book was successfully created.")
      end
    end

    context "when the book can't be saved" do
      before do
        allow(book).to receive(:save).and_return(false)
        post :create, params: { book: params }
      end

      it "renders the new page again" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    let(:book) { FactoryBot.build_stubbed(:book) }

    before do
      allow(Book).to receive(:find).and_return(book)
      allow(book).to receive(:update)
    end

    it "updates the book" do
      patch :update, params: { id: book.id, book: { name: "New name" } }
      expect(book).to have_received(:update)
    end

    context "when the update succeeds" do
      before do
        allow(book).to receive(:update).and_return(true)
        patch :update, params: { id: book.id, book: { name: "New name" } }
      end

      it "redirects to the book page" do
        expect(response).to redirect_to(book_path(book))
      end
    end

    context "when the update fails" do
      before do
        allow(book).to receive(:update).and_return(false)
        patch :update, params: { id: book.id, book: { name: "New name" } }
      end

      it "renders the edit page again" do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:book) { FactoryBot.build_stubbed(:book) }

    before do
      allow(Book).to receive(:find).and_return(book)
      allow(book).to receive(:destroy)

      delete :destroy, params: { id: book.id }
    end

    it "destroys the book" do
      expect(book).to have_received(:destroy)
    end

    it "redirects to the index page" do
      expect(response).to redirect_to(books_path)
    end
  end
end
