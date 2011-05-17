require 'spec_helper'

describe Mailing do

  def reset_mailing(options = {})
    @valid_attributes = {
      :from    => 'noreply@example.org',
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
  
  context "HTML Body" do
    
    it "should make html body urls absoulute on save" do
      @mailing.html_body = '<a href="/home">Home</a><img src="/images/logo.png" />'
      @mailing.save
      @mailing.html_body.should == '<a href="http://example.org/home">Home</a><img src="http://example.org/images/logo.png">'
    end
    
  end

end