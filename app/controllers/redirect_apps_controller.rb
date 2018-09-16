class RedirectAppsController < ApplicationController
  layout 'application_redirect'

  def aboutApps
    render 'redirect_apps/about_us'
  end

  def termsApps
    render 'redirect_apps/terms_conditions'
  end

  def privacyApps
    render 'redirect_apps/privacy_policy'
  end
end
