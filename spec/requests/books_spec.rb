require 'rails_helper'

describe 'Books API', type: :request do
    let(:first_author) { FactoryBot.create(:author, first_name: "George", last_name: "bush", age: 12) }
    let(:second_author) { FactoryBot.create(:author, first_name: "KJhon", last_name: "buh", age: 22) }

    describe 'GET /books' do

        before do
            FactoryBot.create(:book, title: "324", author: first_author)
            FactoryBot.create(:book, title: "first book", author: second_author)
        end
        it 'returns all books' do
            get '/api/v1/books'

            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(2)
            expect(response_body).to eq(
                [
                    {
                        'id' => 1,
                        'title' => '324',
                        'author_name' => 'George bush',
                        'author_age' => 12
                    },
                    {
                        'id' => 2,
                        'title' => 'first book',
                        'author_name' => 'KJhon buh',
                        'author_age' => 22
                    }
                ]
            )
        end

        it 'returns a subset of books based on limit'  do
            get '/api/v1/books', params: {limit: 1}
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        'id' => 1,
                        'title' => '324',
                        'author_name' => 'George bush',
                        'author_age' => 12
                    }
                ]
            )
        end

        it 'returns a subset of books based on limit and offset'  do
            get '/api/v1/books', params: {limit: 1, offset: 1}
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        'id' => 2,
                        'title' => 'first book',
                        'author_name' => 'KJhon buh',
                        'author_age' => 22
                    }
                ]
            )
        end
    end

    describe 'POST /books' do
        let!(:user) { FactoryBot.create(:user, password: 'Password') }
        it 'create a new book' do
            expect {
            post '/api/v1/books', params: {
                book: {title: "123"},
                author: {first_name: "ahsan", last_name: "akbar", age: 13}
            }, headers: { 'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSJ9.M1vu6qDej7HzuSxcfbE6KAMekNUXB3EWtxwS0pg4UGg' } 
            }.to change { Book.count }.from(0).to(1)

            expect(response).to have_http_status(:created)
            expect(Author.count).to eq(1)
            expect(response_body).to eq(
                {
                    'id' => 1,
                    'title' => '123',
                    'author_name' => 'ahsan akbar',
                    'author_age' => 13
                }
            )
        end
    end


    describe 'DELETE /books/:id' do
        let!(:book) { FactoryBot.create(:book, title: "324", author: first_author) }
        let!(:user) { FactoryBot.create(:user, password: 'Password') }
        it 'deletes a book' do
            expect {
                delete "/api/v1/books/#{book.id}",
                headers: { 'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSJ9.M1vu6qDej7HzuSxcfbE6KAMekNUXB3EWtxwS0pg4UGg' } 
            }.to change { Book.count }.from(1).to(0)
            expect(response).to have_http_status(:no_content)
        end
    end
end
