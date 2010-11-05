# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pointmap2_session',
  :secret      => '3e3487ce59e62cf6708254f20b9bf802b3c0f30b558eacbd1b853ddd6541add070b994d52c8f226850e3734413668481adb5634630f7d978a190f71ec022fd67'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
