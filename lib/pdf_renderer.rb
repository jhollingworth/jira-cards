require 'pdfkit'

class PdfRenderer

  def initialize(config)
    @stylesheet = config.template_stylesheet || File.dirname(__FILE__) + "/default_template.css"
    @config = config
  end

  def render(html, output_file_path)
    PDFKit.configure do |c|
      c.wkhtmltopdf = @config.wkhtmltopdf_path
    end

    kit = PDFKit.new(html, :page_size => 'Letter')
    kit.stylesheets << @stylesheet
    kit.to_file output_file_path

    puts "*******************\nPrinted scrum cards to #{output_file_path}\n*******************\n"
  end
end