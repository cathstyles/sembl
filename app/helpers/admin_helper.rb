module AdminHelper
  # Like time_tag, but makes the default text a time ago and
  # includes a title attribute with full localized time
  def time_ago_tag time, *args
    options = args.extract_options!
    options.reverse_merge! title: l(time)

    text = args.shift
    text ||= "#{time_ago_in_words(time)} ago"

    time_tag time, text, *args, options
  end
end
