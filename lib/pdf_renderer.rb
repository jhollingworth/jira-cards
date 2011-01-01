require 'pdfkit'

class PdfRenderer

  def initialize(stylesheet = "template.css")
    @stylesheet = stylesheet
  end

  def render(html, output_file_path)
    PDFKit.configure do |config|
      config.wkhtmltopdf = 'C:\Program Files\wkhtmltopdf\wkhtmltopdf.exe'
    end

    kit = PDFKit.new(html, :page_size => 'Letter')
    kit.stylesheets << @stylesheet
    kit.to_file output_file_path
  end
end