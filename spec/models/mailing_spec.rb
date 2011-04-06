require 'spec_helper'

describe Mailing do

  def reset_mailing(options = {})
    @valid_attributes = {
      :subject => "New version of refinerycms mailings released"
    }

    @mailing.destroy! if @mailing
    @mailing = Mailing.create!(@valid_attributes.update(options))
  end

  before(:each) do
    reset_mailing
  end

  context "validations" do
    
    it "rejects empty subject" do
      Mailing.new(@valid_attributes.merge(:subject => "")).should_not be_valid
    end
    
  end

end