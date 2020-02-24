class EmailAddress < ApplicationRecord
  has_many :email_verifications
  before_create :set_verification_status

  MAX_LENGTH_RECIPIENT = 64
  MAX_DOMAIN_NAME_LENGTH = 253

  ALPHA_NUMERIC_CHARACTERS = "a-zA-Z0-9"
  SPECIAL_RECIPIENT_CHARACTERS = "!#$%&*+/=?^_/{|."

  # an email has four parts: the recipient name, the '@' symbol,
  # the domain name, and the top level domain
  # this method checks and validates all four parts
  def check_status

    return "invalid" unless address.count('@') == 1

    if recipient_name_valid? and domain_levels_valid?
      "valid"
    else
      "invalid"
    end
  end

  private

  # checks for correct recipient name length, legal characters, and special characters rules
  # ex: some@thing.com: the "some" would be the recipient name
  def recipient_name_valid?
    recipient_name = address.split('@')[0]

    pattern = "^[#{ALPHA_NUMERIC_CHARACTERS}#{SPECIAL_RECIPIENT_CHARACTERS}]*[-]*$"
    check_recipient_name_length?(recipient_name) and are_characters_legal?(pattern, recipient_name) and check_special_character_rules? recipient_name
  end

  def check_recipient_name_length?(recipient_name)
    return false if recipient_name.length> MAX_LENGTH_RECIPIENT
    return false if recipient_name.length < 1
    true
  end

  def check_special_character_rules?(recipient_name)

    # a special character cannot be the first or last character in a recipient name
    return false if SPECIAL_RECIPIENT_CHARACTERS.include? recipient_name[0] or
        SPECIAL_RECIPIENT_CHARACTERS.include? recipient_name[recipient_name.length-1]


    # special characters cannot occur contiguously in a recipient name
    current_index = 1
    prev_index = 0
    until current_index >= recipient_name.length-1 do
      return false if SPECIAL_RECIPIENT_CHARACTERS.include? recipient_name[current_index] and
          SPECIAL_RECIPIENT_CHARACTERS.include? recipient_name[prev_index]
      current_index += 1
      prev_index += 1
    end

    true
  end

  # checks for a valid domain name and top-level domain
  # ex some@thing.com - "thing" would be the domain name and "com" would be the top domain
  def domain_levels_valid?
    domain_and_top_domain = address.split('@')[1]

    return false unless !domain_and_top_domain.nil? and domain_and_top_domain.include? '.'

    # the start index of the top domain starting in the first index would indicate there is no domain name, so the address
    # would not be valid
    top_domain_start_index = domain_and_top_domain.rindex '.'
    return false if top_domain_start_index == 0

    domain_name = domain_and_top_domain[0..top_domain_start_index-1]
    top_domain = domain_and_top_domain[top_domain_start_index+1..-1]

    domain_name_valid?(domain_name) and top_domain_valid?(top_domain)
  end

  def domain_name_valid?(domain_name)
    return false if domain_name.length > MAX_DOMAIN_NAME_LENGTH or domain_name.length < 1

    pattern = "^[#{ALPHA_NUMERIC_CHARACTERS}.-]*$"
    return false unless are_characters_legal?(pattern, domain_name)

    # domains can only have 1 '.' and 1 '-'
    return false if domain_name.count('.') > 1 or domain_name.count('-') > 1

    true
  end

  # the longest top level domain is 24 characters long
  def top_domain_valid?(top_domain)
    top_domain.length >= 2 and top_domain.length <= 24
  end

  def are_characters_legal?(pattern, text)
    /#{pattern}/.match? text
  end

  def set_verification_status
    self.status = check_status
  end
end
