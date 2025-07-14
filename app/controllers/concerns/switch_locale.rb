module SwitchLocale
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale
  end

  private

  def switch_locale(&action)
    locale = extract_locale_from_accept_language_header || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def extract_locale_from_accept_language_header
    return nil unless request && request.env["HTTP_ACCEPT_LANGUAGE"]
    accept_language_header = request.env["HTTP_ACCEPT_LANGUAGE"]
    return nil if accept_language_header.blank?

    # Parse Accept-Language header and sort by priority
    parsed_locales = accept_language_header.split(",").map do |language|
      language_code, quality = language.strip.split(";q=")
      [ language_code, (quality || "1").to_f ]
    end.sort_by { |_, quality| -quality }.map(&:first)

    available_locales = I18n.available_locales.map(&:to_s)

    # Exact match
    parsed_locales.each do |language_code|
      return language_code if available_locales.include?(language_code)
    end

    # Prefix match (e.g. en-US matches en)
    parsed_locales.each do |language_code|
      language_prefix = language_code.split("-").first
      return language_prefix if available_locales.include?(language_prefix)
    end

    # No match
    nil
  end
end
