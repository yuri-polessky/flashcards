class AuthenticatedConstraint
  def matches?(request)
    User.find_by_id(request.session[:user_id])
  end
end