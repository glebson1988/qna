require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:resource_with_attachment) { create(:answer, :with_attachment, user: author) }

  describe 'DELETE #destroy' do

    context 'Authorized user is author' do
      before { login(author) }

      it 'deletes attachment' do
        expect { delete :destroy, params: { id: resource_with_attachment }, format: :js}.to change(resource_with_attachment.files, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: resource_with_attachment }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authorized user is not an author' do
      before { login(user) }

      it 'tries do delete attachment' do
        expect { delete :destroy, params: { id: resource_with_attachment }, format: :js}.to_not change(resource_with_attachment.files, :count)
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete attachment' do
        expect { delete :destroy, params: { id: resource_with_attachment }, format: :js}.to_not change(resource_with_attachment.files, :count)
      end
    end
  end
end
