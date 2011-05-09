class CreateMailingStructure < ActiveRecord::Migration

  def self.up
    create_table ::Mailing.table_name do |t|
      t.string   :from, :null => false
      t.string   :subject, :null => false
      t.text     :body
      t.text     :html_body
      t.string   :template
      t.integer  :created_by_id
      t.integer  :updated_by_id
      t.datetime :sent_at
      t.datetime :finished_at
      t.integer  :job_id
      
      t.timestamps 
    end
    
    add_index ::Mailing.table_name, :subject

    create_table ::MailingNewsletter.table_name do |t|
      t.string  :name, :null => false
      t.text    :description
      t.boolean :public
      t.integer :position
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
    
    add_index ::MailingNewsletter.table_name, :name, :unique => true
    
    create_table ::MailingTemplate.table_name do |t|
      t.string  :slug, :null => false
      t.text    :body
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
    
    add_index ::MailingTemplate.table_name, :slug, :unique => true
    
    create_table ::MailingSubscriber.table_name do |t|
      t.string :email, :null => false
      
      t.timestamps
    end
    
    add_index ::MailingSubscriber.table_name, :email, :unique => true
    
    create_table ::MailingNewsletterSubscriber.table_name do |t|
      t.references :newsletter
      t.references :subscriber
      t.string     :token
      t.datetime   :verified_at
      t.datetime   :invite_sended_at

      t.timestamps
    end
    
    create_table :mailing_newsletters_mailings, :id => false do |t|
      t.integer :mailing_newsletter_id
      t.integer :mailing_id
    end
    
    create_table :mailing_subscribers_mailings, :id => false do |t|
      t.integer :mailing_subscriber_id
      t.integer :mailing_id
    end
    
    load(Rails.root.join('db', 'seeds', 'mailings.rb'))
  end

  def self.down
    UserPlugin.destroy_all({:name => "mailings"})

    Page.delete_all({:link_url => "/newsletter"})

    drop_table ::Mailing.table_name
    drop_table ::MailingNewsletter.table_name
    drop_table ::MailingTemplate.table_name
    drop_table ::MailingSubscriber.table_name
    drop_table ::MailingNewsletterSubscriber.table_name
    drop_table :mailing_newsletters_mailings
    drop_table :mailing_subscribers_mailings
  end

end
