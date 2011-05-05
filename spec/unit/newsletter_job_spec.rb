require 'spec_helper'

describe Refinery::Mailings::NewsletterJob do
  
  before(:each) do
    @mailing_template = MailingTemplate.create!({ :slug => "default.html", :body => "{{ mailing.body }}" })
    
    @newsletter = MailingNewsletter.create! :name => 'news'
    
    time = Time.now
    
    @subscribers = []
    3.times do |i|
      subscriber = MailingSubscriber.create! :email => "test#{i}@example.org"
      MailingNewsletterSubscriber.create! \
        :newsletter => @newsletter, 
        :subscriber => subscriber,
        :verified_at => time
    end
    
    @mailing = Mailing.new \
      :from      => 'noreply@example.org',
      :subject   => 'New version of refinerycms mailings released',
      :template  => 'default',
      :body      => 'Hi, a new version of...',
      :html_body => '<h1>Hi, a new version of...</h1>'
    @mailing.newsletters << @newsletter
    @mailing.save!
  end
  
  let(:job) { Refinery::Mailings::NewsletterJob.new(@mailing.id, {}) }
  
  it "should find mailing by id" do
    job.mailing.should == @mailing
  end
  
  it "should send newsletter to each subscriber" do
    ActionMailer::Base.deliveries.clear
    
    job.perform
    
    ActionMailer::Base.deliveries.size.should == 3
    
    addresses = @mailing.subscribers.map(&:email)
    
    ActionMailer::Base.deliveries.each do |mail|
      addresses.should include(mail.to.first)
      mail.from.should eq([@mailing.from])
      mail.subject.should eq(@mailing.subject)
      
      mail.body.encoded.should match(@mailing.body)
    end
    
    @mailing.subscribers.each do |subscriber|
      subscriber.mailings.should include(@mailing)
    end
  end
  
end