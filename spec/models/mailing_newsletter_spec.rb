require 'spec_helper'

describe MailingNewsletter do

  def reset_newsletter(options = {})
    @valid_attributes = {
      :name => "Programming"
    }
    @newsletter.destroy! if @newsletter
    @newsletter = MailingNewsletter.create!(@valid_attributes.update(options))
  end

  before(:each) do
    reset_newsletter
  end

  context "validations" do
    
    it "rejects empty name" do
      MailingNewsletter.new(@valid_attributes.merge(:name => "")).should_not be_valid
    end

    it "rejects non unique name" do
      MailingNewsletter.new(@valid_attributes).should_not be_valid
    end
    
  end
  
  context "frontend scope" do
    
    it "should only return newsletter with frontend is true" do
      @public_newsletter = MailingNewsletter.create!(:name => 'News', :public => true)
      MailingNewsletter.all.should be_include @newsletter
      MailingNewsletter.all.should be_include @public_newsletter
      
      MailingNewsletter.frontend.all.should_not be_include @newsletter
      MailingNewsletter.frontend.all.should be_include @public_newsletter
    end
    
  end

end