# TODO: Something more flexible like https://gist.github.com/sj26/2026284
# Maybe with http://jasny.github.io/bootstrap/javascript.html#fileupload
# Will need SimpleForm.wrapper_mappings help
class ImageFileInput < SimpleForm::Inputs::FileInput
  def input
    template.safe_join([preview, super].compact)
  end

  def preview
    version = input_html_options.delete(:preview_version)
    use_default_url = options.delete(:use_default_url)
    preview_options = options.delete(:preview_html)

    uploader = object.send(attribute_name)
    uploader = uploader.send(version) if uploader && version

    if uploader || use_default_url
      template.image_tag(uploader.url, *Array(preview_options))
    end
  end
end
