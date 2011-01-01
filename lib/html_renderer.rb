require 'erb'

class HtmlRenderer

  def initialize(config)
    @template = config.template_erb || File.dirname(__FILE__) + "/default_template.erb"
  end

  def render(issues)
    rhtml = ERB.new(IO.read(@template))
    model = Model.new(issues)
    rhtml.result(model.get_binding)
  end

  private

  class Model
    def initialize(issues)
      @issues = issues
    end

    def get_binding()
      binding
    end
  end
end