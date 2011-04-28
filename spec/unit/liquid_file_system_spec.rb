require 'spec_helper'

describe Refinery::Mailings::LiquidFileSystem do

  def reset_mailing_template(options = {})
    @attributes = { :slug => "default.html", :body => "body text" }

    @mailing_template.destroy! if @mailing_template
    @mailing_template = MailingTemplate.create!(@attributes.update(options))
  end
  
  before(:each) do
    reset_mailing_template
  end
  
  let(:fs) { Refinery::Mailings::LiquidFileSystem.new }
  
  it "should return body text on existing template" do
    fs.read_template_file(@attributes[:slug]).should match(@attributes[:body])
  end
  
  it "should raise exception if template not exist" do
    lambda do
      fs.read_template_file('does_not_exist.html') 
    end.should raise_error(Liquid::FileSystemError)
  end
  
  
end