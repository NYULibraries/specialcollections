# to fix CSRF vulnerability: https://github.com/omniauth/omniauth/wiki/Resolving-CVE-2015-9284
OmniAuth.config.allowed_request_methods = [:post]
