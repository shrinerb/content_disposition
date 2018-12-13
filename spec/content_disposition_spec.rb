require 'i18n'

RSpec.describe ContentDisposition do
  describe "with default to_ascii" do
    it "encodes an ascii filename" do
      disposition = ContentDisposition.new(disposition: :inline, filename: "racecar.jpg")

      expect(disposition.ascii_filename).to eq %(filename="racecar.jpg")
      expect(disposition.utf8_filename).to eq "filename*=UTF-8''racecar.jpg"
      expect(disposition.to_s).to eq "inline; #{disposition.ascii_filename}; #{disposition.utf8_filename}"
    end

    it "encodes a Latin filename with accented characters" do
      disposition = ContentDisposition.new(disposition: :inline, filename: "råcëçâr.jpg")

      expect(disposition.ascii_filename).to eq %(filename="r%3Fc%3F%3F%3Fr.jpg")
      expect(disposition.utf8_filename).to eq "filename*=UTF-8''r%C3%A5c%C3%AB%C3%A7%C3%A2r.jpg"
      expect(disposition.to_s).to eq "inline; #{disposition.ascii_filename}; #{disposition.utf8_filename}"
    end

    it "encodes a non-Latin filename" do
      disposition = ContentDisposition.new(disposition: :inline, filename: "автомобиль.jpg")

      expect(disposition.ascii_filename).to eq %(filename="%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F.jpg")
      expect(disposition.utf8_filename).to eq "filename*=UTF-8''%D0%B0%D0%B2%D1%82%D0%BE%D0%BC%D0%BE%D0%B1%D0%B8%D0%BB%D1%8C.jpg"
      expect(disposition.to_s).to eq "inline; #{disposition.ascii_filename}; #{disposition.utf8_filename}"
    end

    it "outputs without filename" do
      disposition = ContentDisposition.new(disposition: :inline, filename: nil)

      expect(disposition.to_s).to eq "inline"
    end
  end

  describe "using i18n.transliterate for to_ascii" do
    before do
      I18n.config.enforce_available_locales = false
    end

    let(:i18n_to_ascii) { ->(str) { I18n.transliterate(str) } }

    it "encodes an ascii filename" do
      disposition = ContentDisposition.new(disposition: :inline, filename: "racecar.jpg", to_ascii: i18n_to_ascii)

      expect(disposition.ascii_filename).to eq %(filename="racecar.jpg")
      expect(disposition.utf8_filename).to eq "filename*=UTF-8''racecar.jpg"
      expect(disposition.to_s).to eq "inline; #{disposition.ascii_filename}; #{disposition.utf8_filename}"
    end

    it "encodes a Latin filename with accented characters" do
      disposition = ContentDisposition.new(disposition: :inline, filename: "råcëçâr.jpg", to_ascii: i18n_to_ascii)

      expect(disposition.ascii_filename).to eq %(filename="racecar.jpg")
      expect(disposition.utf8_filename).to eq "filename*=UTF-8''r%C3%A5c%C3%AB%C3%A7%C3%A2r.jpg"
      expect(disposition.to_s).to eq "inline; #{disposition.ascii_filename}; #{disposition.utf8_filename}"
    end

    it "encodes a non-Latin filename" do
      disposition = ContentDisposition.new(disposition: :inline, filename: "автомобиль.jpg", to_ascii: i18n_to_ascii)

      expect(disposition.ascii_filename).to eq %(filename="%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F.jpg")
      expect(disposition.utf8_filename).to eq "filename*=UTF-8''%D0%B0%D0%B2%D1%82%D0%BE%D0%BC%D0%BE%D0%B1%D0%B8%D0%BB%D1%8C.jpg"
      expect(disposition.to_s).to eq "inline; #{disposition.ascii_filename}; #{disposition.utf8_filename}"
    end
  end


end
