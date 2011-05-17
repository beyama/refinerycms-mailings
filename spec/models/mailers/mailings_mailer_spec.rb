require "spec_helper"
require "guid"

describe MailingsMailer do
  def create_mailing
    @mail_attributes = {
      :from      => 'noreply@example.org',
      :subject   => 'New version of refinerycms mailings released',
      :template  => 'default',
      :body      => 'Hi, a new version of...',
      :html_body => '<h1>Hi, a new version of...</h1>'
    }
    @mailing = Mailing.create!(@mail_attributes)
      
    MailingTemplate.create!(:slug => 'footer.text', :body => '{{unsubscribe_url}}')
    MailingTemplate.create!(:slug => 'content.text', :body => '{{mailing.body}}')
      
    MailingTemplate.create!(:slug => 'default.text', :body => "{% include 'content.text' %}\n{% include 'footer.text' %}")
    MailingTemplate.create!(:slug => 'default.html', :body => '{{mailing.html_body}}')
  end
  
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
      create_mailing
    end
    
    let(:mail) { MailingsMailer.send_mail(@mailing, :to => "to@example.org") }

    it "renders the headers" do
      mail.subject.should eq(@mailing.subject)
      mail.to.should eq(["to@example.org"])
      mail.from.should eq([@mailing.from])
    end

    it "renders the body" do
      body = mail.body.encoded
      body.should match(@mail_attributes[:body])
      body.should match("http://127.0.0.1:3000/newsletter")
    end
    
  end
  
  describe "Mime-Type rendering" do
    
    before do
      create_mailing
    end
    
    it "should render plain and html text" do
      mail = MailingsMailer.send_mail(@mailing, :to => "to@example.org")
      
      mail.should be_multipart
      mail.parts[0].content_type.should match('text/plain')
      mail.parts[1].content_type.should match('text/html')
    end
    
    it "should only render plain text if HTML body empty" do
      @mailing.html_body = ''
      mail = MailingsMailer.send_mail(@mailing, :to => "to@example.org")
      
      mail.should_not be_multipart
      mail.body.should match(@mail_attributes[:body])
    end
    
    it "should only render html if plain text body empty" do
      @mailing.body = ''
      mail = MailingsMailer.send_mail(@mailing, :to => "to@example.org")
      
      mail.should_not be_multipart
      mail.body.should match(@mail_attributes[:html_body])
    end
    
    it "should render nothing if html and plain text body empty" do
      @mailing.body = @mailing.html_body = ''
      mail = MailingsMailer.send_mail(@mailing, :to => "to@example.org")
      
      mail.should_not be_multipart
      mail.parts.should be_empty
    end
    
  end

end
