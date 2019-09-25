class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy
  before_action :find_attachment

  def destroy
    @attachment.purge if current_user&.author_of?(@attachment.record)
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find_by(record_id: params[:id])
  end
end
