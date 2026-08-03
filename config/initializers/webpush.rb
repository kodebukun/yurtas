vapid = Rails.application.credentials.vapid
Rails.application.config.x.vapid_public_key  = vapid[:public_key]
Rails.application.config.x.vapid_private_key = vapid[:private_key]
Rails.application.config.x.vapid_subject     = vapid[:subject]
