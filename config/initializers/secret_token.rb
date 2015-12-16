if FatFreeCRM.application?
  require 'fat_free_crm/secret_token_generator'
  Hours::Application.config.secret_key_base = ENV['SECRET_KEY_BASE']
end