require 'rails_helper'

shared_examples_for 'voted' do
  let!(:model) { described_class.controller_name.classify.constantize }
  let!(:votable) { create(model.to_s.underscore.to_sym) }
  let!(:voter) { create(:user) }
  let!(:authored) { create(model.to_s.underscore.to_sym, user: voter) }

  describe 'PATCH #vote_up' do
    context "User that isn't an author" do
      before { login(voter) }

      it 'assigns the requested resource to @votable' do
        patch :vote_up, params: { id: votable }
        expect(assigns(:votable)).to eq votable
      end

      it 'set new vote' do
        expect { patch :vote_up, params: { id: votable, format: :json } }.to change { votable.rating }.by(1)
      end

      it 'tries to vote twice' do
        patch :vote_up, params: { id: votable }
        expect { patch :vote_up, params: { id: votable, format: :json } }.to_not change { votable.rating }
      end

      it 'returns data in json' do
        patch :vote_up, params: { id: votable, format: :json }
        expect(JSON.parse(response.body).keys).to eq %w(resourceName resourceId rating)
      end
    end

    context 'User is author' do
      before { login(voter) }
      it 'tries to set vote' do
        expect { patch :vote_up, params: { id: authored, format: :json } }.to_not change { votable.rating }
      end

      it 'returns error response' do
        patch :vote_up, params: { id: authored, format: :json }
        expect(response.status).to eq 403
        expect(JSON.parse(response.body)['message']).to eq "You're an author, or not authorized"
      end
    end

    context 'Unauthorized user' do
      it 'set new vote' do
        expect { patch :vote_up, params: { id: votable, format: :json } }.to_not change { votable.rating }
      end

      it 'returns error response' do
        patch :vote_up, params: { id: votable, format: :json }
        expect(response.status).to eq 401
        expect(JSON.parse(response.body)['error']).to eq "You need to sign in or sign up before continuing."
      end
    end
  end

  describe 'PATCH #vote_down' do
    context "User that isn't an author" do
      before { login(voter) }

      it 'assigns the requested resource to @votable' do
        patch :vote_down, params: { id: votable }
        expect(assigns(:votable)).to eq votable
      end

      it 'set new vote down' do
        expect { patch :vote_down, params: { id: votable, format: :json } }.to change { votable.rating }.by(-1)
      end

      it 'tries to vote twice' do
        patch :vote_down, params: { id: votable }
        expect { patch :vote_down, params: { id: votable, format: :json } }.to_not change { votable.rating }
      end

      it 'returns data in json' do
        patch :vote_down, params: { id: votable, format: :json }
        expect(JSON.parse(response.body).keys).to eq %w(resourceName resourceId rating)
      end
    end

    context 'User is author' do
      before { login(voter) }
      it 'tries to set vote down' do
        expect { patch :vote_down, params: { id: authored, format: :json } }.to_not change { votable.rating }
      end

      it 'returns error response' do
        patch :vote_down, params: { id: authored, format: :json }
        expect(response.status).to eq 403
        expect(JSON.parse(response.body)['message']).to eq "You're an author, or not authorized"
      end
    end

    context 'Unauthorized user' do
      it 'set new vote down' do
        expect { patch :vote_down, params: { id: votable, format: :json } }.to_not change { votable.rating }
      end

      it 'returns error response' do
        patch :vote_down, params: { id: votable, format: :json }
        expect(response.status).to eq 401
        expect(JSON.parse(response.body)['error']).to eq "You need to sign in or sign up before continuing."
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    context "User that isn't an author" do
      before { login(voter) }

      it 'assigns the requested resource to @votable' do
        delete :cancel_vote, params: { id: votable }
        expect(assigns(:votable)).to eq votable
      end

      it 'cancel vote' do
        patch :vote_up, params: { id: votable, format: :json }
        expect { delete :cancel_vote, params: { id: votable, format: :json } }.to change{ votable.rating }.from(1).to(0)
      end

      it 'returns data in json' do
        patch :cancel_vote, params: { id: votable, format: :json }
        expect(JSON.parse(response.body).keys).to eq %w(resourceName resourceId rating)
      end
    end

    context "Author of item" do
      before { login(voter) }

      it 'cancel vote' do
        patch :vote_up, params: { id: authored, format: :json }
        expect { delete :cancel_vote, params: { id: authored, format: :json } }.to_not change{ votable.rating }
      end

      it 'error response' do
        delete :cancel_vote, params: { id: authored, format: :json }
        expect(response.status).to eq 403
        expect(JSON.parse(response.body)['message']).to eq "You're an author, or not authorized"
      end
    end

    context 'Unauthorized user' do
      it 'cancel vote' do
        expect { delete :cancel_vote, params: { id: votable, format: :json } }.to_not change { votable.rating }
      end

      it 'returns error response' do
        delete :cancel_vote, params: { id: votable, format: :json }
        expect(response.status).to eq 401
        expect(JSON.parse(response.body)['error']).to eq "You need to sign in or sign up before continuing."
      end
    end
  end
end
