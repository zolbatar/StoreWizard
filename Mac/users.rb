def create_admin_user
  password =  "<$PASS$>"
  email =  "<$USER$>"
  attributes = {
    :password => password,
    :password_confirmation => password,
    :email => email,
    :login => email
  }

  load 'user.rb'

  if User.find_by_email(email)
    say "\nWARNING: There is already a user with the email: #{email}, so no account changes were made.  If you wish to create an additional admin user, please run rake db:admin:create again with a different email.\n\n"
  else
    admin = User.create(attributes)
    # create an admin role and and assign the admin user to that role
    role = Role.find_or_create_by_name "admin"
    admin.roles << role
    admin.save
  end
end

create_admin_user if User.where("roles.name" => 'admin').includes(:roles).empty?