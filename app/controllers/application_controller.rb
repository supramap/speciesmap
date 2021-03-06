# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_path
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_path
      return false
    end
  end

  def store_location
      session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def viewable
    pointmapInstance = Pointmap.find(params[:id])
  	if pointmapInstance.user_id != current_user.id && !pointmapInstance.public
  	  flash[:notice] = "You don't have permission to view this depthmap"
  	  redirect_to depthmaps_path
  	  return false
  	end
  end

  def editable
  	if Pointmap.find(params[:id]).user_id != current_user.id
  	  flash[:notice] = "You don't have permission to edit this depthmap"
  	  redirect_to depthmap_path(params[:id])
  	  return false
  	end
  end

end
