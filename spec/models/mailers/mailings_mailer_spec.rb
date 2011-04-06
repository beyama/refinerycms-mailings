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
        :subject   => 'New version of refinerycms mailings released',
        :template  => 'default',
        :body      => 'Hi, a new version of...',
        :html_body => '<h1>Hi, a new version of...</h1>'
      }
      @mailing = Mailing.create!(@mail_attributes)
      @recipient = @mailing.recipients.create!(:to => "to@example.org")
      
      MailingTemplate.create!(:slug => 'default.text', :body => '{{mailing.body}}')
      MailingTemplate.create!(:slug => 'default.html', :body => '{{mailing.html_body}}')
    end
    
    let(:mail) { MailingsMailer.send_mail(@mailing, @recipient) }

    it "renders the headers" do
      mail.subject.should eq(@mail_attributes[:subject])
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match(@mail_attributes[:body])
    end
  end

end
