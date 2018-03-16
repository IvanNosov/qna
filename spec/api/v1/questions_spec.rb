require 'rails_helper'

describe "Questions API" do
  describe "GET /index" do
    context 'unauthorized' do
      it 'returns 401 status if request without access token' do
        get '/api/v1/questions', params: { format: 'json' }
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access token is wrong' do
        get '/api/v1/questions', params: { format: 'json', access_token: '1243456467' }
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) {questions.first }
      let!(:answer) { create(:answer, question: question) }

      before do
        get '/api/v1/questions', params: { format: 'json', access_token: access_token.token }
      end
      
      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do 
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      context "answers" do

        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end

      end
      
    end
    
  end
  
end



