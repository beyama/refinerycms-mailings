require 'guid'

Given /^I have no newsletters$/ do
  MailingNewsletter.delete_all
end

Given /^I (only )?have (public )?newsletters titled "?([^\"]*)"?$/ do |only, public, titles|
  MailingNewsletter.delete_all if only
  titles.split(', ').each do |title|
    MailingNewsletter.create(:name => title, :public => !!public)
  end
end

Then /^I should have ([0-9]+) newsletters?$/ do |count|
  MailingNewsletter.count.should == count.to_i
end

Given /A simple newsletter page exists/ do
  page = Page.create(
    :title => "Newsletter", :link_url => "/newsletter", :deletable => false,
    :position => ((Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)+1),
    :menu_match => "^/newsletter?(\/|\/.+?|)$"
  )
end

Given /^I am a subscriber of "?([^\"]*)"? with email address "?([^\"]*)"?$/ do |names,email|
  @subscriber = MailingSubscriber.new(:email => email)
  names.split(', ').each do |name|
    newsletter = MailingNewsletter.find_by_name(name)
    @subscriber.subscriptions.build(:newsletter_id => newsletter.id, :token => Guid.new.to_s)
  end
  @subscriber.save!
end

When /^(?:|I )check newsletters titled "?([^\"]*)"?$/ do |newsletters|
  newsletters.split(', ').each do |name|
    newsletter = MailingNewsletter.find_by_name(name)
    check("mailing_newsletter_#{newsletter.id}")
  end
end

When /^I should have a subscription confirm mail$/ do
  ActionMailer::Base.deliveries.should_not be_empty
  ActionMailer::Base.deliveries.last.subject.should match(/Confirm/)
end

When /^I should have (\d+) mailing_newsletter_subscribers?$/ do |count|
  MailingNewsletterSubscriber.count.should == count.to_i
end

