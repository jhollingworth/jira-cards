require 'pdfkit'

class PdfRenderer

  def initialize(config)
    @stylesheet = config.template_stylesheet 
    @config = config
  end

  def render(html, output_file_path)
    PDFKit.configure do |c|
      c.wkhtmltopdf = @config.wkhtmltopdf_path
    end

    kit = PDFKit.new(html, :page_size => 'Letter', :margin_left => 0, :margin_right => 0, :margin_bottom => 0, :margin_top => 0)
    kit.stylesheets << @stylesheet
    kit.to_file output_file_path

    puts "Printed scrum cards to #{output_file_path}"
  end
end