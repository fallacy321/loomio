namespace :loomio do
  task :close_lapsed_motions => :environment do
    MotionService.close_all_lapsed_motions
  end
  task :generate_error => :environment do
    raise "Testing error reporting for rake tasks, chill, no action requied if you see this"
  end
  task :mailchimp_export => :environement do
    MailChimp.export_newsletter_users
  end
end
