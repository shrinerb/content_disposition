RSpec.describe ContentDisposition do
  describe ".format" do
    it "returns Content-Disposition string" do
      value = ContentDisposition.format(disposition: "attachment", filename: "racecar.jpg")

      expect(value).to eq %(attachment; filename="racecar.jpg"; filename*=UTF-8''racecar.jpg)
    end
  end

  describe ".call" do
    it "aliases .format" do
      value = ContentDisposition.(disposition: "attachment", filename: "racecar.jpg")

      expect(value).to eq %(attachment; filename="racecar.jpg"; filename*=UTF-8''racecar.jpg)
    end
  end

  describe ".attachment" do
    it "accepts a filename" do
      value = ContentDisposition.attachment("racecar.jpg")

      expect(value).to eq %(attachment; filename="racecar.jpg"; filename*=UTF-8''racecar.jpg)
    end

    it "works without a filename" do
      value = ContentDisposition.attachment

      expect(value).to eq %(attachment)
    end
  end

  describe ".inline" do
    it "accepts a filename" do
      value = ContentDisposition.inline("racecar.jpg")

      expect(value).to eq %(inline; filename="racecar.jpg"; filename*=UTF-8''racecar.jpg)
    end

    it "works without a filename" do
      value = ContentDisposition.inline

      expect(value).to eq %(inline)
    end
  end

  describe "#initialize" do
    it "fails with unknown disposition" do
      expect {
        ContentDisposition.new(disposition: "unknown", filename: nil)
      }.to raise_error(ArgumentError)
    end
  end

  describe "#to_s" do
    context "with filename" do
      it "returns disposition with filename" do
        content_disposition = ContentDisposition.new(
          disposition: :inline,
          filename:    "racecar.jpg",
        )

        expect(content_disposition.to_s).to eq %(inline; filename="racecar.jpg"; filename*=UTF-8''racecar.jpg)
      end
    end

    context "without filename" do
      it "returns disposition" do
        content_disposition = ContentDisposition.new(
          disposition: :inline,
          filename:    nil,
        )

        expect(content_disposition.to_s).to eq %(inline)
      end
    end
  end

  describe "#ascii_filename" do
    it "encodes an ascii filename" do
      content_disposition = ContentDisposition.new(
        disposition: :inline,
        filename:    "racecar.jpg",
      )

      expect(content_disposition.ascii_filename).to eq %(filename="racecar.jpg")
    end

    it "encodes a Latin filename with accented characters" do
      content_disposition = ContentDisposition.new(
        disposition: :inline,
        filename:    "råcëçâr.jpg",
      )

      expect(content_disposition.ascii_filename).to eq %(filename="r%3Fc%3F%3F%3Fr.jpg")
    end

    it "encodes a non-Latin filename" do
      content_disposition = ContentDisposition.new(
        disposition: :inline,
        filename:    "автомобиль.jpg",
      )

      expect(content_disposition.ascii_filename).to eq %(filename="%3F%3F%3F%3F%3F%3F%3F%3F%3F%3F.jpg")
    end

    it "uses :to_ascii" do
      content_disposition = ContentDisposition.new(
        disposition: :inline,
        filename:    "råcëçâr.jpg",
        to_ascii:    -> (string) { string.encode("US-ASCII", undef: :replace, replace: "_") }
      )

      expect(content_disposition.ascii_filename).to eq %(filename="r_c___r.jpg")
    end
  end

  describe "#utf8_filename" do
    it "encodes an ascii filename" do
      content_disposition = ContentDisposition.new(
        disposition: :inline,
        filename:    "racecar.jpg",
      )

      expect(content_disposition.utf8_filename).to eq %(filename*=UTF-8''racecar.jpg)
    end

    it "encodes a Latin filename with accented characters" do
      content_disposition = ContentDisposition.new(
        disposition: :inline,
        filename:    "råcëçâr.jpg",
      )

      expect(content_disposition.utf8_filename).to eq %(filename*=UTF-8''r%C3%A5c%C3%AB%C3%A7%C3%A2r.jpg)
    end

    it "encodes a non-Latin filename" do
      content_disposition = ContentDisposition.new(
        disposition: :inline,
        filename:    "автомобиль.jpg",
      )

      expect(content_disposition.utf8_filename).to eq %(filename*=UTF-8''%D0%B0%D0%B2%D1%82%D0%BE%D0%BC%D0%BE%D0%B1%D0%B8%D0%BB%D1%8C.jpg)
    end
  end
end
