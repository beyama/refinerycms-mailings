class Refinery::Mailings::LiquidFileSystem < Liquid::BlankFileSystem

  def read_template_file(path)
    template = MailingTemplate.find_by_slug(path)
    raise Liquid::FileSystemError, "No such template '#{path}'" if template.nil?
    template.body
  end
  
end