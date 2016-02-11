def ensure_lead(data, user)
  begin 
    #return unless data[:email] 
    lead = Lead.find_by(email: data[:email])
    return if lead
    full_name = data[:contact_person] || 'unknown unknown'
    last_name, first_name = full_name.split(' ', 2).reverse

    first_name = 'unknown' if first_name.blank?
    last_name = 'unknown' if last_name.blank?

    company_name = data[:company_name]
    company_name = company_name[0..63] if company_name

    homepage = data[:homepage]
    homepage = homepage[0..127] if homepage
    lead = Lead.create email: data[:email], company: company_name, first_name: first_name, last_name: last_name, title: data[:position], phone: data[:phone], mobile: data[:mobile], blog: homepage

    lead.status = 'new'
    lead.source = 'other'

    lead.addresses.create address_type: 'Business', city: data[:city], street1: data[:street], zipcode: data[:zip], country: 'DE'

    comment = "#{data[:note1]}\r\n#{data[:note2]}\r\nEmail geschickt: #{data[:info_email_sent_at]}\r\nAccount eingerichtet: #{data[:account_got_at]}"

    unless data[:test_account_password].blank?
      comment += "\r\nRisotto Password: #{data[:test_account_password]}"
    end

    lead.comments.create user: user, comment: comment

    unless lead.valid?
      p lead.errors
    end

    unless lead.comments.last.valid?
      p lead.comments.last.errors
    end

    unless lead.addresses.last.valid?
      p lead.addresses.last.erros
    end


    lead.save!
  rescue StandardError => e
    p data
  end
  nil
end



csv.each { |r| ensure_lead(r, u) }; nil
