class AuthenticateController < ApplicationController

skip_before_action :check_logged_in

	def index
	
		if session[:nick]
    		redirect_to '/'
  		else
  		end

	end

	
	def attempt_login

		if params[:nick].present? && params[:password].present?
		found_user = User.where(:nick=> params[:nick]).first
			if found_user
				authorised_user = found_user.authenticate(params[:password])
			end
		end

 		if authorised_user
			session[:nick] = authorised_user.nick
        	redirect_to '/'   
		else
			flash[:notice] = "Invalid username/password"
			redirect_to(:action => 'index')
		end

	end

	def register

			if params[:nick].present? && params[:password].present? && params[:confirm_password].present?

				found_user = User.where(:nick=> params[:nick]).first
					if found_user

						flash[:notice] = "Nick already taken"
						redirect_to(:action=>'index') and return
					end

				if params[:password] == params[:confirm_password]
					user = User.new(:nick=>params[:nick], :password=>params[:password])
				else
					flash[:notice] = "Password and Confirm Password donot match"
					redirect_to(:action => 'index') and return
				end

				if user.save
					redirect_to '/'
				else
					flash[:notice] = "Error saving details"
					redirect_to(:action => 'index')
				end
			else
				redirect_to(:action=>'index')
		    end

	end

	def logout
		session[:nick] = nil
		redirect_to '/'
	end

end



