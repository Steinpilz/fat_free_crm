every 10.seconds, :dropbox_run do
  require "fat_free_crm/mail_processor/dropbox"
  FatFreeCRM::MailProcessor::Dropbox.new.run(dry_run = false)
end