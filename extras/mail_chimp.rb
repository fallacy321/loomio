class MailChimp
  def self.export_newsletter_users
    gibbon = Gibbon::API.new
    batch = User.newsletter_recipients.map { |user| { email: { email: user.email }, merge_vars: { NAME: user.name } } }
    gibbon.lists.batch_subscribe id: ENV['MAILCHIMP_LIST_ID'], batch: batch
  end
  
  def self.list_users
    gibbon = Gibbon::API.new
    gibbon.lists.members id: ENV['MAILCHIMP_LIST_ID']
  end
  
end
