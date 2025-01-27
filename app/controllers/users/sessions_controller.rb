class Users::SessionsController < Devise::SessionsController
  protect_from_forgery except: [:create]

  mattr_accessor :first_factor, default: [], instance_writer: false, instance_reader: false

  # Any changes made here should also be made to the Users::SamlSessionsController.
  def create
    super do |user|
      if user.deleted?
        sign_out user
        flash[:notice] = nil
        flash[:danger] = 'Invalid Email or password.'
        render :new
        return
      end

      if user.community_user&.deleted?
        sign_out user
        flash[:notice] = nil
        flash[:danger] = 'Your profile on this community has been deleted.'
        render :new
        return
      end

      if user.present? && user.sso_profile.present?
        sign_out user
        flash[:notice] = nil
        flash[:danger] = 'Please sign in using the Single Sign-On service of your institution.'
        redirect_to new_saml_user_session_path
        return
      end

      if user.present? && user.enabled_2fa
        sign_out user
        case user.two_factor_method
        when 'app'
          id = user.id
          @@first_factor << id
          redirect_to login_verify_2fa_path(uid: id)
          return
        when 'email'
          TwoFactorMailer.with(user: user, host: request.hostname).login_email.deliver_now
          flash[:notice] = nil
          flash[:info] = 'Please check your email inbox for a link to sign in.'
          redirect_to root_path
          return
        end
      end
    end
  end

  def verify_2fa; end

  def verify_code
    target_user = User.find params[:uid]

    if target_user.two_factor_token.blank?
      flash[:danger] = 'I have no idea how you got here, but something is very wrong.'
      redirect_to(root_path) && return
    end

    totp = ROTP::TOTP.new(target_user.two_factor_token)
    if totp.verify(params[:code], drift_ahead: 15, drift_behind: 15)
      if @@first_factor.include? params[:uid].to_i
        AuditLog.user_history(event_type: 'two_factor_success', related: target_user)
        @@first_factor.delete params[:uid].to_i
        flash[:info] = 'Signed in successfully.'
        sign_in_and_redirect User.find(params[:uid])
      else
        AuditLog.user_history(event_type: 'two_factor_fail', related: target_user, comment: 'first factor not present')
        flash[:danger] = "You haven't entered your password yet."
        if devise_sign_in_enabled?
          redirect_to new_session_path(target_user)
        else
          redirect_to new_saml_user_session_path(target_user)
        end
      end
    else
      AuditLog.user_history(event_type: 'two_factor_fail', related: target_user, comment: 'wrong code')
      flash[:danger] = "That's not the right code."
      redirect_to login_verify_2fa_path(uid: params[:uid])
    end
  end
end
