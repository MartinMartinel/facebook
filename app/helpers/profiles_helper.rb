module ProfilesHelper
  def formatted_birthday birthday
    return "No birthday provided" if birthday.blank?

    birthday.strftime('%B %-d')
  end

  def country_name country_code
    return "No country specified" if country_code.blank?

    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  def value_or_none value
    return "None specified" if value.blank?

    value
  end

  def bool_to_yes_no bool
    return "Yes" if bool
    "No"
  end

  def get_education_options
    [["Some High School", "Some High School"],
     ["High School Graduate", "High School Graduate"],
     ["Some College", "Some College"],
     ["Bachelor's Degree", "Bachelor's Degree"],
     ["Post Graduate Degree", "Post Graduate Degree"]]
  end

  def get_profession_options
    [["Aspiring Developer", "Aspiring Developer"],
     ["Practicing Developer", "Practicing Developer"],
     ["Computer Related, Not Developer", "Computer Related, Not Developer"],
     ["Science Related, Not Computer Related", "Science Related, Not Computer Related"],
     ["Not Science Related, I Have a Life", "Not Science Related, I Have a Life"]]
  end
end
