require "rails_helper"

describe EmailAddress, :type => :model do
  describe "check_status" do

    let(:valid_address) {Faker::Internet.email}
    let(:invalid_address) {'not_an_email'}

    context "when email address is valid" do
      subject(:email_address) {EmailAddress.new(address: valid_address)}

      it "returns valid" do
        puts email_address.address
        expect(email_address.check_status).to eq('valid')
      end
    end

    context "when email address is invalid" do
      subject(:email_address) {EmailAddress.new(address: invalid_address)}

      it "returns false" do
        expect(email_address.check_status).to eq('invalid')
      end
    end
  end

  describe 'recipient_name_valid?' do
    let(:long_recipient_name) {"thisisaverylongrecipientnamewowwhowouldmakesuchalongnamethisisntreadable@gmail.com"}
    let(:illegal_characters) {"this'isn't(legal)@notlegal.com"}
    let(:illegal_special_character_placement) {"!important!@important.com"}

    context "when a recipient name is too long" do
      subject(:email_address) {EmailAddress.new(address: long_recipient_name)}

      it "returns invalid" do
        expect(email_address.check_status).to eq('invalid')
      end
    end

    context "when a recipient name has an illegal character" do
      subject(:email_address) {EmailAddress.new(address: illegal_characters)}

      it "returns invalid" do
        expect(email_address.check_status).to eq('invalid')
      end
    end

    context "when a recipient name has an illegal special character placement" do
      subject(:email_address) {EmailAddress.new(address: illegal_special_character_placement)}

      it "returns invalid" do
        expect(email_address.check_status).to eq('invalid')
      end
    end
  end

  describe "domain_levels_valid?" do
    let(:long_domain_name) {"thisisaverylongrecipientnamewowwhowouldmakesuchalongnamethisisntreadable" * 10 + "@gmail.com"}
    let(:illegal_characters) {"this!isntlegal$@notlegal.com"}
    let(:illegal_special_character_count) {"thisisfine@this-isnt.fine.come-on.com"}
    let(:short_tld) {"short@short.c"}

    context "when a domain name is too long" do
      subject(:email_address) {EmailAddress.new(address: long_domain_name)}

      it "returns invalid" do
        expect(email_address.check_status).to eq('invalid')
      end
    end

    context "when a domain name has an illegal character" do
      subject(:email_address) {EmailAddress.new(address: illegal_characters)}

      it "returns invalid" do
        expect(email_address.check_status).to eq('invalid')
      end
    end

    context "when a domain name has too many '.' or '-'" do
      subject(:email_address) {EmailAddress.new(address: illegal_special_character_count)}

      it "returns invalid" do
        expect(email_address.check_status).to eq('invalid')
      end
    end

    context "when a top level domain is too short" do
      subject(:email_address) {EmailAddress.new(address: short_tld)}

      it "returns invalid" do
        expect(email_address.check_status).to eq('invalid')
      end
    end
  end
end
