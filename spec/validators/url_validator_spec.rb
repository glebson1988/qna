require 'rails_helper'

describe UrlValidator, type: :validator do

  before { @validator = UrlValidator.new attributes: { url: '' } }

  context 'invalid input' do
    it 'should return false for a poorly formed URL' do
      expect(@validator.url_valid?('something.com')).to be_falsey
    end

    it 'should return false for garbage input' do
      pi = 3.14159265
      expect(@validator.url_valid?(pi)).to be_falsey
    end

    it 'should return false for URLs without an HTTP protocol' do
      expect(@validator.url_valid?('ftp://secret-file-stash.net')).to be_falsey
    end
  end

  context 'valid input' do
    it 'should return true for a correctly formed HTTP URL' do
      expect(@validator.url_valid?('http://nooooooooooooooo.com')).to be
    end

    it 'should return true for a correctly formed HTTPS URL' do
      expect(@validator.url_valid?('https://google.com')).to be
    end
  end
end
