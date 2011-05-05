require "spec_helper"
require "guid"

describe MailingsMailer do
  describe "send confirmation mail" do
    
    before do
      @token = Guid.new.to_s
      @newsletter = MailingNewsletter.create! :name => 'news'
      @subscriber = MailingSubscriber.create! :email => 'test@example.org'
      @newletter_subscriber = MailingNewsletterSubscriber.create! \
        :newsletter => @newsletter, 
        :subscriber => @subscriber,
        :token => @token
        
      RefinerySetting.set(:mailings_confirm_from, "from@example.com")
    end
    
    let(:mail) { MailingsMailer.confirm(@subscriber, @token) }
    
    it "renders the headers" do
      mail.to.should eq(['test@example.org'])
      mail.from.should eq(["from@example.com"])
    end
    
    it "should contains the approve token" do
      mail.body.encoded.should match(/#{@token}/)
    end
    
  end
  
  describe "send mailing to newsletter recipient" do
    
    before do
      @mail_attributes = {
        :from      => 'noreply@example.org',
        :subject   => 'New version of refinerycms mailings released',
        :template  => 'default',
        :body      => 'Hi, a new version of...',
        :html_body => '<h1>Hi, a new version of...</h1>'
      }
      @mailing = Mailing.create!(@mail_attributes)
      
      MailingTemplate.create!(:slug => 'content.text', :body => '{{mailing.body}}')
      MailingTemplate.create!(:slug => 'default.text', :body => '%{include "content.text"}%')
      MailingTemplate.create!(:slug => 'default.html', :body => '{{mailing.html_body}}')
    end
    
    let(:mail) { MailingsMailer.send_mail(@mailing, :to => "to@example.org") }

    it "renders the headers" do
      mail.subject.should eq(@mailing.subject)
      mail.to.should eq(["to@example.org"])
      mail.from.should eq([@mailing.from])
    end

    it "renders the body" do
      mail.body.encoded.should match(@mail_attributes[:body])
    end
  end

end
