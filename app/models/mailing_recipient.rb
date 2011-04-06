class MailingRecipient < ActiveRecord::Base
  belongs_to :mailing
  belongs_to :receivable, :polymorphic => true
  
  def to_liquid
    { 
      'to'         => self.to,
      'created_at' => self.created_at,
      'updated_at' => self.updated_at
    }
  end
end
