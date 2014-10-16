class DeliverEmailJob < Que::Job
  def run(mailer_class, mailer_method, *method_args)
    mailer_class.constantize.send(mailer_method, *method_args).deliver
  end
end
