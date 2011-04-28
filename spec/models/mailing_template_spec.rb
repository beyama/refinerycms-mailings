require 'spec_helper'

describe MailingTemplate do

  def reset_mailing_template(options = {})
    @valid_attributes = { :slug => "default.html" }

    @mailing_template.destroy! if @mailing_template
    @mailing_template = MailingTemplate.create!(@valid_attributes.update(options))
  end

  before(:each) do
    reset_mailing_template
  end

  context "validations" do
    
    it "rejects empty slug" do
      MailingTemplate.new(@valid_attributes.merge(:slug => "")).should_not be_valid
    end

    it "rejects non unique slug" do
      MailingTemplate.new(@valid_attributes).should_not be_valid
    end
    
  end
  
  context "transient getter" do
    
    it "extname should return slug ending without a dot" do
      @mailing_template.extname.should == 'html'
      @mailing_template.slug = "default.text"
      @mailing_template.extname.should == 'text'
    end
    
  end

end